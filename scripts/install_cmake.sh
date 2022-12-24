#! /bin/bash

set -e

# shellcheck disable=SC2034
TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

CMAKE_VERSION=${CMAKE_VERSION:-"none"}

if [[ "${CMAKE_VERSION}" = "none" ]]; then
    echo "No CMake version specified, skipping CMake reinstallation"
    exit 0
fi

echo "CMake Version is: ${CMAKE_VERSION}"

# Cleanup temporary directory and associated files when exiting the script.
cleanup() {
    EXIT_CODE=$?
    set +e
    if [[ -n "${TMP_DIR}" ]]; then
        echo "Executing cleanup of tmp files"
        rm -Rf "${TMP_DIR}"
    fi
    exit $EXIT_CODE
}
trap cleanup EXIT

echo "Installing CMake..."
apt-get -y purge --auto-remove cmake
mkdir -p /opt/cmake

architecture=$(dpkg --print-architecture)
case "${architecture}" in
arm64)
    ARCH=aarch64
    ;;
amd64)
    ARCH=x86_64
    ;;
*)
    echo "Unsupported architecture ${architecture}."
    exit 1
    ;;
esac

CMAKE_BINARY_NAME="cmake-${CMAKE_VERSION}-linux-${ARCH}.sh"
CMAKE_CHECKSUM_NAME="cmake-${CMAKE_VERSION}-SHA-256.txt"
TMP_DIR=$(mktemp -d -t cmake-XXXXXXXXXX)

echo "${TMP_DIR}"
cd "${TMP_DIR}"

curl -sSL "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${CMAKE_BINARY_NAME}" -O
curl -sSL "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${CMAKE_CHECKSUM_NAME}" -O

sha256sum -c --ignore-missing "${CMAKE_CHECKSUM_NAME}"
sh "${TMP_DIR}/${CMAKE_BINARY_NAME}" --prefix=/opt/cmake --skip-license

ln -sf /opt/cmake/bin/cmake /usr/local/bin/cmake

rm -rf "${TMP_DIR}"
