FROM ubuntu:24.04

LABEL author="SquashyHydra"
LABEL org.opencontainers.image.title="Ubuntu 24.04"
LABEL org.opencontainers.image.description="Ubuntu 24.04 base image for Pterodactyl"
LABEL org.opencontainers.image.source="https://github.com/SquashyHydra/games"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

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
        mysql-server \
        libmysqlclient-dev \
        gnupg \
        wget \
    && rm -rf /var/lib/apt/lists/*

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
    && chown -R container:container /var/lib/mysql \
    && chown -R container:container /var/log/mysql

WORKDIR /home/container

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh \
    && chown container:container /entrypoint.sh \
    && chown -R container:container /home/container

USER container

CMD [ "/bin/bash", "/entrypoint.sh" ]