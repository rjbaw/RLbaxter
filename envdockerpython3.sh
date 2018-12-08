mkvirtualenv python3 -p python3.5
workon python3

#dependencies
sudo apt-get install python-pip python3-pip -y

# rl toolbox
sudo apt-get install swig -y
cd /mnt/sdb/RLbaxter/robotics-rl-srl
pip install -r requirements.text

# OpenCV 3.4
cd /mnt/sdb/RLbaxter
python3 removepath.py
#cd ~/usb
#git clone https://github.com/jetsonhacks/buildOpenCVTX2
#cd buildOpenCVTX2
#./buildOpenCV.sh
#./removeOpenCVSources.sh
#cd ~/usb
#sudo rm -r buildOpenCVTX2
#cd /mnt/sdb
#git clone https://github.com/jetsonhacks/buildOpenCVXavier.git
cd ~/RLbaxter/BuildOpenCVXavier
#git checkout v1.0
./buildOpenCV.sh
./removeOpenCVSources.sh
cd ~/.virtualenvs/python3/lib/python3.5/site-packages
ln -sf /usr/local/lib/python3.5/cv2.so cv2.so
#cd ~/
#sudo rm -r buildOpenCVXavier

# pytorch
cd /mnt/sdb
pip3 install ninja pyyaml
git clone http://github.com/pytorch/pytorch
cd pytorch
git submodule update --init
sudo pip3 install -U setuptools
sudo pip3 install -r requirements.txt
python3 setup.py build_deps
sudo python3 setup.py develop
cd /mnt/sdb
sudo rm -r pytorch

# tensorflow
pip3 install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v411 tensorflow-gpu --user
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
pip3 install gym
#pip install 'gym[all]'
#cd ~/
#sudo rm -r gym


# baselines
cd /mnt/sdb
git clone https://github.com/openai/baselines.git
cd baselines
pip install -e .
cd /mnt/sdb
sudo rm -r baselines


