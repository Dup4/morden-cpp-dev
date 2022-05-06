#! /bin/bash

set -e

# shellcheck disable=SC2034
TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

apt install --no-install-recommends --no-install-suggests -y \
    build-essential \
    libstdc++6 \
    ninja-build \
    gdb \
    lcov

python -m pip install gcovr
