#!/bin/sh
###############################################################################
#
# ubunt$B$X$N(Bansible$B%$%s%9%H!<%k(B
#
###############################################################################

set -Ceu
sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
