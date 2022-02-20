#SHELL := /usr/bin/env zsh
#SHELL := /usr/local/bin/zsh
SHELL := /bin/bash
.ONESHELL:


#######
# Help
#######

.DEFAULT_GOAL := help
.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


####################
# Conda Environment
####################

PY_VERSION := 3.9.10
CONDA_ENV_NAME ?= env-conda-test
ACTIVATE_ENV = source activate $(CONDA_ENV_NAME)

.PHONY: build-conda-env
build-conda-env: $(CONDA_ENV_NAME)  ## Build the conda environment
$(CONDA_ENV_NAME):
	conda create -n $(CONDA_ENV_NAME) --copy -y python=$(PY_VERSION)
	conda env update -n $(CONDA_ENV_NAME) -f environment.yaml

.PHONY: clean-conda-env
clean-conda-env:  ## Remove the conda environment and the relevant file
	conda env remove -n $(CONDA_ENV_NAME)

.PHONY: add-to-jupyter
add-to-jupyter:  ## Register the conda environment to Jupyter
	$(ACTIVATE_ENV) && python -s -m ipykernel install --user --name $(CONDA_ENV_NAME)

.PHONY: remove-from-jupyter
remove-from-jupyter:  ## Remove the conda environment from Jupyter
	$(ACTIVATE_ENV) && jupyter kernelspec uninstall -y $(CONDA_ENV_NAME)


##################
# Pip Environment
##################

PROJECT_NAME:=project-env

.PHONY: venv-setup
venv-setup:  ## Create environment with venv
	python3 -m venv ~/.${PROJECT_NAME}-env

.PHONY: pip-install
pip-install:  ## Pip install requirements from file
	pip install --upgrade pip && \
    	pip install -r requirements.txt

.PHONY: install-src
install-src:  ## Install Python package in editable mode with base dependencies
	pip install -e ".[base]"

.PHONY: install-dev
install-dev:  ## Install Python package in editable mode with dev dependencies
	pip install -e ".[dev]"

.PHONY: test
test:  ## Run tests
	#python -m pytest -vv --cov=myrepolib tests/*.py
	#python -m pytest --nbval notebook.ipynb

.PHONY: lint
lint:  ## Run lint in all files in the src directory
	#hadolint Dockerfile
	pylint --disable=R,C,W1203 src

.PHONY: all
all: pip-install lint test  ## Run pip-install lint test
