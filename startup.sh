#! /bin/sh

cd ~/ros_ws
#source /opt/ros/kinetic/setup.bash
#source ~/ros_ws/devel/setup.bash
#~/ros_ws/./baxter.sh
ufw disable
rosservice call /cameras/close right_hand_camera
rosservice call /cameras/open '{name: head_camera, settings: {width: 1280, height: 800 }}'

rosrun baxter_tools enable_robot.py -s
# reset if emergency stopped
# rosrun baxter_tools enable_robot.py –r

# enable robot
rosrun baxter_tools enable_robot.py -e
rosrun baxter_tools tuck_arms.py -u

