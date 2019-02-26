#!/bin/sh
NAME=${0##*/}

echo "${NAME:?}: do su !"

su - -c 'nohup /opt/gateone/gateone.py &'

