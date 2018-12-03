#!/bin/bash
apt-get install wget
rosdep init
rosdep update
chmod u+x /opt/ros/kinetic/setup.bash
source /opt/ros/kinetic/setup.bash
mkdir -p ~/ros_ws/src
#RUN cd ~/ros_ws/src
apt-get install -y python-catkin-tools
#RUN catkin_init_workspace
cd ~/ros_ws
catkin_make
source devel/setup.bash
#RUN rosinstall_generator desktop_full --rosdistro indigo --deps --wet-only --tar > indigo-desktop-full-wet.rosinstall
#RUN wstool init -j8 src indigo-desktop-full-wet.rosinstall
#RUN rosdep install --from-paths src --ignore-src --rosdistro indigo -y
#RUN ./src/catkin/bin/catkin_make_isolated --install-space /opt/ros/indigo -DCMAKE_BUILD_TYPE=Release
#RUN /bin/bash -c "/opt/ros/kinetic/setup.bash"

cd ~/ros_ws/src
wstool init .
#RUN rosdep install 
#RUN wstool set --target-workspace=src --git
#RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/release-1.1.1/baxter_sdk.rosinstall
wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/master/baxter_sdk.rosinstall
wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter_simulator/kinetic-devel/baxter_simulator.rosinstall
wstool update
cd ~/ros_ws
source /opt/ros/kinetic/setup.bash
source ~/.bashrc
catkin_make
catkin_make install
wget https://github.com/RethinkRobotics/baxter/raw/master/baxter.sh
chmod u+x baxter.sh

