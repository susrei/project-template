# Project description

The analysis is available as a Docker container.

## Directory structure

```
R
├── Dockerfile              Dockerfile for the R module
├── README.md               This file
├── install-packages.R      R project dependencies (required packages). DO NOT RENAME!
└── src                     Source code directory
    ├── example.R           Example R script
    └── script.R            Packege entrypoint with command line arguments. DO NOT RENAME!
```

## How to use this template

1. Add R dependencies to `install-packages.R`.
2. Add R code in `src/` folder.
3. Update `script.R` command line arguments to reflect your package.
4. [Build Docker container](#building-the-container).
5. [Run Docker container](#running-the-container).

## Using RStudio

```
docker run --rm -ti -e PASSWORD=${PROJECT_NAME} -v ${PWD}:/home/rstudio -p 8787:8787 rocker/rstudio:${R_VERSION}
```

or using the provided `make` command

```
make open-rstudio
```

In the browser, navigate to `localhost:8787`. The username is `rstudio` and the password is the project name (project root directory name). The project folder is mounted in the container, and therefore all the changes will be persisted.

### Installing dependencies in RStudio

1. Open the `Terminal` tab (next to the `Console` tab)
2. Run `cd R/src`
3. Run `Rscript install-packages.R`

>IMPORTANT: If you terminte the container, you will have to re-install the packages next time you start it.


## Building the container

From the project root directry run
```
docker build -t project-temaplate-r -f R/Dockerfile .
```

or using the provided `make` command
```
make build-r-container
```

## Running the container

The generic command to run the containerized code is
```
docker run --rm -v <LOCAL-PATH-TO-INPUT-DIR>:/data -v <LOCAL-PATH-TO-OUPUT-DIR>:/output project-temaplate-r <OPTION> <PARAMETERS>
```

To run the generic example provided in this template execute
```
docker run --rm project-temaplate-r --process -f foo.txt -o bar.txt
```

For a list of available command line arguments run
```
docker run --rm project-temaplate-r --help
```

> **NOTE:** When providing the input/output directory in the container command use the paths relative to the mapped folders `/data` and `/output` respectively.

There are __two options__ for the provided project template:
- `--process` Run data processing. It requires the following parameters:
    - `--file` Input file
    - `--outfile` Output file for the results.

- `--plot` Run plotting. It requires the following parameters:
    - `--file` Input file
    - `--outfile` Output file for the results.

Optional parameters:
- `--prefix` Add prefix to the provided output file. Default value is the current date.
