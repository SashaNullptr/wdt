FROM ubuntu:18.04

# Install basic deps for all packages
RUN apt-get update && \
    apt-get install -y \
    cmake \
    git \
    wget \
    g++

# Install Folly

# Folly requires fmt, which *must* be built from source--libfmt-dev doesn't work
RUN git clone https://github.com/fmtlib/fmt.git && \
    cd fmt && \
    mkdir _build && cd _build && \
    cmake .. \
    -DCMAKE_CXX_STANDARD=17 \
    -DCMAKE_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/ \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON && \
    make -j$(nproc) && \
    make install && \
    cd ../..

# Install folly package deps
RUN apt-get install -y \
    g++ \
    cmake \
    libboost-all-dev \
    libevent-dev \
    libdouble-conversion-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libiberty-dev \
    liblz4-dev \
    liblzma-dev \
    libsnappy-dev \
    make \
    zlib1g-dev \
    binutils-dev \
    libjemalloc-dev \
    libssl-dev \
    pkg-config

# Build folly itself from source
RUN git clone https://github.com/facebook/folly.git && \
    cd folly && \
    mkdir _build && cd _build && \
    cmake .. \
    -DCMAKE_CXX_STANDARD=14 \
    -DCMAKE_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/ \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON && \
    make -j$(nproc) && \
    make install && \
    cd ../..

# Install WDT from source

RUN apt-get install -y \
    libgtest-dev \
    libboost-all-dev && \
    rm -rf /var/lib/apt/lists/*

RUN git clone modern-folly-fixes https://github.com/sashanullptr/wdt.git && \
    cd wdt && \
    mkdir _build && cd _build && \
    cmake .. \
    -DBUILD_TESTING=off && \
    make -j$(nproc) && \
    make install && \
    cd ../..

# Clean Up
RUN rm -rf fmt \
    folly \
    wdt && \
    rm -rf /var/lib/apt/lists/*
