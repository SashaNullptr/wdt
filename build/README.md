# Building WDT from Source

## Ubuntu 18.04

### Install Basic Dependencies

```shell script
sudo apt-get update
sudo apt-get install \
    cmake \
    make \
    git \
    wget \
    g++
```

### Install Folly from Source

#### Install Folly Dependencies

Folly requires `fmt`, which *must* be built from source--`libfmt-dev` doesn't work

```shell script
git clone https://github.com/fmtlib/fmt.git && \
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
```

Now we can install all the Folly dependencies available throught apt.

```shell script
sudo apt-get install \
    libboost-all-dev \
    libevent-dev \
    libdouble-conversion-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libiberty-dev \
    liblz4-dev \
    liblzma-dev \
    libsnappy-dev \
    zlib1g-dev \
    binutils-dev \
    libjemalloc-dev \
    libssl-dev \
    pkg-config
```

### Build and Install Folly

```shell script
git clone https://github.com/facebook/folly.git && \
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
```

## Install WDT

### Install WDT Dependencies

```shell script
sudo apt-get install \
    libgtest-dev \
    libboost-all-dev
```

### Build and Install WDT

```shell script
git clone https://github.com/sashanullptr/wdt.git && \
    cd wdt && \
    mkdir _build && cd _build && \
    cmake .. \
    -DBUILD_TESTING=off && \
    make -j$(nproc) && \
    make install && \
    cd ../..
```