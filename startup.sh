#! bin/sh

cd ~/ros_ws
#source /opt/ros/kinetic/setup.bash
#source ~/ros_ws/devel/setup.bash
#~/ros_ws/./baxter.sh
rosrun baxter_tools enable_robot.py -s
# reset if emergency stopped
# rosrun baxter_tools enable_robot.py –r

# enable robot
rosrun baxter_tools enable_robot.py -e
rosrun baxter_tools tuck_arms.py -u

