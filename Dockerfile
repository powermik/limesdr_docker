#LINKS:
#https://wiki.gnuradio.org/index.php/UbuntuInstall#Bionic_Beaver_.2818.04.29
#http://blog.reds.ch/?p=43


FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

# SoapySDR
############
RUN apt-get update && \
    apt-get -y install git cmake g++ libpython-dev python-numpy swig # SoapySDR && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/pothosware/SoapySDR.git && \
    mkdir -p SoapySDR/build && \
    cd SoapySDR/build && \
    cmake .. && \
    make -j$(nproc) && \
    make install

# LimeSuite
###############

#install core library and build dependencies
#install hardware support dependencies
#install graphics dependencies
RUN apt-get update && \
    apt-get -y install git g++ cmake libsqlite3-dev && \
    apt-get -y install libi2c-dev libusb-1.0-0-dev && \
    apt-get -y install libwxgtk3.0-dev freeglut3-dev && \
    rm -rf /var/lib/apt/lists/*

RUN cd / && \
    git clone https://github.com/myriadrf/LimeSuite.git && \
    cd /LimeSuite/build/ && \
    cmake .. && \
    make -j$(nproc) && \
    make install


# VOLK
########
RUN apt-get update && \
    apt-get -y install python-mako python-six libboost-all-dev && \
    rm -rf /var/lib/apt/lists/*

RUN cd / && \
    git clone https://github.com/gnuradio/volk.git && \
    mkdir -p /volk/build && \
    cd /volk/build && \
    cmake  ..  && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    volk_profile

# pothos
##########
WORKDIR /
RUN git clone --recursive https://github.com/pothosware/PothosCore.git && \
    mkdir -p /PothosCore/build/ && \
    cd /PothosCore/build/ && \
    cmake ..  && \
    make -j$(nproc) && \
    make install

# GNURADIO
############
# from https://wiki.gnuradio.org/index.php/UbuntuInstall#Bionic_Beaver_.2818.04.29
RUN apt-get update && \
    apt-get install -y liblog4cpp5-dev liblog4cpp5v5 libgmp3-dev python3-click python3-click-plugins && \
    apt-get install -y g++ libboost-all-dev libgmp-dev swig python3-numpy python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev libcomedi-dev libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 liblog4cpp5-dev libzmq3-dev python3-yaml && \
# for GNU Radio Companion
   apt-get install -y python-numpy python-cheetah python-lxml python-gtk2 && \
# for WX GUI
   apt-get install -y python-wxgtk3.0 python-numpy && \
# for QT GUI
   apt-get install -y python-qt4 python-qwt5-qt4 libqt4-opengl-dev libqwt5-qt4-dev libfontconfig1-dev libxrender-dev libxi-dev && \
    rm -rf /var/lib/apt/lists/*


WORKDIR /
#RUN git clone  --recursive https://github.com/gnuradio/gnuradio.git -b maint-3.7
RUN git clone https://github.com/gnuradio/gnuradio.git -b maint-3.7 && \
    mkdir -p /gnuradio/build/ && \
    cd /gnuradio/build/ && \
    cmake -DENABLE_INTERNAL_VOLK=OFF -DCMAKE_BUILD_TYPE=Release ..  && \
    make -j$(nproc) && \
    make install

# RTL SDR
###########
WORKDIR /
RUN git clone https://github.com/osmocom/rtl-sdr.git && \
   mkdir -p /rtl-sdr/build/ && \
   cd /rtl-sdr/build/ && \
   cmake ..  && \
   make -j$(nproc) && \
   make install

# gr-osmosdr
#############
RUN apt-get update && \
    apt-get install -y python-cheetah && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN git clone https://git.osmocom.org/gr-osmosdr && \
    mkdir -p /gr-osmosdr/build/ && \
    cd  /gr-osmosdr/build/ && \
    cmake ..  && \
    make -j$(nproc) && \
    make install

# gr-limesdr
#############
WORKDIR /
RUN git clone https://github.com/myriadrf/gr-limesdr && \
    mkdir -p /gr-limesdr/build/ && \
    cd /gr-limesdr/build/ && \
    cmake ..  && \
    make -j$(nproc) && \
    make install && \
    ldconfig

# gqrx
#######
RUN apt-get update && \
    apt-get install -y qtbase5-dev libqt5svg5-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /
RUN git clone https://github.com/csete/gqrx.git && \
    mkdir -p /gqrx/build/ && \
    cd /gqrx/build/ && \
    cmake ..  && \
    make -j$(nproc) && \
    make install
