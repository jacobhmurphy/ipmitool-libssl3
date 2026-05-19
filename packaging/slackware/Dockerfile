# Builder for the ipmitool Slackware/unRAID .txz package.
#
# We use Debian 12 (bookworm) here: it ships glibc 2.36 + OpenSSL 3.0,
# matching Slackware -current / unRAID 7 (which is the version that has
# libssl3).  Older Slackware 15.0 / unRAID 6 still ship OpenSSL 1.1, so
# the .txz this produces is intended for unRAID 7 / Slackware-current.
# Running a true Slackware container under amd64 QEMU emulation on Apple
# Silicon is unreliable (slackpkg / xz / grep segfault), so we install
# the same toolchain on Debian and produce the .txz manually -- the
# Slackware package format is just a tar.xz with a specific layout plus
# an install/slack-desc metadata file.
#
# Build:  docker build --platform linux/amd64 -t ipmitool-slackbuild \
#             -f packaging/slackware/Dockerfile .
# Run:    docker run --rm --platform linux/amd64 -v "$PWD/dist:/out" \
#             ipmitool-slackbuild

FROM --platform=linux/amd64 debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Deliberately omit libreadline/libncurses dev packages -- ipmishell is
# disabled in the SlackBuild and we don't want autoconf to auto-link them.
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        autoconf automake libtool m4 pkg-config \
        libssl-dev \
        xz-utils tar gzip \
        ca-certificates \
        file \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

COPY packaging/slackware/ipmitool.SlackBuild /build/ipmitool.SlackBuild
COPY packaging/slackware/slack-desc          /build/slack-desc
COPY . /build/src

RUN chmod +x /build/ipmitool.SlackBuild

VOLUME ["/out"]

ENV OUTPUT=/out \
    SRC=/build/src \
    VERSION=1.8.19 \
    BUILD=1 \
    TAG=jhm \
    ARCH=x86_64

CMD ["/build/ipmitool.SlackBuild"]
