Rethink Robotics Baxter on Nvidia Jetson Xavier


Using ROS Kinetic in Ubuntu 16.04 docker

How this works:

ROS Kinetic nodes complete with Baxter SDK are run in Docker container with minimum network isolation as the host.
Host should able to access ROS master interally using published ports
by including this into your .bashrc file

export ROS_HOSTNAME=yourhostname.local
export ROS_MASTER_URI=http://yourhostname.local:publishedport/

DNS linking is done manually, container is able to connect to robot using static ip specified into 
/etc/hosts file
This is done via run-repository.sh bashscript




***Warning***
The steps below would leave you with no firewall so proceed with caution

How to use:

1. Pull the lastest dated image from docker hub
2. Clone this repository
3. ./run-repository.sh
4. To enable/disable robot:
./startup.sh
./shutdown.sh


**Note** 
This is still a work in progress, so if you have any issues feel free to contact me directly.


Special thanks to 

https://github.com/araffin/robotics-rl-srl

https://github.com/jetsonhacks/buildOpenCVXavier

https://github.com/Technica-Corporation/Tegra-Docker#device-parameters

https://github.com/hill-a/stable-baselines

Resources

https://docs.docker.com/

http://wiki.ros.org/ROS/Tutorials

http://wiki.ros.org/docker/Tutorials

Built docker images from this repo

https://hub.docker.com/r/ezvk7740/baxter/
