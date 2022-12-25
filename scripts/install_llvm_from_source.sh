#! /bin/bash

# shellcheck disable=SC2034
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck disable=SC1091
source "${CUR_DIR}/utils.sh"

cd "${CUR_DIR}" || exit 1

VERSION=${INPUT_LLVM_VERSION:-15.0.6}
INSTALL_PATH=${INPUT_LLVM_INSTALL_PATH}

if [[ -z "${INSTALL_PATH}" ]]; then
    ERROR "please set \${INPUT_LLVM_INSTALL_PATH}"
    exit 1
fi

CPUS="$(nproc)"

INFO "CPUS: ${CPUS}"

# Cleanup temporary directory and associated files when exiting the script.
cleanup() {
    EXIT_CODE=$?
    set +e
    if [[ -n "${TMP_DIR}" ]]; then
        INFO "Executing cleanup of tmp files"
        rm -Rf "${TMP_DIR}"
    fi
    exit $EXIT_CODE
}
trap cleanup EXIT

TMP_DIR=$(mktemp -d -t llvm-XXXXXXXXXX)
WORKSPACE="${TMP_DIR}"

git clone --branch "llvmorg-${VERSION}" --depth 1 https://github.com/llvm/llvm-project.git "${WORKSPACE}"

cd "${WORKSPACE}" || exit 1

BUILD_PATH="${WORKSPACE}/build"

mkdir -p "${BUILD_PATH}"
mkdir -p "${INSTALL_PATH}"

cd "${BUILD_PATH}" || exit 1

# https://llvm.org/docs/CMake.html#llvm-related-variables
function build() {
    ENABLE_PROJECTS="clang;clang-tools-extra;cross-project-tests;flang;libclc;lld;lldb;mlir;openmp;polly;pstl;llvm;"
    ENABLE_RUNTIMES="compiler-rt;libc;libcxx;libcxxabi;libunwind;"

    # -DCMAKE_C_COMPILER=clang \
    # -DCMAKE_CXX_COMPILER=clang++ \
    # -DLLVM_USE_LINKER=lld

    cmake \
        -G Ninja \
        -S ../llvm \
        -B ../build \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="${INSTALL_PATH}" \
        -DLLVM_ENABLE_PROJECTS="${ENABLE_PROJECTS}" \
        -DLLVM_ENABLE_RUNTIMES="${ENABLE_RUNTIMES}" \
        -DLLVM_ENABLE_ASSERTIONS=ON \
        -DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON

    ninja -j "${CPUS}"
    ninja install
}

build
