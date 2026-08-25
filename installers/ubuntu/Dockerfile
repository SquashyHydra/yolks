FROM        --platform=$TARGETOS/$TARGETARCH ubuntu:24.04

LABEL       author="SquashyHydra"
LABEL       maintainer="SquashyHydra"

LABEL       org.opencontainers.image.source="https://github.com/SquashyHydra/yolks"
LABEL       org.opencontainers.image.licenses=MIT

ENV         DEBIAN_FRONTEND=noninteractive

RUN         apt-get update \
                && apt-get upgrade -y \
                && rm -rf /var/lib/apt/lists/*