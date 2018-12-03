#!bin/bash

cd ~/ros_ws
source devel/setup.bash
./baxter.sh
rosrun baxter_tools enable_robot.py -s
# reset if emergency stopped
# rosrun baxter_tools enable_robot.py –r

# enable robot
rosrun baxter_tools enable_robot.py -e
rosrun baxter_tools tuck_arms.py -u

