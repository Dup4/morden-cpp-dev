#! /bin/bash

set -e

# shellcheck disable=SC2034
TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

CMAKE_VERSION=${CMAKE_VERSION:-"none"}

if [[ "${CMAKE_VERSION}" = "none" ]]; then
    echo "No CMake version specified, skipping CMake reinstallation"
    exit 0
fi

main_name="cmake-${CMAKE_VERSION}"

wget "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${main_name}.tar.gz"
tar -zxvf "${main_name}".tar.gz

cd "${main_name}"

./bootstrap
make -j8
make install

cd /root

rm -rf "${main_name}" "${main_name}.tar.gz"
