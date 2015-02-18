#!/bin/sh
###############################################################################
# ~/ダウンロード以下の、.3gpファイルを、/media/disk/PHOTOに、1sec毎にjpgに変換し
# 保存する。
#
set -e

cd ~/ダウンロード

for file in *.3gp
do
  Prefix=`echo $file | sed "s/\.3gp//"`
  echo -n "${Prefix:?}:"
  count=`ls -1 /media/disk/PHOTO/${Prefix:?}.* 2>/dev/null | wc -l`
  echo -n " ${count:?} "
  if [ "${count:?}" -eq "0" ]; then
    echo "do ${Prefix:?}"
    ffmpeg -i $file -f image2 -vf fps=1 ${Prefix:?}.%05d.jpg
    mv ${Prefix:?}.*.jpg /media/disk/PHOTO
  else
    echo "skip ${Prefix:?}"
  fi 
done
