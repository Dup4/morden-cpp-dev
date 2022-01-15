#! /bin/bash

set -e

# shellcheck disable=SC2034
TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
UBUNTU_TAG="hirsute"

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

GNU_VERSION=11
LLVM_VERSION=13

# Install dependencies
apt clean
apt update
apt dist-upgrade -y
apt install --no-install-recommends --no-install-suggests -y gnupg ca-certificates wget vim git make

# Key: Ubuntu Toolchain test repo
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 1e9377a2ba9ef27f
# Key: LLVM repo
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

# Add sources
echo "deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu ${UBUNTU_TAG} main" >/etc/apt/sources.list.d/ubuntu-toolchain-r-ubuntu-test-${UBUNTU_TAG}.list

cat >/etc/apt/sources.list.d/llvm.list <<EOF
deb http://apt.llvm.org/${UBUNTU_TAG}/ llvm-toolchain-${UBUNTU_TAG}-${LLVM_VERSION} main
deb-src http://apt.llvm.org/${UBUNTU_TAG}/ llvm-toolchain-${UBUNTU_TAG}-${LLVM_VERSION} main
EOF

apt update

deps="
gdb \
gcc-${GNU_VERSION} \
g++-${GNU_VERSION} \
cmake \
libllvm-${LLVM_VERSION}-ocaml-dev \
libllvm${LLVM_VERSION} \
llvm-${LLVM_VERSION} \
llvm-${LLVM_VERSION}-dev \
llvm-${LLVM_VERSION}-doc \
llvm-${LLVM_VERSION}-examples \
llvm-${LLVM_VERSION}-runtime \
clang-${LLVM_VERSION} \
clang-tools-${LLVM_VERSION} \
clang-${LLVM_VERSION}-doc \
libclang-common-${LLVM_VERSION}-dev \
libclang-${LLVM_VERSION}-dev \
libclang1-${LLVM_VERSION} \
clang-format-${LLVM_VERSION} \
clang-tidy-${LLVM_VERSION} \
clangd-${LLVM_VERSION} \
libfuzzer-${LLVM_VERSION}-dev \
lldb-${LLVM_VERSION} \
lld-${LLVM_VERSION} \
libc++-${LLVM_VERSION}-dev \
libc++abi-${LLVM_VERSION}-dev \
libomp-${LLVM_VERSION}-dev \
libclc-${LLVM_VERSION}-dev \
libunwind-${LLVM_VERSION}-dev \
libmlir-${LLVM_VERSION}-dev \
mlir-${LLVM_VERSION}-tools \
"

for pkg in ${deps}; do
    install_ok='n'

    for i in $(seq 10); do
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

apt clean

cd /usr/bin || exit 1

gnu_binaries=$(ls ./*-${GNU_VERSION})
llvm_binaries=$(ls ./*-${LLVM_VERSION})

for raw_binary in ${gnu_binaries}; do
    # shellcheck disable=SC2001
    binary=$(echo "${raw_binary}" | sed -e "s/-${GNU_VERSION}$//")
    ln -s /usr/bin/"${binary}-${GNU_VERSION}" /usr/local/bin/"${binary}"
done

if [[ "${GNU_VERSION}" != "${LLVM_VERSION}" ]]; then
    for raw_binary in ${llvm_binaries}; do
        # shellcheck disable=SC2001
        binary=$(echo "${raw_binary}" | sed -e "s/-${LLVM_VERSION}$//")
        ln -s /usr/bin/"${binary}-${LLVM_VERSION}" /usr/local/bin/"${binary}"
    done
fi

cd - || exit 1
