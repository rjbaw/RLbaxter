FROM osrf/ros:kinetic-desktop-full

RUN apt-get update && apt-get -y install locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

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

# final part
RUN rosdep init
RUN rosdep update
RUN apt-get install python-rosinstall
RUN mkdir -p ~/ros_ws/src
#RUN cd ~/ros_ws
#RUN rosinstall_generator desktop_full --rosdistro indigo --deps --wet-only --tar > indigo-desktop-full-wet.rosinstall
#RUN wstool init -j8 src indigo-desktop-full-wet.rosinstall
#RUN rosdep install --from-paths src --ignore-src --rosdistro indigo -y
#RUN ./src/catkin/bin/catkin_make_isolated --install-space /opt/ros/indigo -DCMAKE_BUILD_TYPE=Release
#RUN source /opt/ros/indigo/setup.bash
RUN cd ~/ros_ws/src
RUN wstool init .
#RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/release-1.1.1/baxter_sdk.rosinstall
RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/master/baxter_sdk.rosinstall
RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter_simulator/kinetic-devel/baxter_simulator.rosinstall
RUN wstool update
RUN cd ~/ros_ws
RUN catkin_make
RUN catkin_make install
RUN wget https://github.com/RethinkRobotics/baxter/raw/master/baxter.sh
RUN chmod u+x baxter.sh

#extra packages for SSSA TAUM
#RUN apt-get install ros-indigo-openni2-camera ros-indigo-visp ros-indigo-visp-bridge ros-indigo-moveit-core libzmq-dev libx264-dev ros-indigo-moveit-ros-move-group ros-indigo-ecl-geometry
#RUN apt-get install x11-apps xfce4
#ENV source /opt/ros/indigo/setup.bash
#CMD /bin/bash

CMD ["zsh"]

#MISSING DOWNLOAD of GAZEBO models inside: user/.gazebo/models
#https://bitbucket.org/osrf/gazebo_models/downloads

#TODO xfce for enabling full desktop: apt-get install xfce4
#TODO nvidia helpers: can be done at docker-run
#TODO automatically source source /opt/ros/indigo/setup.bash by adding it to the .bashrc

