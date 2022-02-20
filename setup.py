"""
Setup script for installing the project package.
"""

from setuptools import find_packages
from setuptools import setup

base_packages = [
    "matplotlib~=3.5",
    "pandas~=1.4",
    "scikit-learn~=1.0",
    "umap-learn~=0.5",
]

dev_packages = base_packages + [
    "black~=22.1",
    "flake8~=3.8",
    "ipykernel~=6.9",
    "ipython~=8.0",
    "jupyterlab~=3.2",
    "jupytext~=1.13",
    "mypy~=0.931",
    "pre-commit~=2.17",
    "pylint~=2.9",
    "pytest~=6.2",
]

setup(
    name="projectname",
    packages=find_packages("src"),
    package_dir={"": "src"},
    python_requires=">=3.9",
    extras_require={
        "base": base_packages,
        "dev": dev_packages,
    },
    entry_points={"console_scripts": ["projutil = projectname.__main__:main"]},
)
