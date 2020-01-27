from argparse import Namespace
from typing import List

from .modules import collect_reference
from .modules import command_line


def main():
    args: Namespace = command_line.parse()
    for file_path in args.files:
        if not file_path.lower().endswith(".gd"):
            continue
        with open(file_path, "r") as gdscript_file:
            gdscript: List[str] = gdscript_file.readlines()
            reference = collect_reference.get_file_reference(gdscript)
            print(reference)


if __name__ == "__main__":
    main()
