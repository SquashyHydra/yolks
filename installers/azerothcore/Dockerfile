FROM --platform=$TARGETOS/$TARGETARCH ubuntu:24.04

LABEL author="SquashyHydra"
LABEL maintainer="SquashyHydra"

LABEL org.opencontainers.image.source="https://github.com/SquashyHydra/yolks"
LABEL org.opencontainers.image.licenses=MIT

ENV DEBIAN_FRONTEND=noninteractive

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
        gnupg \
        wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://dev.mysql.com/get/mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb
RUN wget "https://dev.mysql.com/downloads/gpg/?file=mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb&p=37" -O mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb.asc
RUN gpg --keyserver pgp.mit.edu --recv-keys A8D3785C
RUN gpg --verify mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb.asc mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb
RUN rm -v mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb.asc
RUN DEBIAN_FRONTEND="noninteractive" dpkg -i ./mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb
RUN rm -v ./mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb
RUN apt-get update -y
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y mysql-server libmysqlclient-dev