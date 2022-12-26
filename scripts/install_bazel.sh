#! /bin/bash

# shellcheck disable=SC2034
CUR_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# shellcheck disable=SC1091
source "${CUR_DIR}/utils.sh"

CURRENT_USER="$(whoami)"
SUDO="sudo"

if [[ "${CURRENT_USER}" == "root" ]]; then
    SUDO=""
fi

BAZEL_VERSION=${BAZEL_VERSION:="none"}

if [[ "${BAZEL_VERSION}" == "none" ]]; then
    INFO "no Bazel Version specified, use latest version"

    latest_bazel_version=$(curl https://api.github.com/repos/bazelbuild/bazel/releases/latest -s | jq .tag_name -r)

    if [[ $? != 0 ]]; then
        ERROR "get Bazel Version failed."
        exit 1
    fi

    BAZEL_VERSION=${latest_bazel_version#"v"}
fi

INFO "Bazel Version is: ${BAZEL_VERSION}"

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

INFO "Installing Bazel..."

architecture=$(dpkg --print-architecture)

if [[ "${architecture}" == "amd64" ]]; then
    architecture="x86_64"
fi

BAZEL_BINARY_NAME="bazel-${BAZEL_VERSION}-linux-${architecture}"
TMP_DIR=$(mktemp -d -t bazel-XXXXXXXXXX)

INFO "${TMP_DIR}"
cd "${TMP_DIR}" || exit 1

curl -SL --progress-bar "https://github.com/bazelbuild/bazel/releases/download/${BAZELISK_VERSION}/${BAZELISK_BINARY_NAME}" -O

${SUDO} mv "${BAZEL_BINARY_NAME}" /usr/local/bin/
