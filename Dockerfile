#FROM osrf/ros:kinetic-desktop-full

#RUN apt-get update && apt-get -y install locales
#RUN locale-gen en_US.UTF-8
#ENV LANG en_US.UTF-8

FROM ros:kinetic-robot

#RUN rm /bin/sh && ln -s /bin/bash /bin/sh
#SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
    tmux \
    zsh \
    curl \
    wget \
    vim \
    emacs24 \
    sudo \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    mesa-utils \
    unzip \
    && rm -rf /var/likb/apt/lists/*
RUN apt-get -y install ros-kinetic-desktop-full
RUN apt-get install -y gazebo7 ros-kinetic-qt-build ros-kinetic-gazebo-ros-control ros-kinetic-gazebo-ros-pkgs ros-kinetic-ros-control ros-kinetic-control-toolbox ros-kinetic-realtime-tools ros-kinetic-ros-controllers ros-kinetic-xacro python-wstool ros-kinetic-tf-conversions ros-kinetic-kdl-parser

RUN apt-get install -y x11-apps python-pip build-essential
RUN pip install catkin_tools

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
RUN chmod u+x /opt/ros/kinetic/setup.zsh
RUN /bin/bash -c "/opt/ros/kinetic/setup.zsh"
#RUN cd ~/ros_ws/src
#RUN catkin_make
#RUN wstool init .
#RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/release-1.1.1/baxter_sdk.rosinstall
#RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/master/baxter_sdk.rosinstall
#RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter_simulator/kinetic-devel/baxter_simulator.rosinstall
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

CMD ["zsh"]
EXPOSE 22

#MISSING DOWNLOAD of GAZEBO models inside: user/.gazebo/models
#https://bitbucket.org/osrf/gazebo_models/downloads

#TODO xfce for enabling full desktop: apt-get install xfce4
#TODO nvidia helpers: can be done at docker-run
#TODO automatically source source /opt/ros/indigo/setup.bash by adding it to the .bashrc

