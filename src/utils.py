import re
import sys
from pathlib import Path
import subprocess
import resource
import copy
from functools import lru_cache, reduce

sys.path.append(str(Path(__file__).resolve().parents[2]))

from dotenv import load_dotenv
import os

load_dotenv()
tptp_root = os.getenv("TPTP_ROOT")
twee_bin = os.getenv("TWEE_PATH")

def run_twee_on_file(tptp_file, timeout=30, flags=[]):
    try:
        process = subprocess.Popen(
            [twee_bin, str(tptp_file), "--root", tptp_root] + [flag for x in flags for flag in x.split()] + ["--kbo-weight0-unary", "--print-score"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        try:
            usage_before = resource.getrusage(resource.RUSAGE_CHILDREN)
            stdout, stderr = process.communicate(timeout=timeout)
            usage_after = resource.getrusage(resource.RUSAGE_CHILDREN)
            user_cpu = usage_after.ru_utime - usage_before.ru_utime
            system_cpu = usage_after.ru_stime - usage_before.ru_stime
            total_cpu = user_cpu + system_cpu
            return {
                "file": str(tptp_file),
                "status": "success" if process.returncode == 0 else "failure",
                "exit_code": process.returncode,
                "output": stdout,
                "error": stderr,
                "user_cpu": user_cpu,
                "system_cpu": system_cpu,
                "total_cpu": total_cpu,
            }
        except subprocess.TimeoutExpired:
            process.kill()
            stdout, stderr = process.communicate()
            return {
                "file": str(tptp_file),
                "status": "timeout",
                "exit_code": None,
                "output": stdout,
                "error": stderr + "\n[Timeout after {} seconds]".format(timeout),
                "user_cpu": None,
                "system_cpu": None,
                "total_cpu": None,
            }
    except Exception as e:
        return {
            "file": str(tptp_file),
            "status": "error",
            "exit_code": None,
            "output": "",
            "error": str(e),
            "user_cpu": None,
            "system_cpu": None,
            "total_cpu": None,
        }

def extract_terms_from_rules(file_path):
    extracted_terms = []
    try:
        with open(file_path, 'r') as file:
            for line in file:
                # Strip whitespace
                line = line.strip()
                # Use regex to extract the number at the start and the part after '->' or '='
                match = re.match(r'^(\d+)\.\s*(.*?)\s*(?:->|=)\s*(.*)$', line)
                if match:
                    number = match.group(1)  # The number at the start
                    left_side = match.group(2)  # The part before '->' or '='
                    right_side = match.group(3)  # The part after '->' or '='
                    extracted_terms.append(right_side)
        return extracted_terms
    except FileNotFoundError:
        print(f"Error: The file '{file_path}' was not found.")
        return []
    except Exception as e:
        print(f"An error occurred: {e}")
        return []
    

def extract_terms_from_proof(text):
    # Find all Lemma blocks with their proofs
    lemma_blocks = re.findall(r'Proof:(.*?)(?=(?:Lemma\s+\d+:|RESULT|Goal|$))', text, re.DOTALL)
    extracted_terms = []
    for proof_text in lemma_blocks:
        lines = proof_text.strip().splitlines()

        for line in lines:
            stripped = line.strip()
            if stripped and not ('=' in stripped or 'by' in stripped):
                extracted_terms.append(stripped)

    return extracted_terms


def extract_terms(text, extraction_config=None):
    """
    Extract terms from twee output to pass to stitch.
    
    Args:
        text (str): The twee output to extract terms from.
        extraction_config (dict, optional): Configuration for extraction. Defaults to None.
        
    Returns:
        list: A list of extracted terms.
    """
    if extraction_config is None:
        return extract_terms_from_proof(text)
    
    extracted_terms = []
    if extraction_config.get("onlyTopLemmas", False):
        topk = extraction_config.get("topk", 20)
        interesting_lemmas = extract_strategy_1(text)[:topk]
        extracted_terms = reduce(lambda acc, lemma: acc + lemma[1]['proof_terms'], interesting_lemmas, [])
    elif extraction_config.get("onlyProofTerms", True):
        extracted_terms = extract_terms_from_proof(text)
    if extraction_config.get("onlyPeakTerms", False):
        extracted_terms = [term.replace("(peak)", "").strip() for term in extracted_terms if "(peak)" in term]
    else:
        extracted_terms = [term.replace("(peak)", "").strip() for term in extracted_terms]

    return extracted_terms

def as_cnf_axiom(term, id):
    """Wrap a term in TPTP cnf axiom delimeter."""
    return f"cnf(abstraction_{id}, axiom,\n\t ( {term} )).\n"

def as_cnf_hint(term, id):
    """Wrap a term in TPTP cnf hint delimeter."""
    return f"cnf(hint_{id}, axiom,\n\t $hint( {term} )).\n"

def parse_fof_term(term):
    """Parses a fof prefix term into a nested list structure."""
    stack = []
    current = []
    token = ''
    for i in range(len(term)):
        char = term[i]
        if char == '(':
            if token:
                stack.append((current, token.strip()))
                current = []
                token = ''
        elif char == ')':
            if token.strip():
                current.append(token.strip())
                token = ''
            prev, func = stack.pop()
            prev.append([func] + current)
            current = prev
        elif char == ',':
            if token.strip():
                current.append(token.strip())
                token = ''
        else:
            token += char
    return current[0] if current else token.strip()

def get_vars_in_term (term):
    """Extracts variables from a term."""
    return sorted(set(re.findall(r'\b[A-Z]\b', term)))

def name_body(name, body):
    """Create a named term representation."""
    vars = get_vars_in_term(body)
    if vars:
        return f"{name}({', '.join(vars)}) = {body}"
    else:
        return f"{name} = {body}"

def _canonical_var_stream():
    """
    Infinite stream of canonical variable names:
    A, B, C, ..., Z, A1, B1, ...
    """
    alphabet = [chr(ord('A') + i) for i in range(26)]
    k = 0
    while True:
        base = alphabet[k % 26]
        suffix = k // 26
        yield base if suffix == 0 else f"{base}{suffix}"
        k += 1

def _normalize_tree(tree, mapping, name_iter):
    """
    Recursively normalize a parsed term tree.
    """
    if isinstance(tree, str):
        # variable or '?' (we uniformly replace ? with a fresh variable...unknown if this is best)
        if re.fullmatch(r'[A-Z?]', tree):
            if tree not in mapping:
                mapping[tree] = next(name_iter)
            return mapping[tree]
        # constant / function symbol / other token: unchanged
        return tree

    # tree is a list: [f, arg1, arg2, ...]
    fun = tree[0]
    args = [ _normalize_tree(arg, mapping, name_iter) for arg in tree[1:] ]
    return [fun] + args

def _tree_to_str(tree):
    """Pretty-print the nested list term back to prefix syntax."""
    if isinstance(tree, str):
        return tree
    fun = tree[0]
    args = tree[1:]
    if not args:
        return fun
    return f"{fun}({', '.join(_tree_to_str(a) for a in args)})"

def normalize_fof_term(term_str):
    """
    Alpha-normalize a FOF prefix term string so that alpha-equivalent terms
    get the same canonical variable names based on order of first occurrence.
    """
    tree = parse_fof_term(term_str)
    mapping = {}
    name_iter = _canonical_var_stream()
    norm_tree = _normalize_tree(tree, mapping, name_iter)
    return _tree_to_str(norm_tree)

def normalize_equation(equation_str):
    """Alpha-normalize both sides of an equation."""
    if '=' not in equation_str:
        return normalize_fof_term(equation_str)
    lhs, rhs = equation_str.split('=', 1)
    norm_lhs = normalize_fof_term(lhs.strip())
    norm_rhs = normalize_fof_term(rhs.strip())
    return f"{norm_lhs} = {norm_rhs}"

def substitute(term, var_map):
    """Substitute variables in a term based on var_map."""
    if isinstance(term, str):
        return var_map.get(term, term)
    return [substitute(t, var_map) for t in term]

def expand_term(term, definitions):
    """Recursively expand all subterms in a term."""
    if isinstance(term, str):
        if term in definitions:
            param_names, body = definitions[term]
            if param_names:
                raise ValueError(f"Arity mismatch in call to {term}, expected 0 arguments")
            return expand_term(body, definitions)
        return term # either an original constant or variable
    if isinstance(term, list) and term:
        head, *args = term
        if head in definitions:
            param_names, body = definitions[head]
            if len(args) != len(param_names):
                raise ValueError(f"Arity mismatch in call to {head}")
            # We need to expand the arguments first
            # args = [expand_term(arg, definitions) for arg in args]
            # Map parameters to argument terms
            var_map = dict(zip(param_names, args))
            body_copy = copy.deepcopy(body)
            substituted = substitute(body_copy, var_map)
            return expand_term(substituted, definitions)
        else:
            # if head is of form "fn_i", means we are trying to use an abstraction that was previously established to be ill-formed
            if re.match(r'^fn_\d+$', head):
                raise ValueError(f"Use of ill formed function {head}")
            return [expand_term(t, definitions) for t in term]
    return term

def fully_expand_all(definitions):
    """Inline all function bodies fully so that no fn_i function applications remain."""
    expanded = {}
    # iterate over a snapshot of items so we can safely mutate `definitions`
    for fn_name, (params, body) in list(definitions.items()):
        try:
            expanded_body = expand_term(body, definitions)
        except ValueError as e:
            # remove ill-formed functions from the original definitions dict
            definitions.pop(fn_name, None)
            continue
        expanded[fn_name] = (params, expanded_body)
    expanded_strings = []
    for fn_name, (params, body) in expanded.items():
        params_string = f"({', '.join(params)})" if params else ''
        s = f"{fn_name}{params_string} = {to_fof(body)}"
        expanded_strings.append(s)
    return expanded_strings

def to_fof(tree):
        """Convert nested list back to prefix fo term string."""
        if isinstance(tree, str):
            return tree
        func = tree[0]
        args = ', '.join(to_fof(arg) for arg in tree[1:])
        return f"{func}({args})"


def expand_abstractions(abstractions):
    """Expand abstractions (input as list of strings)."""
    definitions = {}
    for abstraction in abstractions:
        # Split on '=' to separate function name and body
        if '=' not in abstraction:
            continue
        fn_name, body = abstraction.split('=', 1)
        fn_name = fn_name.strip()
        body = body.strip()

        # Extract parameters from the declaration
        match = re.match(r'(\w+)\((.*?)\)', fn_name)
        params = []
        if match:
            # it is not a constant function with no parameters
            params = [p.strip() for p in match.group(2).split(',')]
        fn_head = fn_name.split('(')[0].strip()
        definitions[fn_head] = (params, parse_fof_term(body))

    return fully_expand_all(definitions)

def is_variable(symbol):
    return isinstance(symbol, str) and re.match(r'^[A-Z]', symbol)

def extract_symbols_set(term):
    """
    Extract symbols with arities from a FOF prefix term.
    Returns a set of strings like {"f/2", "g/1", "a/0"}.
    """
    # Allow passing either a raw string or a parsed tree
    tree = parse_fof_term(term) if isinstance(term, str) else term

    symbols = set()

    def walk(node):
        if isinstance(node, list):
            if not node:
                return
            fun = node[0]
            arity = len(node) - 1
            symbols.add(f"{fun}/{arity}")
            for arg in node[1:]:
                walk(arg)
        else:
            # string leaf: constant/variable with arity 0
            s = node.strip() if isinstance(node, str) and not is_variable(node.strip()) else ""
            if s:
                symbols.add(f"{s}/0")

    walk(tree)
    return symbols


def extract_axioms_from_tptp_file(problem_file_path):
    """
    Given a TPTP problem file path, extract all axioms from the file and its includes.

    Args:
        problem_file_path (str): Path to the main TPTP problem file.

    Returns:
        List[str]: All axiom strings found in the files.
    """
    def read_file(path):
        with open(path, 'r') as f:
            return f.read()

    # Read main problem file
    problem_content = read_file(problem_file_path)

    # Find include file names
    include_pattern = re.compile(r"include\(\s*'([^']+)'\s*\)")
    include_files = include_pattern.findall(problem_content)

    include_paths = [os.path.join(tptp_root, inc) for inc in include_files]

    # Read included files
    included_contents = []
    for path in include_paths:
        if os.path.exists(path):
            included_contents.append(read_file(path))
        else:
            # raise FileNotFoundError(f"Included file not found: {path}")
            return []

    # Extract axioms
    axiom_pattern = re.compile(
        r'(?sm)^\s*cnf\s*\(\s*([A-Za-z][A-Za-z0-9_]*)\s*,\s*axiom\s*,\s*(?:\(\s*(.*?)\s*\)|(.*?))\s*\)\s*\.'
    )
    axioms = [m.group(2) if m.group(2) is not None else m.group(3) for m in axiom_pattern.finditer(problem_content)]
    for inc_content in included_contents:
        axioms += [m.group(2) if m.group(2) is not None else m.group(3) for m in axiom_pattern.finditer(inc_content)]

    axioms = [a.strip() for a in axioms]
    return axioms


def check_arity_consistency(symbols1, symbols2):
    """
    Checks that any function symbols occurring in both symbol sets has the same arity.

    Input:
        symbols1, symbols2: Sets of strings like 'f/2', 'g/1', 'a/0'

    Output:
        - True if arities match for all shared function names
        - False otherwise
    """
    def to_function_arity_map(symbols):
        result = {}
        for s in symbols:
            if '/' not in s:
                continue  # skip malformed
            name, arity = s.rsplit('/', 1)
            result.setdefault(name, set()).add(int(arity))
        return result

    map1 = to_function_arity_map(symbols1)
    map2 = to_function_arity_map(symbols2)

    shared_functions = set(map1.keys()) & set(map2.keys())
    for fname in shared_functions:
        if map1[fname] != map2[fname]:
            return False
    return True


def validate_abstraction(abstraction, problem_file_path):
    """function that takes an abstraction, e.g. '[fn_0(A, B) = ]join(meet(B, A), meet(A, join(B, A)))', and checks that all non-constant function symbols in the body (join, meet) appear in the axioms
    returned by extract_axioms_from_tptp_file, and that their arities match.
    Args:
        abstraction (str): The abstraction string.
        problem_file_path (str): Path to the TPTP problem file.
    Returns:
        bool: True if the abstraction is valid, False otherwise.
    """
    # Parse the abstraction
    body = abstraction
    if '=' in abstraction:
        _, body = abstraction.split('=', 1)
    body = body.strip()

    # Parse the body into a nested list
    body_term = parse_fof_term(body)

    # Extract symbols from the body
    body_symbols = extract_symbols_set(body_term)
    # remove the symbols with arity == 0 (constants)
    # NOT SURE WHY WE WERE DOING THe FOLLOWING LINE?? We do it because of goal flattening constants
    body_symbols = {s for s in body_symbols if not s.endswith('/0')}

    # Extract axioms from the TPTP file
    axioms = extract_axioms_from_tptp_file(problem_file_path)

    # Extract symbols from the axioms
    axiom_symbols = set()
    for axiom in axioms:
        # split the axiom into its lhs and rhs and parse both and extract symbols
        lhs, rhs = axiom.split('=', 1)
        lhs_term = parse_fof_term(lhs.strip())
        rhs_term = parse_fof_term(rhs.strip())
        axiom_symbols |= extract_symbols_set(lhs_term)
        axiom_symbols |= extract_symbols_set(rhs_term)
    # Check that all body symbols are in the axioms
    if body_symbols.issubset(axiom_symbols):
        return True
    
    # # Check arity consistency
    # if not check_arity_consistency(body_symbols, axiom_symbols):
    #     return False


    return False

def filter_out_higer_order_abstractions(abstractions):
    """Filter out expanded abstractions that use higher-order functions (functions that take functions as arguments)."""
    filtered = []
    for abstraction in abstractions:
        if '=' not in abstraction:
            continue
        _, body = abstraction.split('=', 1)
        body = body.strip()
        body_term = parse_fof_term(body)
        symbols = extract_symbols_set(body_term)
        higher_order = False
        for s in symbols:
            name, arity = s.rsplit('/', 1)
            if int(arity) > 0 and is_variable(name):
                higher_order = True
                break
        if not higher_order:
            filtered.append(abstraction)
    return filtered

def filter_out_uninteresting(abstractions):
    """Filter out abstractions that are just renamings of existing functions (e.g., fn_0(A, B) = join(A, B))."""
    filtered = []
    for abstraction in abstractions:
        if '=' not in abstraction:
            continue
        _, body = abstraction.split('=', 1)
        body = body.strip()
        body_term = parse_fof_term(body)
        # Check if the body is a single function application with all arguments being distinct variables
        if isinstance(body_term, list) and len(body_term) > 1:
            func = body_term[0]
            args = body_term[1:]
            if all(is_variable(arg) for arg in args) and len(set(args)) == len(args):
                continue
        filtered.append(abstraction)
    return filtered


##############################################################
# Faster and cached term analysis utilities (single-pass + memoization) #
##############################################################
from typing import Dict, Tuple, Any, List , FrozenSet

def freeze(term):
    """Recursively convert lists to tuples so `term` becomes hashable."""
    if isinstance(term, list):
        return tuple(freeze(x) for x in term)
    elif isinstance(term, tuple):
        return tuple(freeze(x) for x in term)
    return term  # str

@lru_cache(maxsize=None)
def analyze_parsed_term_cached(frozen_parsed) -> Tuple[int, FrozenSet[str]]:
    """
    Cached single-pass analysis over a *frozen* (tuple-only) parsed term.
    Returns (function_count_including_node, frozenset_of_unique_variables).
    """
    parsed = frozen_parsed  # already frozen / hashable

    if isinstance(parsed, str):
        if is_variable(parsed):
            return (0, frozenset({parsed}))
        else:
            # constant or 0-arity function symbol
            return (1, frozenset())

    # parsed is a tuple like (f, arg1, arg2, ...)
    func_count = 1  # count this node's function symbol
    vars_acc = set()
    for arg in parsed[1:]:
        fc, vs = analyze_parsed_term_cached(arg)
        func_count += fc
        vars_acc.update(vs)
    return (func_count, frozenset(vars_acc))

def analyze_parsed_term(parsed) -> Tuple[int, FrozenSet[str]]:
    """Convenience wrapper that freezes and uses the cached analyzer."""
    return analyze_parsed_term_cached(freeze(parsed))

@lru_cache(maxsize=None)
def parse_fof_term_cached(term: str):
    return parse_fof_term(term)

@lru_cache(maxsize=None)
def term_weight(term: str) -> int:
    """
    Weight = (#function symbols) + (#unique variables) for a single term string.
    """
    parsed_term = parse_fof_term_cached(term)
    fc, vars_ = analyze_parsed_term(parsed_term)
    return fc + len(vars_)

########################################
# Statement scoring (precompute once)  #
########################################

def statement_score_from_strings(lhs: str, rhs: str) -> int:
    lp = parse_fof_term_cached(lhs.strip())
    rp = parse_fof_term_cached(rhs.strip())
    lf, lvars = analyze_parsed_term(lp)
    rf, rvars = analyze_parsed_term(rp)
    return lf + rf + len(lvars | rvars)

def compute_statement_scores(lemma_blocks: Dict[int, Dict[str, Any]]) -> Dict[int, int]:
    """
    For each lemma, compute and store the statement score once.
    """
    out = {}
    for ln, lemma in lemma_blocks.items():
        statement = lemma.get('statement', '')
        if not statement or '=' not in statement:
            out[ln] = 0
            continue
        lhs, rhs = statement.split('=', 1)
        out[ln] = statement_score_from_strings(lhs, rhs)
    return out

#####################################
# Memoized Proof score over the lemma DAG
#####################################

def compute_proof_scores(lemma_blocks: Dict[int, Dict[str, Any]]) -> Dict[int, int]:
    """
    Sum term weights along each lemma's proof terms plus all ancestors (parent_lemmas).
    Runs a single DFS over the DAG with memoization.
    """

    @lru_cache(maxsize=None)
    def dfs(ln: int) -> int:
        lemma = lemma_blocks.get(ln)
        if not lemma:
            return 0
        s = 0
        for t in lemma.get('proof_terms', []):
            s += term_weight(t)
        for p in lemma.get('parent_lemmas', []):
            s += dfs(p)
        return s

    return {ln: dfs(ln) for ln in lemma_blocks}


def make_lemma_scorer(lemma_blocks: Dict[int, Dict[str, Any]]):
    """
    Precompute all scores once, return a fast scorer callable.
    """
    statement_scores = compute_statement_scores(lemma_blocks)
    proof_scores = compute_proof_scores(lemma_blocks)

    def score(lemma_number: int) -> float:
        sstmt = statement_scores.get(lemma_number, 0)
        if sstmt == 0:
            return 0.0
        return proof_scores.get(lemma_number, 0) / (sstmt * sstmt)

    return score


def extract_strategy_1(proof_text: str) -> List[Tuple[int, Dict[str, Any]]]:
    """
    Extract terms from (possibly partial) proof text using strategy 1,
    then return lemmas sorted by descending complexity score.
    """
    lemma_block_matches = re.findall(
        r'Lemma\s(\d+):(.*?)Proof:(.*?)(?=(?:Lemma\s+\d+:|Goal|RESULT|$))',
        proof_text,
        re.DOTALL
    )

    lemma_blocks: Dict[int, Dict[str, Any]] = {}
    for n, lemma_statement, body in lemma_block_matches:
        try:
            lemma_number = int(n)
        except ValueError:
            continue

        block = {
            'statement': lemma_statement.strip().replace('.', ''),
            'proof_terms': [],
            'parent_lemmas': [],
        }

        lines = body.strip().splitlines()
        for line in lines:
            stripped = line.strip()
            if not stripped:
                continue
            # Parent lemma lines like: "= { by lemma 12 ... }"
            parent_lemma_match = re.match(r'= \{\s*by lemma (\d+)', stripped)
            if parent_lemma_match:
                block['parent_lemmas'].append(int(parent_lemma_match.group(1)))
            elif ('=' not in stripped) and ('by' not in stripped):
                block['proof_terms'].append(stripped)

        lemma_blocks[lemma_number] = block

    # Precompute + sort
    scorer = make_lemma_scorer(lemma_blocks)
    complex_lemmas = sorted(lemma_blocks.items(), key=lambda x: scorer(x[0]), reverse=True)
    return complex_lemmas


if __name__ == "__main__":
    # Example input
    # abstractions = [
    #     "fn_0(A, B, C) = meet(A, join(B, C))",
    #     "fn_1(A) = fn_0(A, A, A)",
    #     "fn_2(A) = fn_1(fn_0(A, A, A))",
    # ]
    # abstractions = ['fn_0(A, B) = multiply(B, multiply(A, identity))',
    #  'fn_1(A) = multiply(A, A)',
    #  'fn_2(A, B) = multiply(A, B(A))',
    #  'fn_3(A) = multiply(A, identity)',
    #  'fn_4(A) = multiply(identity, A)',
    #  'fn_5(A, B) = fn_0(fn_0(B, A), fn_1(A))',
    #  'fn_6(A) = fn_2(identity, fn_0(A))',
    #  'fn_7(A, B, C) = C(multiply(C(B), A))',
    #  'fn_8(A) = fn_2(A, fn_1)', 
    #  'fn_9(A, B) = fn_0(multiply(A, B), A)']

    # expanded = expand_abstractions(filter_out_higer_order_abstractions(abstractions))
    # print(expanded)
    # extract_strategy_1("")
    # with open("src/stitch/sample_proof.out", "r") as f:
    #     proof_text = f.read()
    # cts = extract_strategy_1(proof_text)[:20]
    # print(cts)
    # print(normalize_fof_term("join(complement(composition(C, A)), composition(B, A))"))
    # print(normalize_fof_term("apply(apply(apply(C, B), A), D)"))
    print(normalize_fof_term("ldiv(rdiv(?, a(A, B, inv(B))), rdiv(rdiv(?, a(A, B, inv(B))), a(A, B, B))) (peak)"))

    # axs = extract_axioms_from_tptp_file("data/TPTP/GRP_UEQ_UNSAT/GRP002-3.p")
    # pass