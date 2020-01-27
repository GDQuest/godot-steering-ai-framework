"""
Finds and collects docstrings from individual GDScript files
"""
import re
from dataclasses import dataclass
from typing import List


@dataclass
class Statement:
    index: int
    line: str
    type: str


def _collect_reference_statements(gdscript: List[str]) -> List[Statement]:
    """Returns a StatementsList of the lines to process for the docs"""
    statements: List[Statement] = []
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


def _find_docstring(gdscript: List[str], statement: Statement) -> List[str]:
    """Returns the docstring found in the GDScript file for the given statement, or an empty
    string if there's no docstring."""
    docstring: List[str] = []
    index_start = statement.index - 1
    index = index_start
    while gdscript[index].startswith("#"):
        index -= 1
    if index != index_start:
        docstring = gdscript[index + 1 : index_start + 1]

    for index, line in enumerate(docstring):
        docstring[index] = docstring[index].replace("#", "", 1).strip()
    return docstring


def _get_property_data(line: str) -> dict:
    """Returns a dictionary that contains information about a member variable"""
    # Groups 3, 4, and 5 respectively match the symbol, type, and value
    # Use group 6 and the setget regex to find setter and getter functions
    match = re.match(
        r"^(export|onready)?(\(.+\))? ?var (\w+) ?:? ?(\w+)? ?=? ?([\"\'].+[\"\']|([\d.\w]+))?( setget.*)?",
        line,
    )
    if not match:
        return {}

    setter, getter = "", ""
    if match.group(7):
        match_setget = re.match(r"setget (set_\w+)?,? ?(get_\w+)?", line)
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


def _get_function_data(line: str) -> dict:
    """Returns a dictionary that contains information about a function"""
    data: dict = {
        "name": "",
        "arguments": "",
        "type": "",
    }
    print(line)
    match = re.match(r"^func (\w+)\((.*)\) ?-> ?(\w+)", line)
    if not match:
        return []

    data["name"] = match.group(1)
    data["type"] = match.group(3)
    arguments = []
    args: str = match.group(2).strip()
    if args:
        for arg in args.split(","):
            match_arg = re.match(r"(\w+) ?: ?(\w*)", line)
            if not match_arg:
                continue
            arguments.append(
                {"identifier": match_arg.group(1), "type": match_arg.group(2),}
            )
    data["arguments"] = arguments
    return data


def _get_signal_data(line: str) -> dict:
    """Returns a dictionary that contains information about a signal"""
    data: dict = {
        "name": "",
        "arguments": "",
    }
    return data


def _get_subclass_data(line: str="") -> dict:
    """Returns a dictionary that contains information about a subclass"""
    data: dict = {
        "name": "",
    }
    match = re.match(r"class (.+):$", line)
    if match:
        data["name"] = match.group(1)
    return data


def get_file_reference(gdscript: List[str]) -> dict:
    """Returns a dictionary with the functions, properties, and inner classes collected from
    a GDScript file, with their docstrings.

    Keyword Arguments:
    gdscript: List[str] -- (default "")
    """
    data: dict = {
        "property": [],
        "signal": [],
        "function": [],
        "subclass": [],
    }
    functions_map: dict = {
        "property": _get_property_data,
        "function": _get_function_data,
        "signal": _get_signal_data,
        "subclass": _get_subclass_data,
    }
    statements: List[Statement] = _collect_reference_statements(gdscript)
    for statement in statements:
        docstring: str = "\n".join(_find_docstring(gdscript, statement))
        statement_data: dict = functions_map[statement.type](statement.line)
        reference_data: dict = statement_data
        reference_data["docstring"] = docstring
        data[statement.type].append(reference_data)
    return data
