"""
Finds and collects docstrings from individual GDScript files
"""
import re
from dataclasses import dataclass

REGEX = {
    "function": re.compile(r"^func (\w+)\((.*)\) ?-> ?(\w+)"),
    "argument": re.compile(r"(\w+) ?: ?(\w*)"),
    # Groups 3, 4, and 5 respectively match the symbol, type, and value
    # Use group 6 and the setget regex to find setter and getter functions
    "property": re.compile(
        r"^(export|onready)?(\(.+\))? ?var (\w+) ?:? ?(\w+)? ?=? ?([\"\'].+[\"\']|([\d.\w]+))?( setget.*)?"
    ),
    "setget": re.compile(r"setget (set_\w+)?,? ?(get_\w+)?"),
    "subclass": re.compile(r"class (.+):$"),
}


@dataclass
class Statement:
    index: int
    line: str
    type: str


def _collect_reference_statements(gdscript: list[str] = "") -> StatementsList:
    """Returns a StatementsList of the lines to process for the docs"""
    statements: list[Statement] = []
    types_map: dict = {
        "var": "property",
        "onready": "property",
        "export": "property",
        "signal": "signal",
        "func": "function",
        "class": "subclass",
    }
    for index, line in enumerate(gdscript):
        for pattern in types_map:
            if not line.startswith(pattern):
                continue
            statements.append(Statement(index, line, types_map[pattern]))
        return statements


def _find_docstring(gdscript: list[str], statement: Statement) -> list[str]:
    """Returns the docstring found in the GDScript file for the given statement, or an empty
    string if there's no docstring."""
    docstring: list[str] = []
    index_start = statement.index - 1
    index = index_start
    while gdscript[index].startswith("#"):
        index -= 1
    if index != index_start:
        docstring = gdscript[index + 1 : index_start]
    return docstring


def _get_property_data(line: str) -> dict:
    """Returns a dictionary that contains information about a member variable"""
    match = re.match(REGEX["property"], line)
    if not match:
        return

    setter, getter = "", ""
    if match.group(7):
        match_setget = re.match(REGEX["setget"], line)
        if match_setget:
            setter = match_setget.group(1)
            getter = match_setget.group(2)

    return {
        "identifier": match.group(3),
        "type": match.group(4),
        "value": match.group(5),
        "setter": setter,
        "getter": getter,
    }


def _get_function_data(line: str) -> list[dict]:
    """Returns a dictionary that contains information about a member variable"""
    match = re.match(REGEX["function"], line)
    if not match:
        return

    arguments = []
    args: str = match.group(2).strip()
    if args:
        for arg in args.split(","):
            match_arg = re.match(REGEX["argument"], line)
            if not match_arg:
                continue
            arguments.append({
                "identifier": match_arg.group(1),
                "type": match_arg.group(2),
            })
    return arguments


def get_file_reference(gdscript: list[str]) -> dict:
    """Returns a dictionary with the functions, properties, and inner classes collected from
    a GDScript file, with their docstrings.

    Keyword Arguments:
    gdscript: list[str] -- (default "")
    """
    data = {}
    statements: list[Statement] = _collect_reference_statements(gdscript)
    docstrings = map(
        lambda statement: (statement, _find_docstring(statement)), statements
    )
    for statement in statements:
        data[statement.type].append()
    {statement.type: [] for statement in statements}

    return data
