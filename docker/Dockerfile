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


ARG UBUNTU_VERSION=26.04
FROM ubuntu:${UBUNTU_VERSION}

ARG BASILISK_TAG=v2.12.2
ARG BASILISK_COMMIT=dad700e
ARG DEPS=pinned

LABEL org.opencontainers.image.title="Basilisk Docker"
LABEL org.opencontainers.image.vendor="Abruan Aerospace"
LABEL org.opencontainers.image.version="${BASILISK_TAG}"
LABEL basilisk.tag="${BASILISK_TAG}"
LABEL basilisk.commit="${BASILISK_COMMIT}"
LABEL basilisk.deps="${DEPS}"

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:${PATH}"

# System dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        git-lfs \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        pkg-config \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \
        python3-tk \
        libgtk2.0-0t64 \
        libzmq3-dev \
    && rm -rf /var/lib/apt/lists/*

# Create isolated Python environment
RUN python3 -m venv ${VIRTUAL_ENV} && \
    python -m pip install --upgrade pip

WORKDIR /app

COPY requirements.txt /tmp/requirements.txt

# Retrieve exact Basilisk source revision
RUN test -n "${BASILISK_COMMIT}" && \
    git clone https://github.com/AVSLab/basilisk.git /app/basilisk && \
    git -C /app/basilisk checkout "${BASILISK_COMMIT}" && \
    git -C /app/basilisk lfs pull && \
    test "$(git -C /app/basilisk describe --tags --exact-match HEAD)" \
        = "${BASILISK_TAG}"

WORKDIR /app/basilisk

# Install Python dependencies
RUN if [ "$DEPS" = "pinned" ]; then \
        python -m pip install --no-cache-dir \
            -r /tmp/requirements.txt; \
    elif [ "$DEPS" = "ranges" ]; then \
        python -m pip install --no-cache-dir \
            -r requirements.txt \
            -r requirements_dev.txt \
            ipykernel; \
    else \
        echo "Invalid DEPS mode: $DEPS" >&2; exit 1; \
    fi

# Verify build tools
RUN python --version && \
    swig -version && \
    conan --version && \
    cmake --version

# Configure and build Basilisk
RUN python conanfile.py

# Register Basilisk editable installation
RUN python -m pip install \
        --no-build-isolation \
        --no-deps \
        -e .

# Validate installation
RUN python -m pip check && \
    python -c "import Basilisk; print('Basilisk import successful')" && \
    python -m pip show bsk

WORKDIR /app/workspace
