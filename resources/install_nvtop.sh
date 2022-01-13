#!/bin/bash

apt install -y cmake libncurses5-dev libncursesw5-dev gcc

cd /tmp
git clone https://github.com/Syllo/nvtop.git
mkdir -p nvtop/build && cd nvtop/build
cmake ..
make
make install
cd /tmp
rm -rf /tmp/nvtop
