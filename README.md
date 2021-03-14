# Project template

Project template for setting up a directory and file structure for a new research project.
The intended contents of each directory is explained in separate README.md files.

## Overview

```
project
|- doc/                documentation for the study
|
|- data/               raw and primary data, essentially all input files, never edit!
|  |- raw/
|  |- processed/
|  |- meta/
|
|- notebooks/
|
|- intermediate/       output files from different analysis steps, can be deleted
|- scratch/            temporary files that can be safely deleted or lost
|- logs/               logs from the different analysis steps
|
|- results/            output from workflows and analyses
|  |- figures/
|  |- tables/
|  |- reports/
|
|- src/                all source code needed to go from input files to final results
|
|- .gitignore          sets which parts of the repository that should be git tracked
|- run.py              script to generate the final results
|- config.yml          configuration of the project workflow
|- environment.yml     software dependencies list, used to create a project environment
|- Makefile            commands to manage the environment
|- Dockerfile          recipe to create a project container
|- Snakefile           project workflow, carries out analysis contained in code/
```
