import sys
from argparse import ArgumentParser, Namespace


def parse(args=sys.argv) -> Namespace:
    parser: ArgumentParser = ArgumentParser(
        prog="Collect GDScript reference",
        description="Creates a code reference from GDScript source code.",
    )
    parser.add_argument("files", type=str, nargs="+", default="", help="A list of paths to GDScript files.")
    return parser.parse_args(args)
