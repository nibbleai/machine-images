#!/usr/bin/env bash
set -e

# To be exectuted after system reboot
HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null 2>&1 && pwd )"
ENV="$HERE/env.sh"

source $ENV

install-cuda-and-cudnn() {
  echo "Installing Cuda..."
  wget -q https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/libnvinfer7_7.1.3-1+cuda11.0_amd64.deb
  apt-get install ./libnvinfer7_7.1.3-1+cuda11.0_amd64.deb -y
  apt-get update
  echo "Installing CudNN..."
  apt-get install --no-install-recommends \
    cuda-11-0 \
    libcudnn8=8.0.4.30-1+cuda11.0  \
    libcudnn8-dev=8.0.4.30-1+cuda11.0 -y --allow-downgrades
  # Install TensorRT https://developer.nvidia.com/tensorrt
  apt-get install --no-install-recommends libnvinfer7=7.1.3-1+cuda11.0 \
    libnvinfer-dev=7.1.3-1+cuda11.0 \
    libnvinfer-plugin7=7.1.3-1+cuda11.0 -y --allow-downgrades
}
install-cuda-and-cudnn

install-tensorflow() {
  echo "Installing Tensorflow..."
  $ANACONDA_DIR/bin/pip install tensorflow==2.4.0
}
install-tensorflow

install-pytorch() {
  echo "Installing Pytorch..."
  $ANACONDA_DIR/bin/conda install pytorch torchvision torchaudio cudatoolkit=11.0 -c pytorch -y
}
install-pytorch

clean() {
  # Remove all .deb packages and other installation artifacts
  rm -f ./*
}
clean
