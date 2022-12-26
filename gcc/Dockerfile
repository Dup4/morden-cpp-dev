ARG GCC_VERSION

FROM gcc:${GCC_VERSION}

USER root
WORKDIR /root/

COPY . /root/

ENV DEBIAN_FRONTEND=noninteractive

ENV CMAKE_VERSION="3.25.1"
ENV BAZEL_VERSION="6.0.0"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM xterm-256color

RUN bash scripts/install_gcc_image.sh \
    && rm -rf /root/*

CMD ["/bin/bash"]
