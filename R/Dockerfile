FROM r-base:4.2.0

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libxml2-dev \
    libssl-dev

RUN mkdir -p /opt/software/setup/R && \
    mkdir -p /opt/extdata

COPY R/install-packages.R /opt/software/setup/R/install-packages.R

# Copy required data files from the data/ folder in the container, e.g.
# COPY data/ /opt/extdata/

RUN Rscript /opt/software/setup/R/install-packages.R

COPY R/src /src

WORKDIR /src

ENTRYPOINT ["Rscript", "script.R"]
