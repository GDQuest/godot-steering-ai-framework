"""
Finds and collects docstrings from individual GDScript files
"""
import re
from dataclasses import dataclass

REGEX = {
    "function": re.compile(r"^func (\w+)\((.*)\) ?-> ?(\w+)"),
    "function_arguments": re.compile(r"(\w+) ?: ?(\w*)"),
    # Groups 3, 4, and 5 respectively match the symbol, type, and value
    # Use group 6 and the setget regex to find setter and getter functions
    "member_variable": re.compile(
        r"^(export|onready)?(\(.+\))? ?var (\w+) ?:? ?(\w+)? ?=? ?([\"\'].+[\"\']|([\d.\w]+))?( setget.*)?"
    ),
    "setget": re.compile(r"setget (set_\w+)?,? ?(get_\w+)?"),
    "subclass": re.compile(r"class (.+):$"),
}


def get_data(gdscript: list[str]) -> dict:
    """Returns a dictionary with the functions, properties, and inner classes collected from
    a GDScript file, with their docstrings

    Keyword Arguments:
    gdscript: list[str] -- (default "")
    """
    data = {}
    statements: StatementsList = collect_reference_statements(gdscript)




    return data


def collect_reference_statements(gdscript: list[str] = "") -> StatementsList:
    """Returns a StatementsList of the lines to process for the docs"""
    statements: StatementsList = StatementsList([], [], [], [])
    for index, line in enumerate(gdscript):
        if (
            line.startswith("var")
            or line.startswith("onready")
            or line.startswith("export")
        ):
            statements.properties.append(
                Statement(index, line)
            )
        elif line.startswith("signal"):
            statements.signals.append(
                Statement(index, line)
            )
        elif line.startswith("func"):
            statements.methods.append(
                Statement(index, line)
            )
        elif line.startswith("class"):
            statements.subclasses.append(
                Statement(index, line)
            )
        return statements


@dataclass
class StatementsList:
    signals: list
    properties: list
    methods: list
    subclasses: list


@dataclass
class Statement:
    index: int
    line: str


def find_docstring(gdscript: list[str], statement: Statement) -> list[str]:
    """Returns the docstring found in the GDScript file for the given statement, or an empty string if there's no docstring."""
    docstring: list[str] = []
    index_start = statement.index - 1
    index = index_start
    while gdscript[index].startswith("#"):
        index -= 1
    if index != index_start:
        docstring = gdscript[index + 1 : index_start]
    return docstring
