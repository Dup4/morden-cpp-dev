#! /bin/bash

set -e

# shellcheck disable=SC2034
TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

APT_INSTALL=apt install --no-install-recommends --no-install-suggests -y

GNU_VERSION=11
LLVM_VERSION=13

# Install dependencies
apt clean
apt update
apt dist-upgrade -y
${APT_INSTALL} gnupg ca-certificates wget vim git make man-db

# Key: Ubuntu Toolchain test repo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 1e9377a2ba9ef27f
# Key: LLVM repo
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

# Add sources
echo "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu focal main" >/etc/apt/sources.list.d/ubuntu-toolchain-r-ubuntu-test-focal.list

cat >/etc/apt/sources.list.d/llvm.list <<EOF
deb http://apt.llvm.org/focal/ llvm-toolchain-focal-${LLVM_VERSION} main
deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-${LLVM_VERSION} main
EOF

apt update

deps="gdb \
gcc-${GNU_VERSION} \
g++-${GNU_VERSION} \
libc++-${GNU_VERSION}-dev \
libc++abi-${GNU_VERSION}-dev \
cmake \
libllvm-${LLVM_VERSION}-ocaml-dev \
libllvm${LLVM_VERSION} \
llvm-${LLVM_VERSION} \
llvm-${LLVM_VERSION}-dev \
llvm-${LLVM_VERSION}-doc \
llvm-${LLVM_VERSION}-examples \
llvm-${LLVM_VERSION}-runtime \
clang-${LLVM_VERSION} \
libclang-common-${LLVM_VERSION}-dev \
libclang-${LLVM_VERSION}-dev \
libclang1-${LLVM_VERSION} \
libfuzzer-${LLVM_VERSION}-dev \
lldb-${LLVM_VERSION} \
lld-${LLVM_VERSION} \
libomp-${LLVM_VERSION}-dev \
clang-tools-${LLVM_VERSION} \
clang-${LLVM_VERSION}-doc \
clang-tidy-${LLVM_VERSION} \
clangd-${LLVM_VERSION}"

for pkg in ${deps}; do
    install_ok='n'

    for i in $(seq 10); do
        if ! ${APT_INSTALL} "${pkg}"; then
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

ln -s /usr/bin/g++-${GNU_VERSION} /usr/local/bin/g++
ln -s /usr/bin/gcc-${GNU_VERSION} /usr/local/bin/gcc

ln -s /usr/bin/llvm-ar-${LLVM_VERSION} /usr/bin/llvm-ar
ln -s /usr/bin/llvm-as-${LLVM_VERSION} /usr/bin/llvm-as

ln -s /usr/bin/clang-${LLVM_VERSION} /usr/local/bin/clang
ln -s /usr/bin/clang++-${LLVM_VERSION} /usr/local/bin/clang++
ln -s /usr/bin/lldb-${LLVM_VERSION} /usr/local/bin/lldb
ln -s /usr/bin/clang-format-${LLVM_VERSION} /usr/local/bin/clang-format
ln -s /usr/bin/clang-tidy-${LLVM_VERSION} /usr/local/bin/clang-tidy
ln -s /usr/bin/clangd-${LLVM_VERSION} /usr/local/bin/clangd

apt-get clean
