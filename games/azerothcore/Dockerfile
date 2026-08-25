FROM ubuntu:24.04

LABEL author="SquashyHydra"
LABEL org.opencontainers.image.title="Ubuntu 24.04"
LABEL org.opencontainers.image.description="Ubuntu 24.04 base image for Pterodactyl"
LABEL org.opencontainers.image.source="https://github.com/SquashyHydra/games"

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

CMD [ "/bin/bash", "/entrypoint.sh" ]
