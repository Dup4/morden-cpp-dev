#! /bin/bash

set -e

# shellcheck disable=SC2034
TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

apt install --no-install-recommends --no-install-suggests -y \
    make \
    ninja-build \
    bison \
    gdb \
    lcov

# build-essential \
# libstdc++6 \

python -m pip install gcovr
