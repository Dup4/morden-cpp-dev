ARG OS_VERSION

FROM debian:${OS_VERSION}

ARG COMPILER_VERSION

USER root
WORKDIR /root/

COPY . /root/

ENV DEBIAN_FRONTEND=noninteractive

ENV LLVM_VERSION=${COMPILER_VERSION}
ENV CMAKE_VERSION="3.25.1"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM xterm-256color

RUN bash scripts/install_llvm_image.sh \
    && rm -rf /root/*

CMD ["/bin/bash"]
