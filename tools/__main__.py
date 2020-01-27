import os
from argparse import Namespace
from pprint import pprint
from typing import List

from .modules import collect_reference, command_line


def main():
    args: Namespace = command_line.parse()
    reference = []
    for file_path in args.files:
        if not file_path.lower().endswith(".gd"):
            continue
        with open(file_path, "r") as gdscript_file:
            gdscript: List[str] = gdscript_file.readlines()
            class_name: str = os.path.splitext(os.path.basename(file_path))[0]
            file_data: dict = {
                class_name: collect_reference.get_file_reference(gdscript)
            }
            reference.append(file_data)
    pprint(reference)


if __name__ == "__main__":
    main()
