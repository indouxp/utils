#!/bin/sh
DIR=${0%/*}

echo "現在、$(date '+%H時 %M分' | sed 's/0//g' ) です" | $DIR/talk.sh
