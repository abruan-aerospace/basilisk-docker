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

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=America/Los_Angeles

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git git-lfs build-essential \
    python3-setuptools python3-dev \
    python3-tk python3-pip python3-venv \
    swig libgtk2.0-0 libzmq3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt /tmp/requirements.txt

RUN git clone https://github.com/AVSLab/basilisk.git && \
    cd basilisk && \
    git checkout ${BASILISK_COMMIT} && \
    git lfs pull && \
    python3 -m pip install --no-cache-dir -r /tmp/requirements.txt && \
    python3 conanfile.py \
        --buildProject False \
        --vizInterface True \
        --managePipEnvironment False && \
    cd dist3 && \
    make -j"$(nproc)"

WORKDIR /app/workspace