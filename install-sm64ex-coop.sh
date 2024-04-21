#!/bin/bash

# req:
# 1. git clone https://github.com/djoslin0/sm64ex-coop $HOME/sm64ex-coop
# 2. copy your orginal SM64 ROM inside $HOME/sm64ex-coop (baserom.us.z64)
# 3. run this script

# Installing SM64Ex-Coop Server
# For some reason I was not able to dockerize it :(

# install build dependecies + Xvfb
echo "Updating Ubuntu Server . . ."
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential python3 libglew-dev libsdl2-dev libz-dev 
sudo apt install -y binutils-mips-linux-gnu bsdmainutils libcapstone-dev pkgconf
sudo apt install -y xvfb dbus-x11 x11-utils alsa-utils mesa-utils libgl1-mesa-dri


if [ ! -e $HOME/sm64ex-coop ]; then echo "Pls clone sm64ex-coop repo in $HOME ..."; exit 1; fi
if [ ! -e $HOME/sm64ex-coop/baserom.us.z64 ]; then echo "Pls copy ROM in $HOME/sm64ex-coop ..."; exit 1; fi


echo "Building SM64Ex Coop . . ."
cd $HOME/sm64ex-coop
make -j4


echo "Installing SM64Ex Coop . . ."
mkdir -p /opt/sm64/config
sudo mv $HOME/sm64ex-coop/build/us_pc/* /opt/sm64

sudo cp src/services/sm64.service /etc/systemd/system/sm64.service
sudo cp src/services/sm64-xvfb.service /etc/systemd/system/sm64-xvfb.service

sudo systemctl enable --now sm64-xvfb.service
sudo systemctl enable --now sm64.service

