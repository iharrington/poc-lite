FROM ubuntu:18.04
LABEL maintainer="Isaac Harrington"

RUN apt update && apt upgrade -y
#Install build reqs and deps https://github.com/litecoin-project/litecoin/blob/v0.18.1/doc/build-unix.md#ubuntu--debian
RUN apt update && apt install -y pkg-config build-essential libtool autotools-dev automake bsdmainutils python3
RUN apt update && apt install -y libssl-dev libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev \
    libboost-test-dev libboost-thread-dev
RUN apt update && apt install -y curl gnupg
ENV LC_VER=0.18.1
#re-used dl for version from https://github.com/uphold/docker-litecoin-core/blob/master/0.18/Dockerfile
RUN curl -SLO https://download.litecoin.org/litecoin-${LC_VER}/linux/litecoin-${LC_VER}-x86_64-linux-gnu.tar.gz \
  && curl -SLO https://download.litecoin.org/litecoin-${LC_VER}/linux/litecoin-${LC_VER}-linux-signatures.asc \
# Use MIT pgp to verify -> https://download.litecoin.org/README-HOWTO-GPG-VERIFY-TEAM-MEMBERS-KEY.txt
  && gpg --keyserver keyserver.ubuntu.com --recv-key FE3348877809386C \
  && gpg --verify litecoin-${LC_VER}-linux-signatures.asc \
  && gpg --fingerprint FE3348877809386C \
  && grep $(sha256sum litecoin-${LC_VER}-x86_64-linux-gnu.tar.gz | awk '{ print $1 }') litecoin-${LC_VER}-linux-signatures.asc \
  && tar --strip=2 -xzf *.tar.gz -C /usr/local/bin \
  && rm *.tar.gz
#REMOVE EXTRA FILES AND UNUSED APPS
RUN apt autoremove --purge
#Setup User 'litecoin' for security
RUN groupadd --gid 2001 litecoin && useradd --home-dir /home/litecoin --create-home --uid 1001 --gid 2001 --shell /bin/sh --skel /dev/null litecoin
USER litecoin
CMD ["litecoind"]
