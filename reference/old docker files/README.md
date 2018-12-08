# linuxsetup

For ROS specify both the platform and the ros version

	UBUNTUNAME=xenial ROSNAME=indigo config_ros.sh

For other 3D related packages (little3d and CoCo)

	config_3d.sh	

# NVidia 
With 16.04 everything is smooth

# Nvidia CUDA

Ubuntu 16.04 + CUDA 7.5: from apt-get (initially it was CUDA 7.0)
Ubuntu 14.04 + CUDA 7.0: from apt-get
Ubuntu 14.04 + CUDA 7.5: manual install from script of NVidia

The apt-get is:
 apt-get -s install cuda

The manual install is:
1) Download CUDA run file (see below)
2) Chmod and run it with --override

CUDA run file for 7.5.18:
 http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.18_linux.run


The Nvidia CUDA 7.5 can be also found in https://launchpad.net/ubuntu/+source/nvidia-cuda-toolkit

Other examples of installers:
- https://github.com/BVLC/caffe/wiki/Install-Caffe-on-EC2-from-scratch-(Ubuntu,-CUDA-7,-cuDNN)
- https://www.pugetsystems.com/labs/articles/NVIDIA-CUDA-with-Ubuntu-16-04-beta-on-a-laptop-if-you-just-cannot-wait-775/


# OpenCV 
Ubuntu 16.04 comes with 2.4.9, 14.04 with 2.3.

Prerequisites of OpenCV 3.1

	sudo apt-get install --assume-yes libopencv-dev build-essential cmake git libgtk2.0-dev pkg-config python-dev python-numpy libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libtiff5-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libxine2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev libtbb-dev libqt4-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils unzip

Then see instructions at: 
- https://github.com/BVLC/caffe/wiki/Ubuntu-15.10-OpenCV-3.1-Installation-Guide
- http://www.askaswiss.com/2016/01/how-to-install-opencv-3-1-python-ubuntu-14-04.html

# RGB-D Vision
Manual install is needed for: libfreenect libfreenect2 OpenNI

Repositories:
- git://github.com/OpenKinect/libfreenect.git
- git://github.com/OpenKinect/libfreenect2.git

# PCL
Use the ppa as in the following file

	config_pcl.sh

# GCC
For Ubuntu<16.40 use config_gccupdate.sh for getting a recent compiler
	
	config_gccupdate.sh

	
# TODO
Instructions for PCL and OpenCV with GPU
