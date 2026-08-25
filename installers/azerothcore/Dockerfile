FROM --platform=$TARGETOS/$TARGETARCH ubuntu:24.04

LABEL author="SquashyHydra"
LABEL maintainer="SquashyHydra"

LABEL org.opencontainers.image.source="https://github.com/SquashyHydra/yolks"
LABEL org.opencontainers.image.licenses=MIT

ENV DEBIAN_FRONTEND=noninteractive
ENV MYSQL_APT_CONFIG_VERSION=0.8.36-1
ENV TZ=UTC

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        cmake \
        make \
        gcc \
        g++ \
        clang \
        libssl-dev \
        libbz2-dev \
        libreadline-dev \
        libncurses-dev \
        libboost-all-dev \
        lsb-release \
        mysql-server \
        libmysqlclient-dev \
        gnupg \
        wget \
    && rm -rf /var/lib/apt/lists/*