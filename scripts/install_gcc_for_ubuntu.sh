#! /bin/bash

set -e

# shellcheck disable=SC2034
TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

UBUNTU_TAG="${UBUNTU_TAG:-"focal"}"
GCC_VERSION="${GCC_VERSION:-"none"}"

if [ "${GCC_VERSION}" = "none" ]; then
    echo "No GCC version specified, skipping GCC reinstallation"
    exit 0
fi

# Key: Ubuntu Toolchain test repo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 1e9377a2ba9ef27f

# Add sources
echo "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu ${UBUNTU_TAG} main" >/etc/apt/sources.list.d/ubuntu-toolchain-r-ubuntu-test-"${UBUNTU_TAG}".list

apt update

deps="
gcc-${GCC_VERSION} \
g++-${GCC_VERSION} \
"

for pkg in ${deps}; do
    install_ok='n'

    for i in $(seq 3); do
        if ! apt install --no-install-recommends --no-install-suggests -y "${pkg}"; then
            echo "network error. [pkg_name=${pkg}, number_of_retries=${i}]"
        else
            install_ok='y'
            break
        fi
    done

    if [[ "${install_ok}" = 'n' ]]; then
        echo "install failed. [pkg_name=${pkg}]"
        exit 1
    fi
done

cd /usr/bin || exit 1

gcc_binaries=$(ls ./*-"${GCC_VERSION}")

for raw_binary in ${gcc_binaries}; do
    # shellcheck disable=SC2001
    binary=$(echo "${raw_binary}" | sed -e "s/-${GCC_VERSION}$//")

    if [[ ! -f "/usr/local/bin/${binary}" ]]; then
        ln -s /usr/bin/"${binary}-${GCC_VERSION}" /usr/local/bin/"${binary}"
    fi
done

cd "${TOP_DIR}" || exit 1
