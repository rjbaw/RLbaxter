#!/bin/bash

#symbolic linking relevant for jetpack 4.1.1

cd /usr/lib
ln -s libmpi_cxx.so.1 libmpi_cxx.so.20
ln -s libmpi.so.12 libmpi.so.20

cd /usr/lib/aarch64-linux-gnu

ln -s libm.so libm.so.6

# on host

ln -s /usr/lib/aarch64-linux-gnu/libdrm.so /usr/lib/aarch64-linux-gnu/libdrm.so.2


sudo apt-get install -y cuda-toolkit-10-0 libgomp1 libfreeimage-dev libopenmpi-dev openmpi-bin
sudo apt-get update -qq && sudo apt-get -y install   autoconf   automake   build-essential   cmake   git-core   libass-dev   libfreetype6-dev   libsdl2-dev   libtool   libva-dev   libvdpau-dev   libvorbis-dev   libxcb1-dev   libxcb-shm0-dev   libxcb-xfixes0-dev   pkg-config   texinfo   wget   zlib1g-dev
mkdir -p ~/ffmpeg_sources ~/bin
cd ~/ffmpeg_sources/
wget -O ffmpeg-4.0.2.tar.gz http://ffmpeg.org/releases/ffmpeg-4.0.2.tar.gz
tar xzf ffmpeg-4.0.2.tar.gz
cd ffmpeg-4.0.2
sudo apt-get install libx264-dev libx265-dev
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure   --prefix="$HOME/ffmpeg_build"   --pkg-config-flags="--static"   --extra-cflags="-I$HOME/ffmpeg_build/include"   --extra-ldflags="-L$HOME/ffmpeg_build/lib"   --extra-libs="-lpthread -lm"   --bindir="$HOME/bin"   --enable-gpl  --enable-libass  --enable-libfreetype   --enable-libvorbis   --enable-libx264   --enable-libx265   --enable-nonfree
PATH="$HOME/bin:$PATH" make -j8
PATH="$HOME/bin:$PATH" make install
PATH="$HOME/bin:$PATH" hash -r
source ~/.profile
ffmpeg --version
#cd ~/Downloads
#wget https://download.blender.org/peach/bigbuckbunny_movies/big_buck_bunny_480p_h264.mov
#ffmpeg -v warning -ss 45 -t 2 -i big_buck_bunny_480p_h264.mov -vf scale=300:-1 -gifflags -transdiff -y bbb-notrans.gif
