#!/bin/bash

ARCH=$(uname -p)
DL_ARCH="x64"

if [[ "${ARCH}" =~ ^aarch64$ ]] ; then
    DL_ARCH="arm64"
fi

cd /tmp 
wget https://update.code.visualstudio.com/latest/linux-deb-${DL_ARCH}/stable -O vs_code.deb
dpkg -i /tmp/vs_code.deb
sed -i 's#Icon=com.visualstudio.code#Icon=/usr/share/code/resources/app/resources/linux/code.png#' /usr/share/applications/code.desktop
sed -i 's#/usr/share/code/code#/usr/share/code/code --no-sandbox##' /usr/share/applications/code.desktop
cp /usr/share/applications/code.desktop $HOME/Desktop
chmod +x $HOME/Desktop/code.desktop
chown 1000:1000 $HOME/Desktop/code.desktop
rm /tmp/vs_code.deb
