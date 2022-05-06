#! /bin/bash

set -e

# shellcheck disable=SC2034
TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

CMAKE_VERSION=${1:-"none"}

if [ "${CMAKE_VERSION}" = "none" ]; then
    echo "No CMake version specified, skipping CMake reinstallation"
    exit 0
fi

# Key: Kitware repo
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null

# only use focal
echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ ${UBUNTU_TAG} main" | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null

apt update

apt install --no-install-recommends --no-install-suggests -y cmake

ln -s /usr/bin/cmake /usr/local/bin/cmake
