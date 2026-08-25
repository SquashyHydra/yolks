FROM ubuntu:24.04

ENV MYSQL_APT_CONFIG_VERSION=0.8.36-1

LABEL author="SquashyHydra"
LABEL org.opencontainers.image.title="Ubuntu 24.04"
LABEL org.opencontainers.image.description="Ubuntu 24.04 base image for Pterodactyl"
LABEL org.opencontainers.image.source="https://github.com/SquashyHydra/games"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
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

RUN wget https://dev.mysql.com/get/mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb \
    && wget "https://dev.mysql.com/downloads/gpg/?file=mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb&p=37" -O mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb.asc \
    && gpg --keyserver pgp.mit.edu --recv-keys A8D3785C \
    && gpg --verify mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb.asc mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb \
    && rm -v mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb.asc \
    && DEBIAN_FRONTEND="noninteractive" dpkg -i ./mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb \
    && rm -v ./mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb \
    && apt-get update -y \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y mysql-server libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

RUN useradd \
    --create-home \
    --shell /bin/bash \
    container

WORKDIR /home/container

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh \
    && chown container:container /entrypoint.sh \
    && chown -R container:container /home/container

USER container

ENTRYPOINT ["/entrypoint.sh"]
