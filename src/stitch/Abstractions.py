import re
from stitch_core import compress, rewrite

# From https://stitch-bindings.readthedocs.io/en/stable/index.html:
# Each program is a string written in a lisp-like lambda calculus syntax:
# Variables should be written as de Bruijn indices (i.e. $i refers to the variable bound by the i th lambda above it) so λx. λy. x y is written (lam (lam ($1 $0)))
# Lambdas need explicit parentheses around their body so (lam + 3 2) should instead be written (lam (+ 3 2)). The parser outputs an error message explaining this if you make this mistake. Lambdas can also be written with lambda instead of lam but the output of stitch will always be normalized to use lam.
# Be sure to balance your parentheses or you will get an error.
# You don’t need to pre-define the language you are using. Any series of tokens with no whitespace that isn’t reserved for something else is treated as a language primitive, like +, foo, -0.5 etc. Only app and lam are reserved. Primitives may not begin with # or $ and may not contain parentheses or whitespace.


# ----------------------------
# Module-level helper functions, mainly for translation between lisp-like and first-order terms
# ----------------------------

_HASH_RE = re.compile(r'#(\d+)$')
_DEBRUIJN_RE = re.compile(r'\$(\d+)$')


def parse_fof_term(term: str):
    # TODO: handle infix -- or require term to be in prefix form
    """Parses a fof prefix term into a nested list structure."""
    stack = []
    current = []
    token = ''
    for char in term:
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


def to_lisp(term_tree):
    """Converts parsed term to lisp-style lambda abstraction body."""
    if isinstance(term_tree, str):
        return term_tree
    return '(' + ' '.join(to_lisp(x) for x in term_tree) + ')'


def convert_variables(expr: str, bound_vars):
    """Replaces variable names with De Bruijn indices."""
    def replace_var(token: str) -> str:
        if re.fullmatch(r'[A-Z]', token):
            if token in bound_vars:
                index = len(bound_vars) - 1 - bound_vars[::-1].index(token)
                return f"${index}"
            raise ValueError(f"Unbound variable: {token}")
        return token

    tokens = re.findall(r'\(|\)|[^\s()]+', expr)
    new_tokens = [replace_var(tok) if tok not in '()' else tok for tok in tokens]
    return ''.join(
        f' {tok}' if tok not in ')' and i > 0 and tokens[i-1] != '(' else tok
        for i, tok in enumerate(new_tokens)
    )


def wrap_with_lambdas(expr: str, var_count: int) -> str:
    if var_count == 0:
        var_count = 1
    return "(lam " * var_count + f"{expr}" + ")" * var_count


def get_vars_in_term(term: str):
    """Extracts variables from a term."""
    return sorted(set(re.findall(r'\b[A-Z]\b', term)))


def fof_to_lambda(term: str) -> str:
    """
        We embed first-order equational terms into a restricted fragment of the untyped
        lambda calculus. Intuitively, a first-order term is viewed as a tree of function
        applications whose free variables are turned into explicit parameters by adding
        lambda abstractions at the outermost level. Function symbols are treated as
        constants, and variable occurrences are represented using De Bruijn indices.
        stitch operates on these lambda terms.

        The target language is a Lisp-style, untyped lambda calculus with explicit
        lambda abstractions and implicit application, where application is
        represented by syntactic juxtaposition inside parenthesized lists. Variables are represented using
        De Bruijn indices. No reduction semantics or typing discipline is assumed; only
        the syntactic structure of terms is relevant.

        Let t be a first-order term with free variables x1, . . . , xk. The embedding |t|
        is defined as follows:
            - Each function symbol f is treated as a constant symbol in the lambda calculus.
            - A term f (t1, . . . , tn) is translated to a lambda-term application (f |t1| . . . |tn|).
            - All free variables are abstracted at the outermost level by introducing k
        nested lambda abstractions. Variable occurrences are replaced by De Bruijn
        indices referring to these binders.
        Thus every first-order term is embedded as a closed lambda term consisting of as
        many outer lambda abstractions as the number of free variables of the original
        first-order term. The resulting lambda terms contain no internal binding and no
        higher-order structure beyond top-level lambdas.
    """
    vars_in_term = get_vars_in_term(term)
    term_tree = parse_fof_term(term)
    lisp_expr = to_lisp(term_tree)
    lisp_expr_with_indices = convert_variables(lisp_expr, vars_in_term)
    return wrap_with_lambdas(lisp_expr_with_indices, len(vars_in_term))


def parse_lisp_body(expr: str):
    """Parse lisp-style lambda abstraction body to a nested list."""
    tokens = re.findall(r'\(|\)|[^\s()]+', expr)
    stack = []
    current = []
    for tok in tokens:
        if tok == '(':
            stack.append(current)
            current = []
        elif tok == ')':
            last = current
            current = stack.pop()
            current.append(last)
        else:
            current.append(tok)
    return current[0] if current else []


def hash_to_var(index: int) -> str:
    if 0 <= index < 26:
        return chr(ord('A') + index)
    raise ValueError(f"Too many variables: index {index}")


def index_to_var(index: int, offset: int) -> str:
    """Map $index to a variable name, starting after `offset` names."""
    j = offset + index
    if 0 <= j < 26:
        return chr(ord('A') + j)
    raise ValueError(f"Too many variables: offset {offset}, index {index}")


def collect_hash_indices(tree) -> set[int]:
    """Collect all distinct #i occurrences in the tree."""
    if isinstance(tree, str):
        m = _HASH_RE.fullmatch(tree)
        return {int(m.group(1))} if m else set()
    out = set()
    for x in tree:
        out |= collect_hash_indices(x)
    return out


def convert_hashes_to_vars(tree, hash_index_set: set[int]):
    """
    Replace #i with variable names.
    Deterministic: #0->A, #1->B, ...
    """
    if isinstance(tree, str):
        m = _HASH_RE.fullmatch(tree)
        if m:
            idx = int(m.group(1))
            return hash_to_var(idx)
        return tree
    return [convert_hashes_to_vars(x, hash_index_set) for x in tree]


def convert_debruijn_to_vars(tree, offset: int):
    """Replace $i with variable names starting from offset, deterministically."""
    if isinstance(tree, str):
        m = _DEBRUIJN_RE.fullmatch(tree)
        if m:
            idx = int(m.group(1))
            return index_to_var(idx, offset=offset)
        return tree
    return [convert_debruijn_to_vars(x, offset) for x in tree]


def to_fof(tree):
    """Convert nested list back to prefix fo term style."""
    if isinstance(tree, str):
        return tree
    func = tree[0]
    args = ', '.join(to_fof(arg) for arg in tree[1:])
    return f"{func}({args})"


def remove_lambdas(tree):
    """Remove lambda abstractions from the tree."""
    if isinstance(tree, str):
        return tree
    if tree and tree[0] == 'lam':
        return remove_lambdas(tree[1])
    return [remove_lambdas(x) for x in tree]


class Stitch_Abstractions:
    def __init__(self, terms, iterations=1, max_arity=2):
        self.terms = terms
        self.arities = {}
        self.derive_arities(terms)
        self.lisp_style_terms = [fof_to_lambda(term) for term in terms]
        self.stitch_compression = compress(self.lisp_style_terms, iterations=iterations, max_arity=max_arity)
        self.stitch_abstractions = self.stitch_compression.abstractions
        self.fo_abstractions = [self.to_fo_abstraction(abstraction) for abstraction in self.stitch_abstractions]

    def uncurry(self, tree):
        used_vars = get_vars_in_term(to_fof(tree))
        if not used_vars:
            used_vars.append(chr(ord('A') - 1))  # Default variable if none are used
        if tree[0] in self.arities:
            arity = self.arities[tree[0]]
            diff = arity - (len(tree) - 1)
            if diff > 0:
                for i in range(diff):
                    tree.append(chr(ord(used_vars[-1]) + i + 1))
        return tree

    def derive_arities(self, terms):
        def traverse_tree(tree):
            if isinstance(tree, str):
                return
            func = tree[0]
            if func not in self.arities:
                self.arities[func] = len(tree) - 1
            for arg in tree[1:]:
                traverse_tree(arg)

        for term in terms:
            tree = parse_fof_term(term)
            traverse_tree(tree)

        return self.arities

    def to_fo_abstraction(self, abstraction):
        """
        Those abstractions whose bodies still have a first-order shape are translated
        back, yielding equational terms.

        Stitch introduces abstractions of the form
        g(#0, #1, . . . ) := s,
        where #0, #1, . . . are schematic parameters. These parameters act as placehold-
        ers for subterms and are instantiated positionally when the abstraction is ap-
        plied. The abstraction body s is itself a lambda term that may contain schematic
        parameters, De Bruijn indices, applications, and lambda abstractions.

        The back-translation proceeds by mapping schematic parameters #j to fresh
        first-order variables, mapping De Bruijn indices to additional variables that are
        chosen to be disjoint from the former, and then removing all lambda
        abstractions. If the resulting term contains a partially applied function
        symbol, missing arguments are filled using arity information inferred from the
        original first-order problem.
        There are, however, lambda terms for which no such consistent first-order
        interpretation exists. These are filtered out at a later stage. However, 
        given that the terms we input to Stitch consist exclusively of lambda terms obtained
        from first-order equational terms via the embedding described above, the bodies
        s of discovered abstractions are, in practice, usually first-order in shape.
        """
        lisp_expr = abstraction.body
        name = abstraction.name

        tree = parse_lisp_body(lisp_expr)

        # extract hash vars first
        hash_indices = collect_hash_indices(tree)
        tree = convert_hashes_to_vars(tree, hash_indices)

        # Offset by highest hash index + 1 (or 0 if none)
        offset = 1 + max(hash_indices) if hash_indices else 0
        tree = convert_debruijn_to_vars(tree, offset=offset)

        tree = remove_lambdas(tree)
        tree = self.uncurry(tree) #uncurrying depends on the derived arities of the function symbols.
        body = to_fof(tree)

        vars_ = get_vars_in_term(body)
        if vars_:
            decl = f"{name}({', '.join(vars_)})"
        else:
            decl = name
        return f"{decl} = {body}"
