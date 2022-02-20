"""
Module for processing datasets.
"""

import logging


def process_data(input: str, output: str) -> None:
    """Sample method for processing data.

    Args:
        input (str): Input file path.
        output (str): Output file path
    """

    logger = logging.getLogger(__name__)
    logger.info(f"processing dataset {input}")
