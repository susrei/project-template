"""
Project package entrypoint.

Everythin defined in this file can be run with `python -m projectname`.
"""

import argparse


def trim_func(args):
    """Dummy trim function."""
    print(f"Trimming data from {args.dir} and output to {args.out}...")


def plot_func(args):
    """Dummy plot function."""
    print(f"Plotting data from {args.dir} and output to {args.out}...")


def main():
    """The CLI is enabled through this function. The parser(s) is first added
    and the subparser acts as receiver of different commands, each taking
    their own arguments."""
    parser = argparse.ArgumentParser(
        prog="projutil", description="Welcome to the ProjectName's CLI!"
    )
    subparser = parser.add_subparsers()

    # The trim command
    trim = subparser.add_parser(
        "trim",
        help="Help message for trim subcommand"
    )

    trim.add_argument(
        "-d", "--dir", help="data directory", required=True, metavar="path"
    )
    trim.add_argument(
        "-o", "--out", help="ouptut directory", required=True, metavar="path"
    )

    trim.add_argument(
        "-p",
        "--prefix",
        nargs="?",
        help="output file prefix.",
    )

    trim.set_defaults(func=trim_func)

    # The plot command
    plot = subparser.add_parser(
        "plot",
        help="Plot the singals in a drive and save the resulting figure"
    )
    plot.add_argument(
        "-d", "--dir", help="data directory", metavar="path", required=True
    )

    plot.add_argument(
        "-o",
        "--out",
        help="the directory that the concatenated output will be saved",
        metavar="path",
        required=True,
    )

    # The signals option
    plot.add_argument(
        "--genes",
        nargs="*",
        default=argparse.SUPPRESS, help="list of genes to plot"
    )

    # The overwrite option
    plot.add_argument(
        "--overwrite",
        action="store_true",
        help="overwrite the image file in the save directory",
    )

    plot.set_defaults(func=plot_func)

    args = parser.parse_args()
    args.func(args)
