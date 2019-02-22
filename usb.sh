#!/bin/sh
sudo umount /dev/sda
sudo umount /dev/sdb1
sudo umount /mnt/sdb
sudo umount /mnt/sda
sudo mount -t ext4 -o rw /dev/sda /mnt/sdb
sudo mount -t ext4 -o rw /dev/sdb1 /mnt/sda
#sudo chown -R nvidia /mnt/sdb
sudo chown -R nvidia /mnt/sda

sudo rm /mnt/sda/swapfile
sudo ./createSwapfile.sh -d /mnt/sda -s 55
#sudo ln -s /mnt/sdb ~/usb
#sudo ln -s /mnt/sda ~/usb1
# sudo umount /mnt/sdb

#ln -s /mnt/sdb/RLbaxter ~/RLbaxter
sudo systemctl daemon-reload
sudo systemctl start docker
