#!/bin/sh

#cd ~/ros_ws
#source devel/setup.bash
#./baxter.sh
ufw disable
rosrun baxter_tools enable_robot.py -s

# reset 
# rosrun baxter_tools enable_robot.py –r

# disable robot
rosrun baxter_tools tuck_arms.py -t
rosrun baxter_tools enable_robot.py -d

# check status
rosrun baxter_tools enable_robot.py -s
