FROM ubuntu:21.10

USER root
WORKDIR /root/

COPY . /root/

ENV DEBIAN_FRONTEND=noninteractive
ENV UBUNTU_TAG="impish"
ENV UBUNTU_VERSION="ubuntu21.10"
ENV GNU_VERSION=11
ENV LLVM_VERSION=14

RUN cp install.sh ./"${UBUNTU_VERSION}"/\
    && cd "${UBUNTU_VERSION}" \
    && bash install.sh \
    && rm -rf /root/*

CMD ["/bin/bash"]
