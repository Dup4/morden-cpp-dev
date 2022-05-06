#! /bin/bash

set -e

# shellcheck disable=SC2034
TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

LLVM_VERSION="${LLVM_VERSION:-"none"}"

if [ "${LLVM_VERSION}" = "none" ]; then
    echo "No LLVM version specified, skipping LLVM reinstallation"
    exit 0
fi

# https://apt.llvm.org/

LLVM_INSTALL_SCRIPT="${TOP_DIR}/llvm.sh"

wget https://apt.llvm.org/llvm.sh -O "${LLVM_INSTALL_SCRIPT}"
sudo bash "${LLVM_INSTALL_SCRIPT}" "${LLVM_VERSION}" all
rm "${LLVM_INSTALL_SCRIPT}"

cd /usr/bin || exit 1

llvm_binaries=$(ls ./*-"${LLVM_VERSION}")

for raw_binary in ${llvm_binaries}; do
    # shellcheck disable=SC2001
    binary=$(echo "${raw_binary}" | sed -e "s/-${LLVM_VERSION}$//")

    if [[ ! -f "/usr/local/bin/${binary}" ]]; then
        ln -s /usr/bin/"${binary}-${LLVM_VERSION}" /usr/local/bin/"${binary}"
    fi
done

cd "${TOP_DIR}" || exit 1
