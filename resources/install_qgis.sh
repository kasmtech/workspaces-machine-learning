#!/bin/bash

ARCH=$(uname -p)

if [[ "${ARCH}" =~ ^aarch64$ ]] ; then
    apt-get update
    apt-get install -y qgis qgis-plugin-grass
else
    apt-get update
    apt-get install -y gnupg software-properties-common
    wget -qO - https://qgis.org/downloads/qgis-2020.gpg.key | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import
    chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg
    add-apt-repository "deb https://qgis.org/debian `lsb_release -c -s` main"
    apt-get update
    apt-get install -y qgis qgis-plugin-grass
fi
