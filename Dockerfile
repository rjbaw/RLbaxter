# jetson-agx/opengl:jetpack-$BUILD_VERSION-xenial

ARG REPOSITORY
ARG TAG

# build libglvnd


FROM ${REPOSITORY}:${TAG} as glvnd

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive TERM=linux apt-get install --no-install-recommends -q -y \
    autoconf \
    automake \
    ca-certificates \
    git-core \
    libtool \
    pkg-config \
    python \
    libxext-dev \
    libx11-dev \
    x11proto-gl-dev \
    && rm -rf /var/lib/apt/lists/*

# args
ARG LIBGLVND_VERSION

WORKDIR /opt/libglvnd
RUN git clone --branch="${LIBGLVND_VERSION}" https://github.com/NVIDIA/libglvnd.git . \
    && ./autogen.sh \
    && ./configure --prefix=/usr/local --libdir=/usr/local/lib/aarch64-linux-gnu \
    && make -j"$(nproc)" install-strip \
    && find /usr/local/lib/aarch64-linux-gnu -type f -name 'lib*.la' -delete


# build opengl base image
ARG REPOSITORY
ARG TAG
FROM ${REPOSITORY}:${TAG}
LABEL maintainer "ezvk7740"

# args
ARG BUILD_VERSION

# setup environment variables
ENV container docker
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display

# set the locale
ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8

# install packages
RUN apt-get update \
    && apt-get install -q -y \
    dirmngr \
    gnupg2 \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# setup sources.list
RUN echo "deb-src http://us.archive.ubuntu.com/ubuntu/ $(lsb_release -cs) main restricted \n\
deb-src http://us.archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-updates main restricted \n\
deb-src http://us.archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse \n\
deb-src http://security.ubuntu.com/ubuntu $(lsb_release -cs)-security main restricted" \
    > /etc/apt/sources.list.d/official-source-repositories.list

# install build tools
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive TERM=linux apt-get install --no-install-recommends -q -y \
    apt-transport-https \
    apt-utils \
    bash-completion \
    build-essential \
    ca-certificates \
    clang \
    clang-format \
    cmake \
    cmake-curses-gui \
    curl \
    gconf2 \
    gconf-service \
    gdb \
    git-core \
    git-gui \
    gvfs-bin \
    inetutils-ping \
    llvm \
    llvm-dev \
    nano \
    net-tools \
    pkg-config \
    shared-mime-info \
    software-properties-common \
    sudo \
    tzdata \
    unzip \
    wget \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# download and install nvidia jetson xavier driver package
RUN if [ "$BUILD_VERSION" = "3.3"   ]; then \
      echo "downloading jetpack-$BUILD_VERSION" ; \
      wget -qO- https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.3/lw.xd42/JetPackL4T_33_b39/Tegra186_Linux_R28.2.1_aarch64.tbz2 | \
      tar -xvj -C /tmp/ ; \
      cd /tmp/Linux_for_Tegra ; \
    elif [ "$BUILD_VERSION" = "4.1.1" ]; then \
      echo "downloading jetpack-$BUILD_VERSION" ; \
	  wget -qO- https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/4.1.1/xddsn.im/JetPackL4T_4.1.1_b57/Jetson_Linux_R31.1.0_aarch64.tbz2 | \
      tar -xvj -C /tmp/ ; \
      cd /tmp/Linux_for_Tegra ; \
      # fix error in tar command when extracting configuration files, by overwriting existing configuration files \
      sed -i -e 's@tar xpfm ${LDK_NV_TEGRA_DIR}/config.tbz2@tar --overwrite -xpmf ${LDK_NV_TEGRA_DIR}/config.tbz2@g' apply_binaries.sh ; \
    else \
      echo "error: please specify jetpack version in build.sh" \
      exit 1 ;\
    fi \
    && ./apply_binaries.sh -r / \
    # fix erroneous entry in /etc/ld.so.conf.d/nvidia-tegra.conf \
    && echo "/usr/lib/aarch64-linux-gnu/tegra" > /etc/ld.so.conf.d/nvidia-tegra.conf \
    # add missing /usr/lib/aarch64-linux-gnu/tegra/ld.so.conf \
    && echo "/usr/lib/aarch64-linux-gnu/tegra" > /usr/lib/aarch64-linux-gnu/tegra/ld.so.conf \
    && update-alternatives --install /etc/ld.so.conf.d/aarch64-linux-gnu_GL.conf aarch64-linux-gnu_gl_conf /usr/lib/aarch64-linux-gnu/tegra/ld.so.conf 1000 \
    # fix erroneous entry in /usr/lib/aarch64-linux-gnu/tegra-egl/ld.so.conf \
    && echo "/usr/lib/aarch64-linux-gnu/tegra-egl" > /usr/lib/aarch64-linux-gnu/tegra-egl/ld.so.conf \
    && update-alternatives --install /etc/ld.so.conf.d/aarch64-linux-gnu_EGL.conf aarch64-linux-gnu_egl_conf /usr/lib/aarch64-linux-gnu/tegra-egl/ld.so.conf 1000 \
    && rm -Rf /tmp/Linux_for_Tegra

# copy libglvnd from the previous build stage
COPY --from=glvnd /usr/local/lib/aarch64-linux-gnu /usr/local/lib/aarch64-linux-gnu

# symlink to nvidia.json --> /usr/share/glvnd/egl_vendor.d/10_nvidia.json has already been added to the target rootfs by the nv_tegra/nvidia_drivers installation

RUN echo "/usr/local/lib/aarch64-linux-gnu" >> /etc/ld.so.conf.d/glvnd.conf \
    && ldconfig

# labels
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="jetson-agx/opengl:jetpack-$BUILD_VERSION-xenial"
LABEL org.label-schema.description="NVIDIA Jetson AGX JetPack-$BUILD_VERSION OpenGL - Ubuntu-16.04."
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="xhost +local:root \
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
  -v /dev/shm:/dev/shm \
  -v /etc/localtime:/etc/localtime:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket:ro \
  -v ${XDG_RUNTIME_DIR}/pulse/native:/run/user/1000/pulse/native \
  -v ~/mount/backup:/backup \
  -v ~/mount/data:/data \
  -v ~/mount/project:/project \
  -v ~/mount/tool:/tool \
  --rm \
  --name jetson-agx-opengl-jetpack-$BUILD_VERSION-xenial \
  jetson-agx/opengl:jetpack-$BUILD_VERSION-xenial \
xhost -local:root"

#  -v /usr/local/cuda-10.0:/usr/local/cuda \
#  -v /usr/local/cuda-10.0/lib64:/usr/local/cuda/lib64 \

# update .bashrc
RUN echo \
'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/lib/aarch64-linux-gnu/tegra:/usr/lib/aarch64-linux-gnu/tegra-egl:/usr/lib/aarch64-linux-gnu:/usr/local/lib/aarch64-linux-gnu:/usr/local/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}\n\
export NO_AT_BRIDGE=1\n\
export PATH=/usr/local/cuda/bin:$PATH\n' \
    >> $HOME/.bashrc

#install ros
#SHELL ["/bin/bash", "-c"]

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

RUN apt-get update && apt-get install -y \
    zsh \
    curl \
    wget \
    vim \
    nano \
    sudo \
    unzip 
    #&& rm -rf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get -y install ros-kinetic-desktop-full
RUN apt-get install -y gazebo7 ros-kinetic-qt-build ros-kinetic-gazebo-ros-control ros-kinetic-gazebo-ros-pkgs ros-kinetic-ros-control ros-kinetic-control-toolbox ros-kinetic-realtime-tools ros-kinetic-ros-controllers ros-kinetic-xacro python-wstool ros-kinetic-tf-conversions ros-kinetic-kdl-parser

RUN apt-get install -y python-pip build-essential python3-pip
# required to build certain python libraries
RUN apt-get install python3-dev python-dev -y
RUN apt-get install -y python3-dev python3-numpy python3-py python3-pytest
RUN apt-get -y install python-rosinstall
RUN apt-get -y install python-rosdep python-rosinstall-generator python-wstool python-rosinstall build-essential
RUN pip install --upgrade pip 
#RUN pip install --upgrade pip==9.0.3 caused errors

# install and configure virtualenv
RUN pip install virtualenv 
RUN pip install virtualenvwrapper
ENV WORKON_HOME ~/.virtualenvs
RUN mkdir -p $WORKON_HOME
RUN /bin/bash -c "/usr/local/bin/virtualenvwrapper.sh"
RUN echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc

# offline dependency
RUN apt-get install -y ufw synaptic

# CUDA cuDNN
ARG URL=https://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/3.2.1/m8u2ki/JetPackL4T_321_b23
RUN curl $URL/cuda-repo-l4t-9-0-local_9.0.252-1_arm64.deb -so /tmp/cuda-repo-l4t_arm64.deb
RUN curl $URL/libcudnn7_7.0.5.15-1+cuda9.0_arm64.deb -so /tmp/libcudnn_arm64.deb
RUN curl $URL/libcudnn7-dev_7.0.5.15-1+cuda9.0_arm64.deb -so /tmp/libcudnn-dev_arm64.deb
RUN dpkg -i /tmp/cuda-repo-l4t_arm64.deb
RUN apt-key add /var/cuda-repo-9-0-local/7fa2af80.pub
RUN apt-get update && apt-get install -y cuda-toolkit-9.0
RUN dpkg -i /tmp/libcudnn_arm64.deb
RUN dpkg -i /tmp/libcudnn-dev_arm64.deb
#ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/aarch64-linux-gnu/tegra

# re-link libs in /usr/lib/tegra
#RUN ln -s /usr/lib/aarch64-linux-gnu/tegra/libnvidia-ptxjitcompiler.so.28.2.0 /usr/lib/aarch64-linux-gnu/tegra/libnvidia-ptxjitcompiler.so
#RUN ln -s /usr/lib/aarch64-linux-gnu/tegra/libnvidia-ptxjitcompiler.so.28.2.0 /usr/lib/aarch64-linux-gnu/tegra/libnvidia-ptxjitcompiler.so.1
#RUN ln -sf /usr/lib/aarch64-linux-gnu/tegra/libGL.so /usr/lib/aarch64-linux-gnu/libGL.so

#CUDA 10
#ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/aarch64-linux-gnu/

# initialize ros
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
RUN rosdep init
RUN rosdep update

#RUN /bin/bash -c "~/.bashrc"

#clean up
RUN apt-get -y autoremove && apt-get -y autoclean
RUN rm -rf /var/cache/apt
RUN ln -s /mnt/sdb/RLbaxter ~/

EXPOSE 22

CMD ["bash"]
