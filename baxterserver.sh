#!/bin/sh
cd ~/ros_ws
./baxter.sh
cd ~/RLbaxter/robotics-rl-srl
python -m real_robots.real_baxter_server
