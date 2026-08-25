FROM        --platform=$TARGETOS/$TARGETARCH ubuntu:24.04

LABEL       author="SquashyHydra"
LABEL       maintainer="SquashyHydra"

LABEL       org.opencontainers.image.source="https://github.com/SquashyHydra/yolks"
LABEL       org.opencontainers.image.licenses=MIT

ENV         DEBIAN_FRONTEND=noninteractive

RUN         apt-get update \
                && apt-get upgrade -y \
                && apt-get install -y --no-install-recommends \
                    bash \
                    ca-certificates \
                    curl \
                    git \
                    wget \
                    tar \
                    gzip \
                    unzip \
                    xz-utils \
                && rm -rf /var/lib/apt/lists/*