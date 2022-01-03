FROM kasmweb/core-cuda-bionic:1.9.0-rolling

USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
WORKDIR $HOME

######### START CUSTOMIZATION ########

# install apt packages
RUN apt-get update && apt-get install -y \
        python3-pip libasound2 libegl1-mesa libgl1-mesa-glx \
        libxcomposite1 libxcursor1 libxi6 libxrandr2 libxss1 \
        libxtst6 gdal-bin ffmpeg vlc dnsutils iputils-ping \
        git remmina remmina-plugin-rdp 

# update pip and install python packages
RUN pip3 install --upgrade pip
RUN pip3 install numpy torch opencv-python torchvision typing \
    torchstat torchsummary ptflops onnx onnxruntime lxml \
    scikit-image Pillow ffmpeg tensorflow geopandas \
    && pip install awscli --upgrade 

# Install Anaconda3
RUN cd /tmp/ && wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh \
    && bash Anaconda3-20*-Linux-x86_64.sh -b -p /opt/anaconda3 \
    && rm -r /tmp/Anaconda3-20*-Linux-x86_64.sh \
    && echo 'source /opt/anaconda3/bin/activate' >> /etc/bash.bashrc \
    # Update all the conad things
    && bash -c "source /opt/anaconda3/bin/activate \
        && conda update -n root conda  \
        && conda update --all \
        && conda clean --all" \
    && /opt/anaconda3/bin/conda config --set ssl_verify /etc/ssl/certs/ca-certificates.crt \
    && /opt/anaconda3/bin/conda install pip \
    && mkdir -p /home/kasm-user/.pip \
    && chown -R 1000:1000 /opt/anaconda3 /home/kasm-default-profile/.conda/

# Install packages in conda environment
USER 1000
RUN bash -c "source /opt/anaconda3/bin/activate \
    && conda activate \
    && pip install folium pgeocode numpy torch opencv-python torchvision typing \
       torchstat torchsummary ptflops onnx onnxruntime lxml scikit-image Pillow ffmpeg \
       klvdata tensorflow geopandas \
    && conda install -c conda-forge \
        basemap \
        matplotlib"
USER root 

# QGIS
RUN apt-get update && apt-get install -y \
        gnupg \
        software-properties-common \
    && wget -qO - https://qgis.org/downloads/qgis-2020.gpg.key | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import \
    && chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg \
    && add-apt-repository "deb https://qgis.org/debian `lsb_release -c -s` main" \
    && apt-get update \
    && apt-get install -y \
        qgis \
        qgis-plugin-grass

# Install Visual Studio Code
#install VS code
RUN cd /tmp && wget https://update.code.visualstudio.com/latest/linux-deb-x64/stable -O vs_code_amd64.deb \
    && dpkg -i /tmp/vs_code_amd64.deb \
    && cp /usr/share/applications/code.desktop $HOME/Desktop \
    && chmod +x $HOME/Desktop/code.desktop \
    && chown 1000:1000 $HOME/Desktop/code.desktop \
    && rm /tmp/vs_code_amd64.deb

# Install PyCharm
RUN cd /opt/ \
    && wget https://download.jetbrains.com/python/pycharm-community-2021.1.1.tar.gz \
    && tar xvf pycharm-community-*.tar.gz \
    && rm -rf pycharm-community-*.tar.gz \
    && mv /opt/pycharm-community-2021.1.1 /opt/pycharm

# Install Chrome
COPY resources/install_chrome.sh /tmp/
RUN bash /tmp/install_chrome.sh

# Install MS Edge
COPY resources/install_edge.sh /tmp/
RUN bash /tmp/install_edge.sh

# Create desktop shortcuts
COPY resources/spyder.desktop $HOME/Desktop/
COPY resources/jupyter.desktop $HOME/Desktop/
COPY resources/pycharm.desktop ${HOME}/Desktop/
RUN cp /usr/share/applications/org.remmina.Remmina.desktop $HOME/Desktop/ \
    && chmod +x $HOME/Desktop/org.remmina.Remmina.desktop \
    && chown 1000:1000 $HOME/Desktop/org.remmina.Remmina.desktop


######### END CUSTOMIZATIONS ########

RUN chown -R 1000:0 $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

CMD ["--tail-log"]
