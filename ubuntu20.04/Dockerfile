FROM ubuntu:20.04

USER root
WORKDIR /root/

COPY . /root/

ENV DEBIAN_FRONTEND=noninteractive
ENV UBUNTU_TAG="focal"
ENV UBUNTU_VERSION="ubuntu20.04"
ENV GNU_VERSION=11
ENV LLVM_VERSION=14

RUN echo "${UBUNTU_VERSION}" > /etc/hostname \
    && cp install.sh ./"${UBUNTU_VERSION}"/\
    && cd "${UBUNTU_VERSION}" \
    && bash install.sh \
    && rm -rf /root/*

CMD ["/bin/bash"]
