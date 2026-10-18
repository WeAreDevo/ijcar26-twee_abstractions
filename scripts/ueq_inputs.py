"""Read unit-equality TPTP inputs and render the FOF form Krympa expects.

This deliberately rejects syntax outside the unit-equality fragment rather
than guessing at a conversion. Includes (including selected names) are expanded.
"""
import re
from pathlib import Path


def without_comments(text):
    # Keep quoted atoms intact, including escaped quotes and percent signs.
    token = r"'(?:\\.|[^'\\])*'|\"(?:\\.|[^\"\\])*\"|%[^\n]*|/\*[\s\S]*?\*/"
    return re.sub(token, lambda m: m[0] if m[0][0] in "'\"" else " ", text)


def split_top(text, separator):
    parts, start, stack, quote, escaped = [], 0, [], None, False
    for i, char in enumerate(text):
        if quote:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == quote:
                quote = None
        elif char in "'\"":
            quote = char
        elif char in "([":
            stack.append(char)
        elif char in ")]":
            if not stack or stack.pop() != {')': '(', ']': '['}[char]:
                raise ValueError("Unbalanced TPTP delimiters")
        elif char == separator and not stack:
            parts.append(text[start:i].strip())
            start = i + 1
    if stack or quote:
        raise ValueError("Unclosed TPTP delimiter/quote")
    parts.append(text[start:].strip())
    return parts


def clauses(path, tptp_root, ancestors=()):
    path = Path(path).resolve()
    if path in ancestors:
        raise ValueError(f"Cyclic TPTP include: {path}")
    for statement in split_top(without_comments(path.read_text()), '.'):
        if not statement:
            continue
        match = re.fullmatch(r"(cnf|include)\s*\((.*)\)", statement, re.S)
        if not match:
            raise ValueError(f"Expected CNF unit equality or include in {path}: {statement[:80]}")
        args = split_top(match[2], ',')
        if match[1] == 'include':
            if len(args) not in (1, 2) or not re.fullmatch(r"'[^']+'", args[0]):
                raise ValueError(f"Unsupported include: {statement}")
            name = args[0][1:-1]
            included = path.parent / name
            if not included.is_file():
                included = Path(tptp_root) / name
            entries = list(clauses(included, tptp_root, ancestors + (path,)))
            if len(args) == 2:
                if not args[1].startswith('[') or not args[1].endswith(']'):
                    raise ValueError(f"Invalid include selection: {statement}")
                wanted = set(split_top(args[1][1:-1], ',')) - {''}
                if wanted - {e[0] for e in entries}:
                    raise ValueError(f"Missing selected axioms in {included}")
                entries = [e for e in entries if e[0] in wanted]
            yield from entries
        else:
            if len(args) != 3:
                raise ValueError(f"Unsupported annotated CNF: {statement[:80]}")
            yield tuple(args)


def krympa_input(path, tptp_root):
    axioms, goals = [], []
    for name, role, formula in clauses(path, tptp_root):
        formula = formula.strip()
        # Strip only outer parentheses enclosing the complete formula.
        while formula.startswith('(') and formula.endswith(')'):
            try:
                split_top(formula[1:-1], ',')
            except ValueError:
                break
            formula = formula[1:-1].strip()
        unquoted = re.sub(r"'(?:\\.|[^'\\])*'|\"(?:\\.|[^\"\\])*\"",
                          lambda m: ' ' * len(m[0]), formula)
        if any(c in unquoted for c in '|&~?:<>') or len(split_top(unquoted, '=')) != 2:
            raise ValueError(f"Not a unit equality: {name}: {formula}")
        negative = '!=' in unquoted
        variables = sorted(set(re.findall(r'\b[A-Z][A-Za-z_0-9]*\b', unquoted)))
        if re.search(r'\b_[A-Za-z_0-9]*\b', unquoted):
            raise ValueError(f"Unsupported anonymous variable in {name}")
        if negative:
            # Negating a universally closed negative clause gives an existential
            # conjecture, not a universally quantified equation.
            operator = unquoted.index('!=')
            equation = formula[:operator] + '=' + formula[operator+2:]
            goals.append(f"? [{','.join(variables)}] : ({equation})" if variables else equation)
        else:
            if role not in ('axiom', 'hypothesis', 'lemma', 'plain', 'negated_conjecture'):
                raise ValueError(f"Unexpected positive clause role: {role}")
            quantified = f"! [{','.join(variables)}] : ({formula})" if variables else formula
            axioms.append(f"fof(a{len(axioms)+1}, axiom,\n    {quantified}\n).")
    if len(goals) != 1:
        raise ValueError(f"Expected exactly one negative goal, found {len(goals)}: {path}")
    return ('% Equivalent UEQ problem: includes expanded, negative goal made positive.\n'
            + '\n\n'.join(axioms + [f"fof(goal, conjecture,\n    {goals[0]}\n).\n"]))
