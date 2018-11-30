#FROM ros:kinetic-robot

#RUN rm /bin/sh && ln -s /bin/bash /bin/sh
#SHELL ["/bin/bash", "-c"]
# This is an auto generated Dockerfile for ros:robot
# generated from docker_images/create_ros_image.Dockerfile.em
FROM ros:kinetic-ros-base-xenial

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-kinetic-robot=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*


# Basic Utilities
RUN apt-get -y update && apt-get install -y zsh screen tree sudo ssh synaptic

# Latest X11 / mesa GL
#RUN apt-get install -y\
 # xserver-xorg-dev-lts-wily\
 # libegl1-mesa-dev-lts-wily\
 # libgl1-mesa-dev-lts-wily\
 # libgbm-dev-lts-wily\
 # mesa-common-dev-lts-wily\
 # libgles2-mesa-lts-wily\
 # libwayland-egl1-mesa-lts-wily\
 # libopenvg1-mesa

#RUN apt-get install -y\
 # qt4-dev-tools\
 # libqt5core5a libqt5dbus5 libqt5gui5 libwayland-client0\
 # libwayland-server0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1\
 # libxcb-render-util0 libxcb-util0 libxcb-xkb1 libxkbcommon-x11-0\
 # libxkbcommon0

RUN apt-get install -y x11-apps python-pip build-essential
RUN pip install catkin_tools

# Make SSH available
EXPOSE 22

RUN apt-get -y update


RUN apt-get -y install wget


#RUN apt-get -y install ros-kinetic-desktop-full

RUN apt-get install -y gazebo7 ros-kinetic-qt-build ros-kinetic-gazebo-ros-control ros-kinetic-gazebo-ros-pkgs ros-kinetic-ros-control ros-kinetic-control-toolbox ros-kinetic-realtime-tools ros-kinetic-ros-controllers ros-kinetic-xacro python-wstool ros-kinetic-tf-conversions ros-kinetic-kdl-parser
# required to build certain python libraries
RUN apt-get install python3-dev python-dev -y
RUN apt-get -y install python-rosinstall
RUN apt-get -y install python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential
RUN pip install --upgrade pip 

# install and configure virtualenv
RUN pip install virtualenv 
RUN pip install virtualenvwrapper
ENV WORKON_HOME ~/.virtualenvs
RUN mkdir -p $WORKON_HOME
RUN /bin/bash -c "/usr/local/bin/virtualenvwrapper.sh"

RUN rosdep init
RUN rosdep update
RUN source /opt/ros/kinetic/setup.bash
RUN mkdir -p ~/ros_ws/src
#RUN cd ~/ros_ws
#RUN source devel/setup.bash
RUN catkin_make
#RUN rosinstall_generator desktop_full --rosdistro indigo --deps --wet-only --tar > indigo-desktop-full-wet.rosinstall
#RUN wstool init -j8 src indigo-desktop-full-wet.rosinstall
#RUN rosdep install --from-paths src --ignore-src --rosdistro indigo -y
#RUN ./src/catkin/bin/catkin_make_isolated --install-space /opt/ros/indigo -DCMAKE_BUILD_TYPE=Release
RUN source /opt/ros/kinetic/setup.bash

RUN cd ~/ros_ws/src
RUN wstool init .
RUN rosdep install 
#RUN wstool set --target-workspace=src
#RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/release-1.1.1/baxter_sdk.rosinstall
RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/master/baxter_sdk.rosinstall
RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter_simulator/kinetic-devel/baxter_simulator.rosinstall
RUN wstool update
RUN cd ~/ros_ws
RUN catkin_make
RUN catkin_make install
RUN wget https://github.com/RethinkRobotics/baxter/raw/master/baxter.sh
RUN chmod u+x baxter.sh

# Switch to user
USER "${user}"
# This is required for sharing Xauthority
ENV QT_X11_NO_MITSHM=1
ENV CATKIN_TOPLEVEL_WS="${workspace}/devel"
# Switch to the workspace
WORKDIR ${workspace}

CMD /bin/bash

#MISSING DOWNLOAD of GAZEBO models inside: user/.gazebo/models
#https://bitbucket.org/osrf/gazebo_models/downloads
#-e QT_X11_NO_MITSHM=1 -v /tmp/.X11-unix -e DISPLAY
#TODO xfce for enabling full desktop: apt-get install xfce4
#TODO nvidia helpers: can be done at docker-run
#TODO automatically source source /opt/ros/indigo/setup.bash by adding it to the .bashrc
RUN xhost + 
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
RUN source ~/.bashrc
