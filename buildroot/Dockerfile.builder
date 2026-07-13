FROM debian:bookworm

# Buildroot host tools and AirDC++ portable-build dependencies.
RUN apt-get update && apt-get install -y --no-install-recommends \
      bc \
      build-essential \
      ca-certificates \
      cmake \
      cpio \
      file \
      git \
      gnu-which \
      libncurses-dev \
      nodejs \
      npm \
      patch \
      pcregrep \
      perl \
      pkg-config \
      python3 \
      python3-dev \
      rsync \
      sed \
      unzip \
      wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work
