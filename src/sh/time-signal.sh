#!/bin/sh
DIR=${0%/*}

echo "現在、$(date '+%H時' | sed 's/0\([0-9]\)/\1/g' ) です" | $DIR/talk.sh
