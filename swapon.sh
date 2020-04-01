#!/bin/bash
swapon -s
if [[ $(swapon -s) ]]; then
    echo "swap is OK"
else
    echo "no swap found. Creating swap..."
    sudo touch /var/swap.img
    sudo chmod 600 /var/swap.img
    sudo dd if=/dev/zero of=/var/swap.img bs=2048 count=1000
    sudo mkswap /var/swap.img
    sudo swapon /var/swap.img
    echo "/var/swap.img    none    swap    sw    0    0" >> /etc/fstab
    free
    echo "swap is now OK"
fi