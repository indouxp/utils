#!/bin/sh
name=`basename $0`

size=0
echo -n "${name:?}:size:"
read size
size=`echo "${size:?} + 0" | bc`
rc=$?
if [ "${rc:?}" -ne "0" ]; then
  exit 1
fi

min=0
echo -n "${name:?}:min:"
read min
min=`echo "${min:?} + 0" | bc`
rc=$?
if [ "${rc:?}" -ne "0" ]; then
  exit 1
fi

sec=0
echo -n "${name:?}:sec:"
read sec
sec=`echo "${sec:?} + 0" | bc`
rc=$?
if [ "${rc:?}" -ne "0" ]; then
  exit 1
fi


echo "file size:${size:?} byte"
echo "time     :${min:?} min ${sec:?} sec"
echo "(${size:?}/(${min:?}*60+${sec:?}))*8/1024/1024 Mbps"
echo "`echo "scale=2; (${size:?}/(${min:?}*60+${sec:?}))*8/1024/1024" | bc` Mbps"
