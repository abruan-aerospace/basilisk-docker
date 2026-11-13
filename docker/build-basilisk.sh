#!/bin/bash
# Convenience script to build and launch the Basilisk container.
#
# Author: Anubhav Gupta
# Organization: Abruan Aerospace
# License: MIT

set -euo pipefail

# Resolve this script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Building Basilisk Docker container..."

docker compose \
    -f "${SCRIPT_DIR}/docker-compose.yml" \
    up -d --build

echo "Container built and running."
echo "To open a terminal inside the container:"
echo "  docker exec -it basilisk_gnc bash"