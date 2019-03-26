#!/bin/sh
###############################################################################
#
# 直近n分より後に更新のあったファイル一覧
#
#   https://qiita.com/shnchr/items/031dc8e5504ed2d7c7e0
###############################################################################

min=$1

sudo find / -mmin -${min:?} -print 2> /dev/null                               |
  egrep -v "/(proc|dev|run|sys|var/log|var/tmp|var/lib/monitorix/www/imgs/)"  |
  sort                                                                        |
  while read line
  do
    sudo ls -ld ${line:?}
  done

