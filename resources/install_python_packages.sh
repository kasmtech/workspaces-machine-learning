#!/bin/bash

ARCH=$(uname -p)

pip3 install --upgrade pip

if [[ "${ARCH}" =~ ^aarch64$ ]] ; then
    pip3 install numpy torch opencv-python torchvision typing \
        torchstat torchsummary ptflops onnx onnxruntime lxml \
        scikit-image Pillow ffmpeg geopandas
    pip3 install tensorflow -f https://tf.kmtea.eu/whl/stable.html
else
    pip3 install numpy torch opencv-python torchvision typing \
        torchstat torchsummary ptflops onnx onnxruntime lxml \
        scikit-image Pillow ffmpeg tensorflow geopandas
fi

pip install awscli --upgrade
