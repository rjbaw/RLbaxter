FROM ubuntu:14.04

RUN apt-get -y update
RUN apt-get -y install wget
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list'
RUN wget http://packages.ros.org/ros.key -O - | apt-key add -
RUN apt-get -y update
RUN apt-get -y install ros-indigo-desktop-full
RUN apt-get -y install git-core python-argparse python-wstool python-vcstools python-rosdep ros-indigo-control-msgs ros-indigo-joystick-drivers
RUN apt-get -y install gazebo2 ros-indigo-qt-build ros-indigo-driver-common ros-indigo-gazebo-ros-control ros-indigo-gazebo-ros-pkgs ros-indigo-ros-control ros-indigo-control-toolbox ros-indigo-realtime-tools ros-indigo-ros-controllers ros-indigo-xacro python-wstool ros-indigo-tf-conversions ros-indigo-kdl-parser

# final part
RUN rosdep init
RUN rosdep update
RUN apt-get install python-rosinstall
RUN mkdir -p ~/ros_ws/src
RUN source /opt/ros/indigo/setup.bash
RUN cd ~/ros_ws/src
RUN wstool init .
# RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/release-1.1.1/baxter_sdk.rosinstall
RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/master/baxter_sdk.rosinstall
RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter_simulator/master/baxter_simulator.rosinstall
RUN wstool update
RUN cd ~/ros_ws
RUN catkin_make
RUN catkin_make install
RUN wget https://github.com/RethinkRobotics/baxter/raw/master/baxter.sh
RUN chmod u+x baxter.sh

#extra packages for SSSA TAUM
RUN apt-get install ros-indigo-openni2-camera ros-indigo-visp ros-indigo-visp-bridge ros-indigo-moveit-core libzmq-dev libx264-dev ros-indigo-moveit-ros-move-group ros-indigo-ecl-geometry
RUN apt-get install x11-apps xfce4
ENV source /opt/ros/indigo/setup.bash
CMD /bin/bash

#MISSING DOWNLOAD of GAZEBO models inside: user/.gazebo/models
#https://bitbucket.org/osrf/gazebo_models/downloads

#TODO xfce for enabling full desktop: apt-get install xfce4
#TODO nvidia helpers: can be done at docker-run
#TODO automatically source source /opt/ros/indigo/setup.bash by adding it to the .bashrc

