#!/bin/sh
###############################################################################
# REFERENCE:http://make.bcde.jp/raspberry-pi/%E3%83%95%E3%82%A1%E3%82%A4%E3%83%A4%E3%83%BC%E3%82%A6%E3%82%A9%E3%83%BC%E3%83%AB%E3%81%AE%E8%A8%AD%E5%AE%9A/
#
###############################################################################

sudo ufw disable
sudo ufw reset
sudo ufw default deny
sudo ufw allow 22

echo "type \"sudo ufw enable\" and type \"sudo ufw status\""
