#!/usr/bin/env bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install tmux build-essential gcc g++ make binutils -y
sudo apt-get install software-properties-common -y


mkdir downloads
cd downloads
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo apt-get update
sudo apt-get install cuda -y
sudo modprobe nvidia
nvidia-smi

wget https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86_64.sh
bash Anaconda2-4.2.0-Linux-x86_64.sh -b
echo 'export PATH="/home/ubuntu/anaconda2/bin:$PATH"' >> ~/.bashrc
export PATH="/home/ubuntu/anaconda2/bin:$PATH"
./home/ubuntu/anaconda2/bin/conda install -y bcolz
./home/ubuntu/anaconda2/bin/conda upgrade -y --all

./home/ubuntu/anaconda2/bin/pip install theano
echo "[global]"
device = gpu
floatX = float32" > ~/.theanorc

./home/ubuntu/anaconda2/bin/pip install keras
mkdir ~/.keras
echo '{
    "image_dim_ordering": "th",
    "epsilon": 1e-07,
    "floatx": "float32",
    "backend": "theano"
}' > ~/.keras/keras.json

wget http://platform.ai/files/cudnn.tgz
tar -zxf cudnn.tgz
cd cuda
sudo cp lib64/* /usr/local/cuda/lib64/
sudo cp include/* /usr/local/cuda/include/
