#!/bin/sh
DIR=${0%/*}

echo "現在、$(date '+%H時%M分') です" | $DIR/talk.sh
