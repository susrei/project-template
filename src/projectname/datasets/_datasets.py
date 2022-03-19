"""
Module for processing datasets.
"""

import logging


logger = logging.getLogger(__name__)
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s : %(levelname)s : %(module)s : %(funcName)s : %(message)s",  # noqa: E501
)


def process_data(input: str, output: str) -> None:
    """Sample method for processing data.

    Args:
        input (str): Input file path.
        output (str): Output file path
    """

    logger.info(f"Processing dataset {input}... DONE")
    logger.info(f"Processed data written to {output}")
