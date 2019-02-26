#!/bin/sh
NAME=${0##*/}

echo "do su !"

su - -c "nohup /opt/gateone/gateone.py &; echo $!"

