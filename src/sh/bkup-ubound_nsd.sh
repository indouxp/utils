#!/bin/sh
NAME=${0##*/}

echo "${NAME:?}: su - "

CMD="su - root -c 'cd /etc; tar cvzf /tmp/unbound_nsd.tar.gz ./unbound/unbound.conf ./nsd/nsd.conf ./nsd/zones'"
echo $CMD
eval $CMD
