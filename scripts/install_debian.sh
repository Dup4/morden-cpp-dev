#! /bin/bash

set -e

# shellcheck disable=SC2034
TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

bash "${TOP_DIR}"/install_common.sh
bash "${TOP_DIR}"/install_cpp_common.sh
# bash "${TOP_DIR}"/install_gcc_for_ubuntu.sh
bash "${TOP_DIR}"/install_llvm.sh
bash "${TOP_DIR}"/install_cmake.sh
