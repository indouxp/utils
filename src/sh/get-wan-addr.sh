#!/bin/sh
###############################################################################
#
#
###############################################################################
NAME=`basename $0`
USERID="adm"
PASSWD="defleppard"
TMPFILE=/tmp/${NAME:?}.tmp

if wget                           \
    --http-user=${USERID:?}       \
    --http-password=${PASSWD:?}   \
    --output-document=${TMPFILE:?}\
    http://192.168.0.1/index.cgi/info_main > /dev/null 2>&1
then
  nkf -w ${TMPFILE:?}                                                             |\
    grep "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\/[0-9]\{1,2\}"   |\
    grep -v "192\.168\.0."                                                        |\
    sed "s%<td class='small_item_td2'>\([^/][^/]*\)/\([^/][^/]*\)</td>%\1%"
else
  echo "${NAME:?}: wget fail." 1>&2
  exit 1
fi
exit 0

