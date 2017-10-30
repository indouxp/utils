#!/bin/sh
###############################################################################
#
# VirtualBox 全vmkのリスト
#
###############################################################################


VBoxManage list vms |
  awk '{print $1;}' |
  while read line
  do
    NAME=`echo $line |sed 's/"//g'`
    VBoxManage showvminfo $NAME
  done
