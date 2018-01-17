#!/bin/bash
###############################################################################
#
# See http://unix.stackexchange.com/questions/101080/realpath-command-not-found
#     https://qiita.com/katoy/items/c0d9ff8aff59efa8fcbb
#
NAME=${0##*/}
USER=$1
HOST=$2
FILE=$3

MAIN() {
  if [ $# -eq 0 ]; then
    USAGE
    exit 1
  fi
  
  ORG=$(REALPATH $FILE)
  FILENAME=`echo $ORG | sed 's%/%@%g'`
  
  if scp -p ${USER:?}@${HOST:?}:${FILE:?} /tmp/$HOST:$FILENAME; then
    echo diff $(hostname):$ORG /tmp/$HOST:$FILENAME
    diff $ORG /tmp/$HOST:$FILENAME
  else
    echo "${NAME:?}:scp fail."
    exit 2
  fi
}

USAGE() {
  cat <<EOT
\$ $NAME USER HOST FILE
EOT
}

REALPATH () {
    f=$@;
    if [ -d "$f" ]; then
        base="";
        dir="$f";
    else
        base="/$(basename "$f")";
        dir=$(dirname "$f");
    fi;
    dir=$(cd "$dir" && /bin/pwd);
    echo "$dir$base"
}

MAIN $*
exit 0
