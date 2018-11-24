# This is an auto generated Dockerfile for ros:desktop-full
# generated from docker_images/create_ros_image.Dockerfile.em
FROM osrf/ros:indigo-desktop-trusty

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-indigo-desktop-full=1.1.6-0* \
    && rm -rf /var/lib/apt/lists/*


#FROM ubuntu:14.04
#RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
   # && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
#ENV LANG en_US.utf8
#RUN apt-get -y update
#RUN update-locale LANG=C LANGUAGE=C LC_ALL=C LC_MESSAGES=POSIX
#RUN apt-get -y install python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential
#RUN apt-get -y install wget
#RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list'
#RUN wget http://packages.ros.org/ros.key -O - | apt-key add -
#RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list'
#RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
#RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
#RUN sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
#RUN ubuntu:14.04 grep -v '^#' /etc/apt/sources.list
#RUN apt-get -y update
#RUN apt-get -y install python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential
#RUN apt-get install libgl1-mesa-dev-lts-trusty
#RUN apt-get -y install ros-indigo-desktop-full
#RUN apt-get -y install ros-indigo-desktop
#RUN apt-get -y install git-core python-argparse python-wstool python-vcstools python-rosdep ros-indigo-control-msgs ros-indigo-joystick-drivers
#RUN apt-get -y install gazebo2 ros-indigo-qt-build ros-indigo-driver-common ros-indigo-gazebo-ros-control ros-indigo-gazebo-ros-pkgs ros-indigo-ros-control ros-indigo-control-toolbox ros-indigo-realtime-tools ros-indigo-ros-controllers ros-indigo-xacro python-wstool ros-indigo-tf-conversions ros-indigo-kdl-parser

# final part
#RUN rosdep init
#RUN rosdep update
#RUN apt-get install python-rosinstall
#RUN mkdir -p ~/ros_ws/src
#RUN cd ~/ros_ws
#RUN rosinstall_generator desktop_full --rosdistro indigo --deps --wet-only --tar > indigo-desktop-full-wet.rosinstall
#RUN wstool init -j8 src indigo-desktop-full-wet.rosinstall
#RUN rosdep install --from-paths src --ignore-src --rosdistro indigo -y
#RUN ./src/catkin/bin/catkin_make_isolated --install-space /opt/ros/indigo -DCMAKE_BUILD_TYPE=Release
#RUN source /opt/ros/indigo/setup.bash
#RUN cd ~/ros_ws/src
#RUN wstool init .
# RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/release-1.1.1/baxter_sdk.rosinstall
#RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/master/baxter_sdk.rosinstall
#RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter_simulator/master/baxter_simulator.rosinstall
#RUN wstool update
#RUN cd ~/ros_ws
#RUN catkin_make
#RUN catkin_make install
#RUN wget https://github.com/RethinkRobotics/baxter/raw/master/baxter.sh
#RUN chmod u+x baxter.sh

#extra packages for SSSA TAUM
#RUN apt-get install ros-indigo-openni2-camera ros-indigo-visp ros-indigo-visp-bridge ros-indigo-moveit-core libzmq-dev libx264-dev ros-indigo-moveit-ros-move-group ros-indigo-ecl-geometry
#RUN apt-get install x11-apps xfce4
#ENV source /opt/ros/indigo/setup.bash
#CMD /bin/bash

#MISSING DOWNLOAD of GAZEBO models inside: user/.gazebo/models
#https://bitbucket.org/osrf/gazebo_models/downloads

#TODO xfce for enabling full desktop: apt-get install xfce4
#TODO nvidia helpers: can be done at docker-run
#TODO automatically source source /opt/ros/indigo/setup.bash by adding it to the .bashrc

