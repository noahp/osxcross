FROM ubuntu:bionic

# Install build tools
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -yy && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yy \
        automake            \
        build-essential     \
        clang               \
        cmake               \
        curl                \
        git                 \
        libssl-dev          \
        libtool             \
        lzma-dev            \
        pkg-config          \
        python              \
        vim                 \
        wget

# Install osxcross
# NOTE: The Docker Hub's build machines run varying types of CPUs, so an image
# built with `-march=native` on one of those may not run on every machine - I
# ran into this problem when the images wouldn't run on my 2013-era Macbook
# Pro.  As such, we remove this flag entirely.
ENV OSXCROSS_SDK_VERSION 10.13
RUN cd /opt &&                                                  \
    git clone https://github.com/tpoechtrager/osxcross.git &&   \
    cd osxcross &&                                              \
    git checkout 1b731164dfd56de2ff20b530ec70c7a88a7b6ea6 &&    \
    sed -i -e 's|-march=native||g' ./build_clang.sh ./build.sh && \
    ./tools/get_dependencies.sh

RUN cd /opt/osxcross && \
    curl -L -o ./tarballs/MacOSX${OSXCROSS_SDK_VERSION}.sdk.tar.xz \
        https://github.com/phracker/MacOSX-SDKs/releases/download/10.15/MacOSX${OSXCROSS_SDK_VERSION}.sdk.tar.xz && \
    yes | PORTABLE=true ./build.sh && \
    ./build_compiler_rt.sh

ENV PATH $PATH:/opt/osxcross/target/bin
