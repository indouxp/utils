#!/bin/sh
sudo ufw status
sudo ufw disable

sudo ufw default deny
sudo ufw allow 22
sudo ufw allow 5900
sudo ufw allow 137
sudo ufw allow 138
sudo ufw allow 139
sudo ufw allow 445

sudo ufw enable

sudo ufw status
