#!bin/sh

# migrate docker symbolic
sudo cp -rp /var/lib/docker /mnt/sdb/
sudo ln -s /mnt/sdb/docker /var/lib/docker

#reload
sudo systemctl daemon-reload
sudo systemctl start docker
