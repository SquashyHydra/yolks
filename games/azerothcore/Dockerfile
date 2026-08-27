FROM ubuntu:24.04

LABEL author="SquashyHydra"
LABEL org.opencontainers.image.title="Ubuntu 24.04"
LABEL org.opencontainers.image.description="Ubuntu 24.04 base image for Pterodactyl"
LABEL org.opencontainers.image.source="https://github.com/SquashyHydra/games"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV MYSQL_APT_CONFIG_VERSION=0.8.36-1

RUN apt-get update -y \
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

RUN wget "https://dev.mysql.com/get/mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb"
RUN wget "https://dev.mysql.com/downloads/gpg/?file=mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb&p=37" -O mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb.asc
RUN gpg --keyserver pgp.mit.edu --recv-keys A8D3785C
RUN gpg --verify mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb.asc mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb
RUN rm -v mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb.asc
RUN DEBIAN_FRONTEND="noninteractive" dpkg -i ./mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb
RUN rm -v ./mysql-apt-config_${MYSQL_APT_CONFIG_VERSION}_all.deb
RUN apt-get update -y
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y mysql-server libmysqlclient-dev

# Create the Pterodactyl container user with the same UID/GID
# configured in Wings.
RUN groupadd --gid 980 container \
    && useradd \
        --uid 999 \
        --gid 980 \
        --create-home \
        --shell /bin/bash \
        container

# Prepare MySQL data directory while building the image as root.
RUN mkdir -p /var/lib/mysql \
    && chown 999:980 /var/lib/mysql \
    && chmod 777 /var/lib/mysql

RUN mkdir -p /var/log/mysql \
    && chown 999:980 /var/log/mysql \
    && chmod 777 /var/log/mysql

WORKDIR /home/container

RUN mkdir -p /home/container/mysql \
    && chown 999:980 /home/container/mysql \
    && chmod 777 /home/container/mysql

RUN mkdir -p /home/container/mysql_data \
    && chown 999:980 /home/container/mysql_data \
    && chmod 777 /home/container/mysql_data

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh \
    && chown 999:980 /entrypoint.sh \
    && chown -R 999:980 /home/container

USER container

CMD [ "/bin/bash", "/entrypoint.sh" ]