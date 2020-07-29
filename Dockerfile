## FFmpeg compilation based off https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

FROM ubuntu:bionic as build

# Install dependencies
RUN apt-get update -qq && apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libgnutls28-dev \
  libsdl2-dev \
  libtool \
  libunistring-dev \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  pkg-config \
  texinfo \
  wget \
  yasm \
  zlib1g-dev

# NASM
RUN apt-get install -y nasm

# H.264
RUN apt-get install -y libx264-dev libnuma-dev

# VP9
RUN apt-get install -y libvpx-dev

# AAC Audio
RUN apt-get install -y libfdk-aac-dev

# MP3Lame
RUN apt-get install -y libmp3lame-dev

# Opus
RUN apt-get install -y libopus-dev

# Add source and setup folders
ADD . /opt/ffmpeg-src
RUN mkdir -p /opt/bin

# Make and Install FFmpeg
WORKDIR /opt/ffmpeg-src
ENV BUILD_DIR "/opt/ffmpeg_build"
ENV PKG_CONFIG_PATH "$BUILD_DIR/lib/pkgconfig"

RUN ./configure \
  --prefix="$BUILD_DIR" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$BUILD_DIR/include" \
  --extra-ldflags="-L$BUILD_DIR/lib" \
  --extra-libs="-lpthread -lm" \
  --bindir="/opt/bin" \
  --enable-gpl \
  --enable-gnutls \
  --enable-libaom \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree

RUN make && make install && hash -r