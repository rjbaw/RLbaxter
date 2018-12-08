#dependencies
sudo apt-get install python-pip python3-pip -y
#pip install -U pip breaks pip
#sudo -H pip3 install --upgrade pip
#sudo -H pip2 install --upgrade pip
python -m pip install --upgrade pip
pip --version
sudo apt-get install python-scipy

# rl toolbox
sudo apt-get install swig
cd ~/RLbaxter/robotics-rl-srl
pip install -r requirements.text

# OpenCV 3.4
#cd ~/
#git clone https://github.com/jetsonhacks/buildOpenCVTX2
#cd buildOpenCVTX2
#./buildOpenCV.sh
#./removeOpenCVSources.sh
#cd ~/
#sudo rm -r buildOpenCVTX2 opencv
#cd ~/
#git clone https://github.com/jetsonhacks/buildOpenCVXavier.git
#cd buildOpenCVXavier
#git checkout v1.0
#./buildOpenCV.sh
#./removeOpenCVSources.sh
#cd ~/
#sudo rm -r buildOpenCVXavier

# pytorch
#cd ~/
#pip install ninja
#sudo apt-get install python-pip
#pip install -U pip
#pip --version
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
pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp33 tensorflow-gpu
#pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v411 tensorflow-gpu --user

# gym
#cd ~/
#sudo apt-get install -y python-pyglet python3-opengl zlib1g-dev libjpeg-dev patchelf \
        cmake swig libboost-all-dev libsdl2-dev libosmesa6-dev xvfb ffmpeg
#git clone https://github.com/openai/gym.git
#cd gym
#for full install(source)
#pip3 install -U 'mujoco-py<1.50.2,>=1.50.1'
#pip install -e '.[all]'
#pip install -e .
#pip install gym
#pip install 'gym[all]'
#cd ~/
#sudo rm -r gym
