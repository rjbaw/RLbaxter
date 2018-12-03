#!/bin/bash
sudo apt-get install -y wget
rosdep init
rosdep update
chmod u+x /opt/ros/kinetic/setup.bash
source /opt/ros/kinetic/setup.bash
#source /opt/ros/kinetic/setup.zsh
mkdir -p ~/ros_ws/src
sudo apt-get install -y python-catkin-tools
cd ~/ros_ws
catkin_make
catkin_make install
source devel/setup.bash
#RUN rosinstall_generator desktop_full --rosdistro indigo --deps --wet-only --tar > indigo-desktop-full-wet.rosinstall
#RUN wstool init -j8 src indigo-desktop-full-wet.rosinstall
#RUN rosdep install --from-paths src --ignore-src --rosdistro indigo -y
#RUN ./src/catkin/bin/catkin_make_isolated --install-space /opt/ros/indigo -DCMAKE_BUILD_TYPE=Release
#RUN /bin/bash -c "/opt/ros/kinetic/setup.bash"

sudo apt-get update && sudo apt-get install \
sudo apt-get install git-core python-argparse python-wstool python-vcstools python-rosdep ros-kinetic-control-msgs ros-kinetic-joystick-drivers
sudo apt-get install gazebo7 ros-kinetic-qt-build ros-kinetic-gazebo-ros-control ros-kinetic-gazebo-ros-pkgs ros-kinetic-ros-control ros-kinetic-control-toolbox ros-kinetic-realtime-tools ros-kinetic-ros-controllers ros-kinetic-xacro python-wstool ros-kinetic-tf-conversions ros-kinetic-kdl-parser

cd ~/ros_ws/src
wstool init .
#RUN rosdep install 
#RUN wstool set --target-workspace=src --git
#RUN wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/release-1.1.1/baxter_sdk.rosinstall
wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/master/baxter_sdk.rosinstall
wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter_simulator/kinetic-devel/baxter_simulator.rosinstall
wstool update
cd ~/ros_ws
catkin_make
catkin_make install

# move-it
#sudo apt-get install ros-kinetic-moveit
#git clone -b 26compat https://github.com/mongodb/mongo-cxx-driver.git
#sudo apt-get install scons
#cd mongo-cxx-driver
#sudo scons --prefix=/usr/local/ --full --use-system-boost --disable-warnings-as-errors
#sudo scons install
#cd ~/ros_ws/src
#wstool set -yu warehouse_ros_mongo --git https://github.com/ros-planning/warehouse_ros_mongo.git -v jade-devel
#wstool set -yu warehouse_ros --git https://github.com/ros-planning/warehouse_ros.git -v jade-devel
#git clone https://github.com/ros-planning/moveit_robots.git
#cd ~/ros_ws
#catkin_make
#catkin_make install

# baxter script
wget https://github.com/RethinkRobotics/baxter/raw/master/baxter.sh
chmod u+x baxter.sh
source devel/setup.bash
