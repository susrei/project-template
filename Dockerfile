FROM python:3.9

# Create a working directory
WORKDIR /app

# Add source code to working directory
ADD src /app/src
COPY setup.py /app
COPY requirements.txt /app

# Install packages from requirements.txt
# hadolint ignore=DL3013
RUN pip install --upgrade pip && \
    pip install --trusted-host pypi.python.org -r requirements.txt && \
    pip install -e ".[base]"

# Make the 'projutil' utility the entrypoint
ENTRYPOINT ["projutil"]

# Print the help message if no other arguments are provided
# NOTE: this will confuse Singularity
CMD ["--help"]
