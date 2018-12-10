#!/bin/bash

#mkvirtualenv py3 -p python3
workon py3
INSTALL_DIR=/usr/local
ARCH_BIN=7.2
OPENCV_SOURCE_DIR=$HOME

sudo apt-get install build-essential cmake unzip pkg-config
sudo apt-get install libjpeg-dev libpng-dev libtiff-dev
sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install libxvidcore-dev libx264-dev
sudo apt-get install libgtk-3-dev
sudo apt-get install libatlas-base-dev gfortran
sudo apt-get install python3-dev


git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git

#pip install numpy
cd /mnt/sdb/RLbaxter/opencv
mkdir build
cd /mnt/sdb/RLbaxter/opencv/build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D INSTALL_C_EXAMPLES=OFF \
-D OPENCV_EXTRA_MODULES_PATH='~/RLbaxter/opencv_contrib/modules folder'
-D PYTHON_EXECUTABLE=~/.virtualenvs/py3/bin/python \ 
-D BUILD_EXAMPLES=ON\ 
..

make -j8
sudo make install
sudo ldconfig

cd ~/.virtualenvs/py3/lib/python3.6/site-packages/
ln -s /usr/local/lib/python3.6/site-packages/cv2.cpython-36m-aarch64-linux-gnu.so cv2.so



