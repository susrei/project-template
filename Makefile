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
CONDA_ENV_NAME ?= $(notdir $(shell pwd))
ACTIVATE_ENV = source activate $(CONDA_ENV_NAME)

.PHONY: build-conda-env
build-conda-env: $(CONDA_ENV_NAME)  ## Build the conda environment
$(CONDA_ENV_NAME):
	# conda create -n $(CONDA_ENV_NAME) --copy -y python=$(PY_VERSION)
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

PROJECT_NAME:=$(notdir $(shell pwd))

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

.PHONY: sync-notebooks
sync-notebooks: ## Sync all .ipynb in notebooks/ with .py percent scripts
	find ./notebooks -type f -name "*.ipynb" | xargs jupytext --sync

.PHONY: pair-notebooks
pair-notebooks: sync-notebooks  ## Pair all notebooks (.ipynb) in notebooks/ with Python scripts (.py) (percent format)
	find ./notebooks -type f -name "*.ipynb" | xargs jupytext --set-formats ipynb,py:percent --pipe black

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


##################
# R Environment
##################

R_VERSION := 4.2.0

.PHONY: open-rstudio
open-rstudio:  ## Open RStudio instance in the browser
	docker run --rm -ti -e PASSWORD=${PROJECT_NAME} -v ${PWD}:/home/rstudio -p 8787:8787 rocker/rstudio:${R_VERSION}

.PHONY: build-r-container
build-r-container:  ## Build Docker container with the R application
	docker build -t ${PROJECT_NAME}-r -f R/Dockerfile .
