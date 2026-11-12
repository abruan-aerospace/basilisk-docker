# ---------------------------------------------------------------------
# ./docker/Dockerfile
#
# Docker image for containerized Basilisk GN&C simulation workflows.
#
# Author:       Anubhav Gupta
# Affiliation:  University of Colorado Boulder
#               In Orbit Aerospace Inc.
# Organization: Infinite Labs
# License:      MIT
# ---------------------------------------------------------------------

FROM ubuntu:22.04

ARG BASILISK_COMMIT=87cb4116e09694ddf6587f61a7f4196d2e720c43
LABEL basilisk.commit=${BASILISK_COMMIT}

# DEPS=pinned  installs the exact versions in requirements.txt (default).
# DEPS=ranges  installs Basilisk's own version ranges at BASILISK_COMMIT.
ARG DEPS=pinned
LABEL basilisk.deps=${DEPS}

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=America/Los_Angeles

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git=1:2.34.1-1ubuntu1.18 \
    git-lfs=3.0.2-1ubuntu0.3 \
    build-essential=12.9ubuntu3 \
    python3=3.10.6-1~22.04.1 \
    python3-pip=22.0.2+dfsg-1ubuntu0.7 \
    python3-venv=3.10.6-1~22.04.1 \
    python3-dev=3.10.6-1~22.04.1 \
    python3-tk=3.10.8-1~22.04\
    swig=4.0.2-1ubuntu1 \
    libgtk2.0-0=2.24.33-2ubuntu2.1 \
    libzmq3-dev=4.3.4-2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt /tmp/requirements.txt

# Retrieve the exact Basilisk source revision
RUN git clone https://github.com/AVSLab/basilisk.git /app/basilisk && \
    git -C /app/basilisk checkout ${BASILISK_COMMIT} && \
    git -C /app/basilisk lfs pull

WORKDIR /app/basilisk

# Install Python dependencies and build Basilisk
RUN if [ "$DEPS" = "pinned" ]; then \
        python3 -m pip install --no-cache-dir -r /tmp/requirements.txt; \
    elif [ "$DEPS" = "ranges" ]; then \
        python3 -m pip install --no-cache-dir \
            -r requirements.txt -r requirements_dev.txt ipykernel; \
    else \
        echo "DEPS must be pinned or ranges (got: $DEPS)" >&2; exit 1; \
    fi && \
    python3 conanfile.py \
        --buildProject False \
        --vizInterface True \
        --managePipEnvironment False && \
    cd dist3 && \
    make -j"$(nproc)"

WORKDIR /app/workspace