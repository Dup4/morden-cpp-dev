#! /bin/bash

set -e

# shellcheck disable=SC2034
TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

GNU_VERSION=12
LLVM_VERSION=13

# Install dependencies
apt-get clean
apt-get update
apt-get dist-upgrade -y
apt-get install -y gnupg ca-certificates wget

# Key: Ubuntu Toolchain test repo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 1e9377a2ba9ef27f
# Key: LLVM repo
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

# Add sources
echo "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu focal main" >/etc/apt/sources.list.d/ubuntu-toolchain-r-ubuntu-test-focal.list

echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-${LLVM_VERSION} main" >/etc/apt/sources.list.d/llvm.list
echo "deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-${LLVM_VERSION} main" >>/etc/apt/sources.list.d/llvm.list

apt-get update

deps="vim make g++-${GNU_VERSION} gcc-${GNU_VERSION} gdb libc++-${GNU_VERSION}-dev libc++abi-${GNU_VERSION}-dev clang-${LLVM_VERSION} clang++-${LLVM_VERSION} lldb-$LLVM_VERSION lld-$LLVM_VERSION clangd-$LLVM_VERSION"

for pkg in ${deps}; do
    install_ok='n'

    for i in $(seq 10); do
        if ! apt-get install -y "${pkg}"; then
            echo "Network error, install ${pkg} failure, number of retries: ${i}"
        else
            install_ok='y'
            break
        fi
    done

    if [[ "${install_ok}" = 'n' ]]; then
        echo "install ${pkg} failure"
        exit 1
    fi
done

ln -s /usr/bin/g++-${GNU_VERSION} /usr/local/bin/g++
ln -s /usr/bin/gcc-${GNU_VERSION} /usr/local/bin/gcc
ln -s /usr/bin/clang-${LLVM_VERSION} /usr/local/bin/clang
ln -s /usr/bin/clang++-${LLVM_VERSION} /usr/local/bin/clang++

apt-get clean
