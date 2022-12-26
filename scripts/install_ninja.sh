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

NINJA_VERSION=${NINJA_VERSION:-"none"}

if [[ "${NINJA_VERSION}" == "none" ]]; then
    INFO "no Ninja version specified, use latest version"

    latest_ninja_version=$(curl https://api.github.com/repos/ninja-build/ninja/releases/latest -s | jq .tag_name -r)

    if [[ "${latest_ninja_version}" != "v"* ]]; then
        ERROR "get latest Ninja version failed. please retry later"
        exit 1
    fi

    NINJA_VERSION=${latest_ninja_version#"v"}
fi

INFO "Ninja Version is: ${NINJA_VERSION}"

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

INFO "Installing Ninja..."

NINJA_BINARY_NAME="ninja-linux.zip"
TMP_DIR=$(mktemp -d -t ninja-XXXXXXXXXX)

INFO "${TMP_DIR}"
cd "${TMP_DIR}" || exit 1

curl -SL --progress-bar "https://github.com/ninja-build/ninja/releases/download/v${NINJA_VERSION}/${NINJA_BINARY_NAME}" -O
unzip "${NINJA_BINARY_NAME}"

${SUDO} mv ninja /usr/local/bin/ninja
${SUDO} chown root:root /usr/local/bin/ninja
