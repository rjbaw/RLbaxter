
***Under development***

Collection of Results:

https://drive.google.com/drive/folders/1YfochtM8Ie_TiUsEzNOlyCkymv0zvq4Z?usp=sharing

Detailed Guide:

Coming Soon


Roadmap:

1. Upgrading to Jetpack 4.2

2. Fixing TPRO algorithm problems
   CMA-ES and ars parser problem

3. Adding multiview functionality to Baxter

4. Fixing continous actions on Baxter
   Working on Pybullet Baxter integration


Abandoned :

- Using TensorRT to take advantage of Jetson Xavier
- Compare and contrast with other techniques (Deep Object pose)

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
