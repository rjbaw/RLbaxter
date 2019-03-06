#!/bin/sh

sudo rm /mnt/sda/swapfile
sudo bash createSwapfile.sh -d /mnt/sda -s 8

#sudo rm /media/nvidia/KingstonSSD/swapfile
#sudo bash createSwapfile.sh -d /media/nvidia/KingstonSSD -s 8
