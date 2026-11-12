#!/bin/bash
# ---------------------------------------------------------------------
# build-basilisk.sh
#
# Convenience script to build and launch the Basilisk container.
#
# Usage: ./build-basilisk.sh
#
# Author:       Anubhav Gupta
# Organization: Infinite Labs
# License:      MIT
# ---------------------------------------------------------------------

set -e

# Resolve repository root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Building Basilisk Docker container..."

docker compose \
    -f "${SCRIPT_DIR}/docker-compose.yml" \
    up -d --build

echo "Container built and running."
echo "To open a terminal inside the container:"
echo "  docker exec -it basilisk_gnc bash"