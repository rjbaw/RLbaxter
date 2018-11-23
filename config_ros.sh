#!/usr/bin/env bash
#
#UBUNTU NAMES
#precise 12.04
#trusty  14.04
#xenial  16.04
#
#ROS NAMES
#hydro   
#indigo LTS
#jade
#kinetic LTS

if [ -z "$UBUNTUNAME" ]; then
    echo "Need to set UBUNTUNAME: precise trusty xenial"
    exit 1
fi  
if [ -z "$ROSNAME" ]; then
    echo "Need to set ROSNAME: hydro indigo jade kinetic"
    exit 1
fi  
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $UBUNTUNAME main" > /etc/apt/sources.list.d/ros-latest.list'
apt-get update
apt-get -q -y --force-yes  install ros-$ROSNAME-desktop-full
apt-cache search ros-$ROSNAME
rosdep init
rosdep update
apt-get -q -y --force-yes install python-rosinstall

#User integration
echo "source /opt/ros/$ROSNAME/setup.bash" >> ~/.bashrc
source ~/.bashrc
