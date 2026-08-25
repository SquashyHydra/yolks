FROM        --platform=$TARGETOS/$TARGETARCH ubuntu:24.04

LABEL       author="SquashyHydra"
LABEL       maintainer="squashyhydra"

LABEL       org.opencontainers.image.source="https://github.com/SquashyHydra/yolks"
LABEL       org.opencontainers.image.licenses=MIT

ENV         DEBIAN_FRONTEND=noninteractive

RUN         dpkg --add-architecture i386 \
                && apt update \
                && apt upgrade -y \
                && apt -y --no-install-recommends install \
                    ca-certificates \
                    curl \
                    lib32gcc-s1 \
                    libsdl2-2.0-0:i386 \
                    git \
                    wget \
                && rm -rf /var/lib/apt/lists/*