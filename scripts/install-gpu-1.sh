#!/usr/bin/env bash
set -e

HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null 2>&1 && pwd )"
BASE_INSTALL_SCRIPT="$HERE/install-base.sh"

install-base() {
  bash $BASE_INSTALL_SCRIPT
}
install-base

install-nvidia-drivers() {
  # From https://www.tensorflow.org/install/gpu
  echo "Installing Nvidia drivers..."
  wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
  mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
  apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
  add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
  apt-get update
  wget -q http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
  apt install ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb -y
  apt-get update
  apt-get install --no-install-recommends nvidia-driver-450 -y
}
install-nvidia-drivers

echo "System needs to reboot now. Rebooting..."
reboot
