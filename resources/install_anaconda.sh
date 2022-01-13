#!/bin/bash

ARCH=$(uname -p)

cd /tmp/
wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-${ARCH}.sh
bash Anaconda3-20*-Linux-${ARCH}.sh -b -p /opt/anaconda3
rm -r /tmp/Anaconda3-20*-Linux-${ARCH}.sh 
echo 'source /opt/anaconda3/bin/activate' >> /etc/bash.bashrc
# Update all the conad things
source /opt/anaconda3/bin/activate
conda update -n root conda 
conda update --all
conda clean --all
/opt/anaconda3/bin/conda config --set ssl_verify /etc/ssl/certs/ca-certificates.crt
/opt/anaconda3/bin/conda install pip
mkdir -p /home/kasm-user/.pip
chown -R 1000:1000 /opt/anaconda3 /home/kasm-default-profile/.conda/
