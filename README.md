
***Under development***


Roadmap:

- Optimization for Nvidia Jetson Xavier

- Upgrading to Jetpack 4.2

- Fixing TPRO algorithm problems

- Guide and anything that can be shared

- Cleaning up

- Fixing continous actions on Baxter


Medium Term plans that maybe abandoned due to Time constraints:


- Compare and contrast with other techniques (Deep Object pose)

- Working on Pybullet Baxter integration

- Adding multiview functionality


Future plans:

Using TensorRT to take advantage of Jetson Xavier


#################################################

Rethink Robotics Baxter on Nvidia Jetson Xavier


Using ROS Kinetic in Ubuntu 16.04 docker


How this works:


ROS Kinetic nodes complete with Baxter SDK are run in Docker container with minimum network isolation as the host.
Host should able to access ROS master interally using published ports
by including this into your host .bashrc file


export ROS_HOSTNAME=yourhostname.local

export ROS_MASTER_URI=http://yourhostname.local:publishedport/


DNS linking is done manually, container is able to connect to robot using static ip specified into 
/etc/hosts file
This is done via run-repository.sh bashscript




***Warning***
The steps below would leave you with no firewall so proceed with caution

How to use:

1. Pull the latest dated image from docker hub
2. Clone this repository
3. ./run-repository.sh
4. To enable/disable robot:
./startup.sh
./shutdown.sh


**Note** 
This is still a work in progress, so if you have any issues feel free to contact me directly.



***Outdated Section***

Special thanks to 

https://github.com/araffin/robotics-rl-srl

https://github.com/jetsonhacks/buildOpenCVXavier

https://github.com/Technica-Corporation/Tegra-Docker#device-parameters

https://github.com/hill-a/stable-baselines

Nvidia Forum members

Resources

https://docs.docker.com/

http://wiki.ros.org/ROS/Tutorials

http://wiki.ros.org/docker/Tutorials

Built docker images from this repo

https://hub.docker.com/r/ezvk7740/baxter/
