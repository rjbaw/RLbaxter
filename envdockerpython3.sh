#mkvirtualenv ros -p python3
#workon ros

#dependencies
sudo apt-get install python-pip python3-pip -y

# rl toolbox
sudo apt-get install swig
cd ~/RLbaxter/robotics-rl-srl
pip install -r requirements.text


# OpenCV 3.4
cd ~/usb
git clone https://github.com/jetsonhacks/buildOpenCVTX2
cd buildOpenCVTX2
./buildOpenCV.sh
./removeOpenCVSources.sh
cd ~/usb
sudo rm -r buildOpenCVTX2
#cd ~/
#git clone https://github.com/jetsonhacks/buildOpenCVXavier.git
#cd buildOpenCVXavier
#git checkout v1.0
#./buildOpenCV.sh
#./removeOpenCVSources.sh
#cd ~/
#sudo rm -r buildOpenCVXavier

# pytorch
cd ~/usb
pip install ninja
sudo apt-get install python-pip
pip install -U pip
pip --version
git clone http://github.com/pytorch/pytorch
cd pytorch
git submodule update --init
sudo pip install -U setuptools
sudo pip install -r requirements.txt
python setup.py build_deps
sudo python setup.py develop
cd ~/usb
sudo rm -r pytorch

# tensorflow
#pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp33 tensorflow-gpu
sudo apt-get install  -y openjdk-8-jdk
sudo pip3 install six mock h5py enum34
# building bazel
cd /mnt/sdb
wget https://github.com/bazelbuild/bazel/releases/download/0.15.2/bazel-0.15.2-dist.zip
unzip bazel-0.15.2-dist.zip -d bazel-0.15.2-dist
cd bazel-0.15.2-dist
./compile.sh
sudo cp output/bazel /usr/local/bin
bazel help
cd /mnt/sdb
sudo rm -r bazel-0.15.2-dist
# tf source code
cd /mnt/sdb
wget https://github.com/tensorflow/tensorflow/archive/v1.8.0.tar.gzi -O tensorflow-1.8.0.tar.gz
tar xzvf tensorflow-1.8.0.tar.gz
wget https://github.com/peterlee0127/tensorflow-nvJetson/blob/master/patch/tensorflow1.8.patch
git apply tensorflow1.8.patch
cd /mnt/sdb/src/tensorflow-1.8.0
./configure


# gym
#cd ~/
#sudo apt-get install -y python-pyglet python3-opengl zlib1g-dev libjpeg-dev patchelf cmake swig libboost-all-dev libsdl2-dev libosmesa6-dev xvfb ffmpeg
#git clone https://github.com/openai/gym.git
#cd gym
#for full install(source)
#pip3 install -U 'mujoco-py<1.50.2,>=1.50.1'
#pip install -e '.[all]'
#pip install -e .
pip install gym
#pip install 'gym[all]'
#cd ~/
#sudo rm -r gym

# baselines
cd ~/usb
git clone https://github.com/openai/baselines.git
cd baselines
pip install -e .
cd ~/usb
sudo rm -r baselines


