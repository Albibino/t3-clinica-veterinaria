FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
      sudo \
      procps \
      iproute2 \
      nano \
      tar \
      gzip \
      coreutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY scripts/ /app/scripts/

COPY source/  /app/source/

RUN chmod +x /app/scripts/*.sh

RUN mkdir -p /app/clinica

WORKDIR /app/scripts

CMD ["tail", "-f", "/dev/null"]