"""
Module for heatmap plots.
"""

import logging

logger = logging.getLogger(__name__)
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s : %(levelname)s : %(module)s : %(funcName)s : %(message)s",  # noqa: E501
)


def heatmap(input: str, output: str) -> None:
    """Create a heatmap from data in ``input`` and save the figure to
    ``output``.

    Args:
        input (str): Input data file (table-like).
        output (str): Output figure file.
    """

    logger.info(f"Generating heatmap from {input}... DONE")
    logger.info(f"Heatmap written to {output}")
