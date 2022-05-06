#! /bin/bash

set -e

# shellcheck disable=SC2034
TOP_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

# Install dependencies
apt clean
apt update
apt dist-upgrade -y
apt install --no-install-recommends --no-install-suggests -y \
    openssh-client \
    gnupg2 \
    dirmngr \
    iproute2 \
    procps \
    lsof \
    htop \
    net-tools \
    psmisc \
    curl \
    wget \
    rsync \
    ca-certificates \
    unzip \
    zip \
    vim \
    less \
    jq \
    lsb-release \
    software-properties-common \
    apt-transport-https \
    dialog \
    libc6 \
    libgcc1 \
    libkrb5-3 \
    libgssapi-krb5-2 \
    zlib1g \
    locales \
    sudo \
    ncdu \
    man-db \
    strace \
    manpages \
    manpages-dev \
    init-system-helpers \
    git \
    python3-pip \
    python3-setuptools \
    zsh \
    tmux

ln -s /usr/bin/python3 /usr/bin/python

sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen
locale-gen
