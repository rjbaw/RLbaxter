#mkvirtualenv ros -p python3
workon py3

#dependencies
sudo apt-get install python-pip python3-pip -y
pip install -U pip
pip --version

# rl toolbox
sudo apt-get install swig -y
cd ~/RLbaxter/baxter-py
pip install -r requirements.text

# OpenCV 3.4
cd ~/
git clone https://github.com/jetsonhacks/buildOpenCVXavier.git
cd buildOpenCVXavier
git checkout v1.0
./buildOpenCV.sh
./removeOpenCVSources.sh
cd ~/
sudo rm -r buildOpenCVXavier

# pytorch
cd ~/
pip install ninja
ipi install --extra-index-url https://drive.google.com/open?id=1h3nsVXskS8yQvLmhrL77m8mImusRy7OR

#git clone http://github.com/pytorch/pytorch
#cd pytorch
#git submodule update --init
#sudo pip install -U setuptools
#sudo pip install -r requirements.txt
#python setup.py build_deps
#sudo python setup.py develop
#cd ~/
#sudo rm -r pytorch

# tensorflow

sudo apt-get install libhdf5-serial-dev hdf5-tools
pip3 install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v411 tensorflow-gpu --user

# gym
#cd ~/
#sudo apt-get install -y python-pyglet python3-opengl zlib1g-dev libjpeg-dev patchelf \
        #cmake swig libboost-all-dev libsdl2-dev libosmesa6-dev xvfb ffmpeg
#git clone https://github.com/openai/gym.git
#cd gym
#for full install(source)
#pip3 install -U 'mujoco-py<1.50.2,>=1.50.1'
#pip install -e '.[all]'
#pip install -e .
#pip install gym
pip install 'gym[all]'
#cd ~/
#sudo rm -r gym
pip install stable-baselines
