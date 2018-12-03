#!/bin/sh

# run container
xhost +local:root
docker run -it \
  -e DISPLAY \
  -e PULSE_SERVER=tcp:$HOST_IP:4713 \
  -e PULSE_COOKIE_DATA=`pax11publish -d | grep --color=never -Po '(?<=^Cookie: ).*'` \
  -e QT_GRAPHICSSYSTEM=native \
  -e QT_X11_NO_MITSHM=1 \
  -e CONTAINER_NAME=ros-kinetic-dev \
  --workdir=/home/$USER \
  ezvk7740/baxter\
  bash
xhost -local:root
