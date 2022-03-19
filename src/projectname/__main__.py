"""
Project package entrypoint.

Everythin defined in this file can be run with `python -m projectname`.
"""

import argparse
import logging

from .plotting import heatmap
from .datasets import process_data


logger = logging.getLogger(__name__)
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s : %(levelname)s : %(module)s : %(funcName)s : %(message)s",  # noqa: E501
)


def preprocess_fun(args):
    """Dummy preprocessing function."""
    logger.info(
        f"Preprocessing data from {args.dir} and output to {args.out}..."
    )  # noqa: E501
    process_data(args.dir, args.out)


def plot_func(args):
    """Dummy plot function."""
    logger.info(f"Plotting data from {args.dir} and output to {args.out}...")
    heatmap(args.dir, args.out)


def main():
    """The CLI is enabled through this function. The parser(s) is first added
    and the subparser acts as receiver of different commands, each taking
    their own arguments."""
    parser = argparse.ArgumentParser(
        prog="projectname", description="Welcome to the ProjectName's CLI!"
    )
    subparser = parser.add_subparsers()

    # The preprocess command
    preprocess = subparser.add_parser(
        "preprocess", help="Help message for preprocess subcommand"
    )

    preprocess.add_argument(
        "-d", "--dir", help="data directory", required=True, metavar="path"
    )
    preprocess.add_argument(
        "-o", "--out", help="ouptut directory", required=True, metavar="path"
    )

    preprocess.add_argument(
        "-p",
        "--prefix",
        nargs="?",
        help="output file prefix.",
    )

    preprocess.set_defaults(func=preprocess_fun)

    # The plot command
    plot = subparser.add_parser(
        "plot",
        help="Plot the signals in a drive and save the resulting figure"
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
        default=argparse.SUPPRESS,
        help="list of genes to plot"
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
