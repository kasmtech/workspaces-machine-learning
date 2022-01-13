#!/bin/bash

source /opt/anaconda3/bin/activate
conda activate

ARCH=$(uname -p)

if [[ "${ARCH}" =~ ^aarch64$ ]] ; then
    pip install folium pgeocode numpy torch opencv-python torchvision typing \
        torchstat torchsummary ptflops onnx onnxruntime lxml scikit-image Pillow ffmpeg \
        klvdata

else
    pip install folium pgeocode numpy torch opencv-python torchvision typing \
        torchstat torchsummary ptflops onnx onnxruntime lxml scikit-image Pillow ffmpeg \
        klvdata tensorflow geopandas

    conda install -c conda-forge basemap matplotlib
fi
