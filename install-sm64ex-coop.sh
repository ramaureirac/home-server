#!/bin/bash

# req:
# 1. git clone https://github.com/djoslin0/sm64ex-coop $HOME/sm64ex-coop
# 2. copy your orginal SM64 ROM inside $HOME/sm64ex-coop (baserom.us.z64)
# 3. run this script


if [ ! -e $HOME/sm64ex-coop ]; then echo "Pls clone sm64ex-coop repo in $HOME ..."; exit 1; fi
if [ ! -e $HOME/sm64ex-coop/baserom.us.z64 ]; then echo "Pls copy ROM in $HOME/sm64ex-coop ..."; exit 1; fi


read -p "This script will build and install SM64EX-COOP server inside /opt. Continue? (y/n) : " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then exit 0; fi


### BUILD SM64EX COOP --------------------------
if [ ! -e $HOME/sm64ex-coop/build ]; then
    read -p "Install Build Dependencies? (y/n) : " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo apt update && sudo apt upgrade -y
        sudo apt install -y build-essential python3 libglew-dev libsdl2-dev libz-dev 
        sudo apt install -y binutils-mips-linux-gnu bsdmainutils libcapstone-dev pkgconf
        sudo apt install -y xvfb dbus-x11 x11-utils alsa-utils mesa-utils libgl1-mesa-dri
    fi
    echo "Building SM64EX COOP Server"
    cd $HOME/sm64ex-coop
    make -j4
fi


### INSTALL SM64EX COOP --------------------------
echo "Installing SM64EX COOP Server"
sudo mkdir -p /opt/sm64/config
sudo mv $HOME/sm64ex-coop/build/us_pc/* /opt/sm64/

sudo cp src/services/sm64.service /etc/systemd/system/sm64.service
sudo cp src/services/sm64-xvfb.service /etc/systemd/system/sm64-xvfb.service

sudo systemctl enable --now sm64-xvfb.service
sudo systemctl enable --now sm64.service

