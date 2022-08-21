# Analysis of mutational signtures using NMF

The analysis is available as a Docker container, and it is based on the `MutationalPatterns` and `NMF` R packages.

## Building the container

From the project root directry run
```
docker build -t r-nmf -f R/Dockerfile .
```

## Running the container

```
docker run --rm -v <LOCAL-PATH-TO-INPUT-DIR>:/data -v <LOCAL-PATH-TO-OUPUT-DIR>:/output r-nmf <OPTION> <PARAMETERS>
```

> **NOTE:** When providing the input/output directory in the container command use the paths relative to the mapped folders `/data` and `/output` respectively.

There are __four options__ for the mutational signatures analysis:
- `--estimate` runs NMF rank estimation for all values between `minrank` and `maxrank`. It requires the following parameters:
    - `--file` mutational catalog file (comma separated values)
    - `--output` output directory
    - `--minrank` minimum rank
    - `--maxrank` maximum rank

- `--nmf`  runs NMF decomposition. It requires the following parameters:
    - `--file` mutational catalog file (comma separated values)
    - `--output` output directory
    - `--rank` rank

- `--fit` runs non-negative least squares fit to Alexandrov signatures. The dataset is [publicly available](http://cancer.sanger.ac.uk/cancergenome/assets/signatures_probabilities.txt) and it was downloaded on 2022/04/20. This option requires the following parameters:
    - `--file` mutational catalog file (comma separated values)
    - `--output` output directory

- `--similarity` runs cosine similarity between the de-novo signatures (as returned when running the `--nmf` option) and the known Alexandrov signatures (as described above). It requires the following parameters:
    - `--file` mutational catalog file (comma separated values)
    - `--output` output directory

Optional parameters:
- `--prefix` creates a subdirectory in the output directory. Default value is the current date.
