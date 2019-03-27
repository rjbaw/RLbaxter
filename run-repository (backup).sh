#!/bin/sh
HOST_IP=`hostname -I | awk '{print $1}'`
REPOSITORY='ezvk7740/baxter'
JETPACK_VERSION='4.4.1'
CODE_NAME='xenial'
TAG="visdom"

# setup pulseaudio cookie
if [ x"$(pax11publish -d)" = x ]; then
    start-pulseaudio-x11;
    echo `pax11publish -d | grep --color=never -Po '(?<=^Cookie: ).*'`
fi

#  --user=$(id -u) \

# run container
xhost +local:root
docker run -it \
  --device /dev/nvhost-as-gpu \
  --device /dev/nvhost-ctrl \
  --device /dev/nvhost-ctrl-gpu \
  --device /dev/nvhost-ctxsw-gpu \
  --device /dev/nvhost-dbg-gpu \
  --device /dev/nvhost-gpu \
  --device /dev/nvhost-prof-gpu \
  --device /dev/nvhost-sched-gpu \
  --device /dev/nvhost-tsg-gpu \
  --device /dev/nvmap \
  --device /dev/snd \
  --net=host \
  -e DISPLAY \
  -e PULSE_SERVER=tcp:$HOST_IP:4713 \
  -e PULSE_COOKIE_DATA=`pax11publish -d | grep --color=never -Po '(?<=^Cookie: ).*'` \
  -e QT_GRAPHICSSYSTEM=native \
  -e QT_X11_NO_MITSHM=1 \
  -e CONTAINER_NAME=ros-kinetic-dev \
  -e USER=$USER \
  --workdir=/home/$USER \
  -v /dev/shm:/dev/shm \
  -v /etc/localtime:/etc/localtime:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket:ro \
  -v ${XDG_RUNTIME_DIR}/pulse/native:/run/user/1000/pulse/native \
  -v ~/mount/backup:/backup \
  -v ~/mount/data:/data \
  -v ~/mount/project:/project \
  -v ~/mount/tool:/tool \
  -v "/etc/group:/etc/group:ro" \
  -v "/etc/passwd:/etc/passwd:ro" \
  -v "/etc/shadow:/etc/shadow:ro" \
  -v "/etc/sudoers.d:/etc/sudoers.d:ro" \
  -v "/home/$USER/:/home/$USER/" \
  -v "/mnt/sdb:/mnt/sdb" \
  -v "/mnt/sdb:/mnt/sda" \
  -v /usr/local/cuda-10.0/lib64:/usr/local/cuda-10.0/lib64 \
  --network="host"\
  --device=/dev/sda\
  --cap-add=NET_ADMIN\
  --cap-add=NET_RAW\
  --add-host=011311P0016.local:192.168.0.101\
  --rm \
  --name jetson-agx-opengl-${TAG} \
  ${REPOSITORY}:${TAG}
xhost -local:root

#  -v /usr/local/cuda/lib64:/usr/local/cuda/lib64 \
#  --add-host=docker:10.154.148.1\
#  -v /usr/local/lib/openmpi:/usr/local/lib/openmpi\
#  --device=/dev/sdb1\
#  -v /usr/lib:/usr/lib\
