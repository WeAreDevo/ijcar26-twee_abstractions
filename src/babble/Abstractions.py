"""
Library learning with babble (https://github.com/dcao/babble) as an alternative
to Stitch.

`Babble_Abstractions` mirrors the interface of `Stitch_Abstractions`:

    Babble_Abstractions(terms, iterations=1, max_arity=2).fo_abstractions
        -> ["fn_0(A, B) = f(A, g(B))", "fn_1(A) = fn_0(A, A)", ...]

so everything downstream in `src/utils.py` (`expand_abstractions`,
`filter_out_uninteresting`, `filter_out_higer_order_abstractions`,
`as_cnf_hint`) consumes it unchanged.

Two things differ from Stitch and drive the translation code below:

1. babble's application is *curried*. Stitch writes f(A,B) as `(f $0 $1)`;
   babble writes it as `(@ (@ f $1) $0)`. So the encoder builds `@` spines and
   the decoder collapses them back to n-ary application.

2. babble has no `#i` schematic parameters. An abstraction is a `lib` binding
   whose definition is a chain of lambdas, `(lib l0 (λ (λ body)) rest)`; the
   parameters are those leading lambdas, referenced by de Bruijn index inside
   `body`. So there is no `#i` decoding step, and the parameters and the
   ordinary variables are the same thing.

babble is a Rust binary, not a Python package, so this module shells out to it.
See the README for how to build it and set `BABBLE_ROOT`.
"""

import os
import re
import subprocess
import tempfile
from pathlib import Path

from dotenv import load_dotenv

# The FOF-side helpers are engine-agnostic; reuse them rather than copying.
from src.stitch.Abstractions import (
    get_vars_in_term,
    parse_fof_term,
    to_fof,
)

load_dotenv()

babble_root = os.getenv("BABBLE_ROOT")

# babble's ListOp language reserves these tokens, and its `Ident` fallback is
# only reached for strings that match none of them. A first-order symbol that
# collided would be silently reinterpreted -- `l0` as a library variable, `3`
# as an integer literal, `if` as a conditional. Rather than enumerate the
# hazards, every symbol is prefixed on the way in and stripped on the way out;
# `s_` cannot begin an integer, a `$n` index, an `l<n>` lib id, or a keyword.
_MANGLE_PREFIX = "s_"

_DEBRUIJN_RE = re.compile(r'\$(\d+)$')

# Tokens are parens, double-quoted strings (egg quotes operators containing a
# space, so a lib binding head prints as `"lib l35"`), or runs of non-space.
_TOKEN_RE = re.compile(r'\(|\)|"[^"]*"|[^\s()]+')

_RESULT_RE = re.compile(
    r'^BABBLE_RESULT_BEGIN$\n(.*?)\n^BABBLE_RESULT_END$',
    re.MULTILINE | re.DOTALL,
)


class NotFirstOrder(Exception):
    """A library definition with no first-order reading."""


# ----------------------------
# FOF -> babble
# ----------------------------

def mangle(symbol: str) -> str:
    return _MANGLE_PREFIX + symbol


def demangle(symbol: str) -> str:
    return symbol[len(_MANGLE_PREFIX):] if symbol.startswith(_MANGLE_PREFIX) else symbol


def to_curried(tree, render_var):
    """
    Convert a parsed FOF term to a curried babble application spine.

    `render_var` maps a variable name to its babble spelling, and returns None
    for anything that is not a variable. Applying f to n arguments becomes n
    nested binary applications:

        f(A, B)  ->  (@ (@ s_f $0) $1)

    Corpus terms render variables as de Bruijn indices (`$i`); rewrite rules
    in `theory.py` render them as egg pattern variables (`?v0`) instead.
    """
    if isinstance(tree, str):
        rendered = render_var(tree)
        return rendered if rendered is not None else mangle(tree)
    expr = mangle(tree[0])
    for arg in tree[1:]:
        expr = f"(@ {expr} {to_curried(arg, render_var)})"
    return expr


def fof_to_babble(term: str) -> str:
    """
    Embed a first-order term as a closed babble lambda term.

    This is the curried counterpart of `fof_to_lambda` in the Stitch module:
    the k free variables become k lambdas at the outermost level, and variable
    occurrences become de Bruijn indices referring to them.

        f(A,B)  ->  (lambda (lambda (@ (@ s_f $1) $0)))

    Note the ordering: `$0` refers to the *innermost* binder, so with the
    variables sorted A, B, ... the variable at sorted position i gets index i
    and A ends up bound by the innermost lambda.
    """
    vars_in_term = get_vars_in_term(term)
    var_indices = {v: i for i, v in enumerate(vars_in_term)}
    body = to_curried(
        parse_fof_term(term),
        lambda tok: f"${var_indices[tok]}" if tok in var_indices else None,
    )
    # A ground term still gets one lambda, matching `wrap_with_lambdas`.
    depth = max(len(vars_in_term), 1)
    return "(lambda " * depth + body + ")" * depth


# ----------------------------
# babble -> FOF
# ----------------------------

def parse_sexp(expr: str):
    """Parse an s-expression into a nested list. Quoted tokens keep their text."""
    tokens = _TOKEN_RE.findall(expr)
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
            current.append(tok.strip('"'))
    return current[0] if current else []


def normalize_lambdas(tree):
    """Rewrite babble's unicode `λ` head to `lambda` so the rest can match on it."""
    if isinstance(tree, str):
        return "lambda" if tree == "λ" else tree
    return [normalize_lambdas(x) for x in tree]


def collect_libs(tree):
    """
    Walk the nested `(lib l<n> <definition> <body>)` chain and return
    [(lib_id, definition_tree), ...].

    babble emits the chain outermost-first. An inner definition may refer to an
    outer library variable but not the reverse, so this order already satisfies
    the "abstraction i only references j < i" invariant that
    `expand_abstractions` relies on -- provided we keep it.
    """
    libs = []
    while isinstance(tree, list) and len(tree) == 3 and str(tree[0]).startswith("lib "):
        lib_id = str(tree[0]).split()[1]
        libs.append((lib_id, tree[1]))
        tree = tree[2]
    return libs


def strip_lambdas(tree):
    """Split a definition into (number of leading lambdas, body)."""
    depth = 0
    while isinstance(tree, list) and len(tree) == 2 and tree[0] == "lambda":
        depth += 1
        tree = tree[1]
    return depth, tree


def contains_lambda(tree) -> bool:
    """Whether a lambda survives anywhere in the tree.

    First-order terms embed with lambdas only at the very top, so a lambda
    left inside a definition body means genuine higher-order structure.
    """
    if isinstance(tree, str):
        return False
    if tree and tree[0] == "lambda":
        return True
    return any(contains_lambda(x) for x in tree)


def uncurry_applications(tree):
    """
    Collapse curried `@` spines back into n-ary application.

        (@ (@ f x) y)  ->  [f, x, y]

    A spine whose head is a variable (`$i`) or a library variable stays as a
    list headed by that variable, which is exactly the shape
    `filter_out_higer_order_abstractions` recognises and drops.
    """
    if isinstance(tree, str):
        return tree
    if len(tree) == 3 and tree[0] == "@":
        head = uncurry_applications(tree[1])
        arg = uncurry_applications(tree[2])
        if isinstance(head, list):
            return head + [arg]
        return [head, arg]
    return [uncurry_applications(x) for x in tree]


def convert_indices_to_vars(tree, depth: int):
    """
    Replace de Bruijn indices with variable names, inverting `fof_to_babble`:
    `$i` becomes the i-th letter, so encoding and decoding round-trip to the
    same term.

    Which binder gets which letter is only a naming choice -- the parameters
    are distinct either way, and downstream only the right-hand side of the
    abstraction is used as a hint. Inverting the encoder is simply the choice
    that keeps the translation testable.

    An index of `depth` or more would refer to a binder outside the
    definition, which no first-order term can.
    """
    if isinstance(tree, str):
        m = _DEBRUIJN_RE.fullmatch(tree)
        if m:
            index = int(m.group(1))
            if not 0 <= index < min(depth, 26):
                raise NotFirstOrder(
                    f"de Bruijn index {tree} is out of range at depth {depth}"
                )
            return chr(ord('A') + index)
        return tree
    return [convert_indices_to_vars(x, depth) for x in tree]


def demangle_symbols(tree, lib_names):
    """Undo symbol mangling, and rename library variables `l<n>` to `fn_<n>`."""
    if isinstance(tree, str):
        if tree in lib_names:
            return lib_names[tree]
        return demangle(tree)
    return [demangle_symbols(x, lib_names) for x in tree]


class Babble_Abstractions:
    def __init__(self, terms, iterations=1, max_arity=2, dsrs=None, beams=400,
                 dsr_node_limit=100_000, timeout=300):
        """
        `iterations` maps onto babble's `--rounds` so that callers written
        against `Stitch_Abstractions` keep working; the two are not
        numerically comparable, they just both mean "compress harder".

        `dsrs` is the equational theory to compress modulo: a path to a babble
        rewrites file, or a list of rules from `src.babble.theory`, which
        builds them from a TPTP problem's axioms. `dsr_node_limit` bounds the
        e-graph while the theory is saturated -- with associativity and
        commutativity in play it is what keeps a run finite.
        """
        self.terms = terms
        self.arities = {}
        self.derive_arities(terms)
        self.babble_style_terms = [fof_to_babble(term) for term in terms]
        self.stdout = run_babble(
            self.babble_style_terms,
            max_arity=max_arity,
            rounds=iterations,
            beams=beams,
            dsrs=dsrs,
            dsr_node_limit=dsr_node_limit,
            timeout=timeout,
        )
        self.initial_cost, self.final_cost, self.compression_ratio = parse_costs(self.stdout)
        self.babble_abstractions = parse_babble_output(self.stdout)

        # babble's `l<n>` ids -> the `fn_<n>` names callers expect.
        # `expand_abstractions` in src/utils.py matches references by the
        # `fn_\d+` pattern, and `l0` could additionally collide with a TPTP
        # function symbol of that name.
        self.lib_names = {
            lib_id: f"fn_{i}"
            for i, (lib_id, _) in enumerate(self.babble_abstractions)
        }

        # Definitions with genuine higher-order structure (an internal lambda,
        # or an index reaching outside the definition) have no first-order
        # reading at all and are dropped here. Variable-headed applications do
        # have one, so they are emitted and left to
        # `filter_out_higer_order_abstractions` in src/utils.py.
        self.fo_abstractions = []
        self.skipped = []
        for lib_id, body in self.babble_abstractions:
            try:
                self.fo_abstractions.append(
                    self.to_fo_abstraction(self.lib_names[lib_id], body)
                )
            except NotFirstOrder as e:
                self.skipped.append((self.lib_names[lib_id], str(e)))

    def uncurry(self, tree):
        """Pad a partially applied symbol out to its arity in the input problem."""
        used_vars = get_vars_in_term(to_fof(tree))
        if not used_vars:
            used_vars.append(chr(ord('A') - 1))
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
            traverse_tree(parse_fof_term(term))

        return self.arities

    def to_fo_abstraction(self, name, body_tree):
        """
        Translate one library definition back into a first-order equation
        `fn_0(A, B) = f(A, g(B))`.

        The steps mirror `Stitch_Abstractions.to_fo_abstraction`, minus the
        `#i` handling that babble does not need, plus the un-currying that it
        does.

        Raises `NotFirstOrder` if the definition cannot be read as a
        first-order term.
        """
        depth, body = strip_lambdas(body_tree)
        if contains_lambda(body):
            raise NotFirstOrder("definition contains an internal lambda")

        tree = uncurry_applications(body)
        tree = convert_indices_to_vars(tree, depth)
        tree = demangle_symbols(tree, self.lib_names)

        if isinstance(tree, str):
            # A definition that is a bare symbol or variable.
            return f"{name} = {tree}"

        tree = self.uncurry(tree)
        fof_body = to_fof(tree)

        vars_ = get_vars_in_term(fof_body)
        decl = f"{name}({', '.join(vars_)})" if vars_ else name
        return f"{decl} = {fof_body}"


def parse_costs(stdout: str):
    """Pull the initial/final cost out of the binary's output."""
    initial = re.search(r'^BABBLE_INITIAL_COST (\d+)$', stdout, re.MULTILINE)
    final = re.search(r'^BABBLE_FINAL_COST (\d+)$', stdout, re.MULTILINE)
    if not initial or not final:
        return None, None, None
    initial_cost, final_cost = int(initial.group(1)), int(final.group(1))
    ratio = initial_cost / final_cost if final_cost else None
    return initial_cost, final_cost, ratio


def parse_babble_output(stdout: str):
    """Extract [(lib_id, definition_tree), ...] from the binary's output."""
    match = _RESULT_RE.search(stdout)
    if not match:
        raise ValueError(f"No babble result block found in output:\n{stdout}")
    tree = normalize_lambdas(parse_sexp(match.group(1)))
    return collect_libs(tree)


def run_babble(programs, max_arity=2, rounds=1, beams=400, lps=1, dsrs=None,
               dsr_node_limit=100_000, timeout=300):
    """
    Run the `fof` binary over a corpus of babble-encoded programs.

    `dsrs` is the equational theory to compress modulo: either a path to a
    babble rewrites file, or a list of rule strings as produced by
    `src.babble.theory` (which is written to a temporary file here). An empty
    list means no theory, and `--dsr` is omitted.

    The binary is invoked from `BABBLE_ROOT` because babble resolves some of
    its own paths relative to the working directory.
    """
    if not babble_root:
        raise RuntimeError(
            "BABBLE_ROOT is not set. Add it to .env and build the binary; "
            "see the README section 'Optional: the babble compression backend'."
        )
    binary = Path(babble_root) / "target" / "release" / "fof"
    if not binary.exists():
        raise RuntimeError(
            f"babble binary not found at {binary}. Build it with:\n"
            f"    cd {babble_root} && cargo build --release --bin=fof"
        )

    corpus = "(list\n" + "\n".join(programs) + ")\n"
    with tempfile.NamedTemporaryFile("w", suffix=".bab", delete=False) as f:
        f.write(corpus)
        corpus_path = f.name

    # A list of rules needs a file of its own; a path is used as given.
    dsr_path, temp_dsr_path = None, None
    if isinstance(dsrs, (list, tuple)):
        if dsrs:
            with tempfile.NamedTemporaryFile("w", suffix=".rewrites", delete=False) as f:
                f.write("".join(f"{rule}\n" for rule in dsrs))
                dsr_path = temp_dsr_path = f.name
    elif dsrs is not None:
        dsr_path = str(dsrs)

    cmd = [
        str(binary), corpus_path,
        "--beams", str(beams),
        "--lps", str(lps),
        "--rounds", str(rounds),
    ]
    if max_arity is not None:
        cmd += ["--max-arity", str(max_arity)]
    if dsr_path is not None:
        cmd += ["--dsr", dsr_path, "--dsr-node-limit", str(dsr_node_limit)]

    try:
        result = subprocess.run(
            cmd, cwd=babble_root, capture_output=True, text=True, timeout=timeout
        )
    finally:
        os.unlink(corpus_path)
        if temp_dsr_path:
            os.unlink(temp_dsr_path)

    if result.returncode != 0:
        raise RuntimeError(
            f"babble failed (exit {result.returncode}):\n{result.stderr}"
        )
    return result.stdout
