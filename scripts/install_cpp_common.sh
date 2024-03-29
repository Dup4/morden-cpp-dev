#! /bin/bash

set -e

# shellcheck disable=SC2034
TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

apt install --no-install-recommends --no-install-suggests -y \
    build-essential \
    make \
    ninja-build \
    bison \
    gdb \
    lcov

# libc6 \
# libgcc1 \
# libstdc++6 \

python -m pip install gcovr
