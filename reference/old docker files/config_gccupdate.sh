#!/usr/bin/env bash
GCCVERSION=4.8

# Setup of GCC 4.8.*
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y install python-software-properties
add-apt-repository ppa:ubuntu-toolchain-r/test


apt-get update

#GCC
apt-get -q -y install g++-$GCCVERSION
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-$GCCVERSION 50
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-$GCCVERSION 50
