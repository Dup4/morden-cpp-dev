FROM ubuntu:20.04

USER root
WORKDIR /root/

COPY . /root/

ENV DEBIAN_FRONTEND=noninteractive
ENV UBUNTU_TAG="focal"
ENV UBUNTU_VERSION="ubuntu20.04"
ENV GNU_VERSION=11
ENV LLVM_VERSION=14
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN cp install.sh ./"${UBUNTU_VERSION}"/\
    && cd "${UBUNTU_VERSION}" \
    && bash install.sh \
    && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen \
    && rm -rf /root/*

CMD ["/bin/bash"]
