# Docker image for containerized Basilisk GN&C simulation workflows.
#
# Author: Anubhav Gupta
# Organization: Abruan Aerospace
# License: MIT


ARG UBUNTU_VERSION=26.04
FROM ubuntu:${UBUNTU_VERSION}

ARG BASILISK_TAG=v2.12.2
ARG BASILISK_COMMIT=dad700e8af0c0219c5cf0f46666f792c0e7af8a0
ARG IMAGE_VERSION=2.0.0
ARG DEPS=pinned

LABEL org.opencontainers.image.title="Basilisk Docker"
LABEL org.opencontainers.image.vendor="Abruan Aerospace"
LABEL org.opencontainers.image.version="${IMAGE_VERSION}"
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
        git=1:2.53.0-1ubuntu1.1 \
        git-lfs=3.7.1-1 \
        build-essential=12.12ubuntu2.26.04.2 \
        python3=3.14.3-0ubuntu2 \
        python3-dev=3.14.3-0ubuntu2 \
        python3-venv=3.14.3-0ubuntu2 \
        python3-tk=3.14.3-0ubuntu2 \
        libgtk2.0-0t64 \
        libzmq3-dev=4.3.5-1build3 \
    && rm -rf /var/lib/apt/lists/*
  
# Create isolated Python environment
RUN python3 -m venv ${VIRTUAL_ENV}

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
