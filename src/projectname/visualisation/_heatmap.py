"""
Module for heatmap plots.
"""

import logging


def heatmap(input: str, output: str) -> None:
    """Create a heatmap from data in ``input`` and save the figure to
    ``output``.

    Args:
        input (str): Input data file (table-like).
        output (str): Output figure file.
    """

    logger = logging.getLogger(__name__)
    logger.info(f"generating heatmap from {input}")
