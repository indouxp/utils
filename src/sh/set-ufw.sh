#!/bin/sh
sudo ufw status
sudo ufw disable

sudo ufw default deny
sudo ufw allow proto tcp from 192.168.0.0/24 to any port 22
sudo ufw allow proto tcp from 192.168.0.0/24 to any port 80

sudo ufw enable

sudo ufw status
