FROM ubuntu:20.04

USER root
WORKDIR /root/

COPY . /root/

ENV DEBIAN_FRONTEND=noninteractive

ENV UBUNTU_TAG="focal"
ENV UBUNTU_VERSION="ubuntu20.04"
ENV GNU_VERSION=11
ENV LLVM_VERSION=14
ENV CMAKE_VERSION="3.23.1"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM xterm-256color

RUN bash scripts/install_ubuntu.sh \
    && rm -rf /root/*

CMD ["/bin/bash"]
