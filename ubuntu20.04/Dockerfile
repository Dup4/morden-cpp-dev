FROM ubuntu:20.04

USER root
WORKDIR /root/

ENV DEBIAN_FRONTEND=noninteractive

COPY . /root/

RUN bash install.sh \
    && rm -rf /root/*

CMD ["/bin/bash"]
