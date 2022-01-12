FROM ubuntu:20.04

USER root
WORKDIR /root/

COPY ./* /root/

RUN bash install.sh \
    && rm -rf /root/*

CMD ["/bin/bash"]
