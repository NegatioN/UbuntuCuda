#!/usr/bin/env bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install tmux build-essential gcc g++ make binutils -y
sudo apt-get install software-properties-common -y

# References to Nvida .deb repo
export CUDA_FILE="cuda-repo-ubuntu1604_8.0.44-1_amd64.deb"
# installer-file for conda
export CONDA_FILE="Anaconda2-4.2.0-Linux-x86_64.sh"
# CUDNN actual tar.gz
export CUDDN_FILE="cudnn.tgz"


mkdir downloads
cd downloads
if [ ! -f ${CUDA_FILE} ]; then
    wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/${CUDA_FILE}
fi
sudo dpkg -i ${CUDA_FILE}
sudo apt-get update
sudo apt-get install cuda -y
sudo modprobe nvidia
nvidia-smi

if [ ! -f ${CUDDN_FILE} ]; then
    wget http://platform.ai/files/${CUDDN_FILE}
fi

tar -zxf ${CUDDN_FILE}
cd cuda
sudo cp lib64/* /usr/local/cuda/lib64/
sudo cp include/* /usr/local/cuda/include/

if [ -z ${CONDA+x} ]; then

    if [ ! -f ${CONDA_FILE} ]; then
        wget https://repo.continuum.io/archive/${CONDA_FILE}
    fi
    bash ${CONDA_FILE} -b
    echo 'export PATH="/home/${MY_LINUX_USER}/anaconda2/bin:$PATH"' >> ~/.bashrc
    export PATH="/home/${MY_LINUX_USER}/anaconda2/bin:$PATH"
    conda install -y bcolz
    conda upgrade -y --all

    pip install theano
    echo "[global]
    device = gpu
    floatX = float32" > ~/.theanorc

    pip install keras
    mkdir ~/.keras
    echo '{
        "image_dim_ordering": "th",
        "epsilon": 1e-07,
        "floatx": "float32",
        "backend": "theano"
    }' > ~/.keras/keras.json
fi

echo 'export PATH="/usr/local/cuda/bin:$PATH"' >> ~/.bashrc