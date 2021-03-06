#!/bin/bash
###############################################################################
# デバイスの読み込み速度の測定
# 12回測定し、最小値と最大値を除く
# REFERENCE:http://d.hatena.ne.jp/tetsuyai/20111125/1322208311
# $Header:$
#
###############################################################################
NAME=`basename $0`

export LANG=C

USAGE() {
  cat <<EOT 1>&2
  Usage: ${NAME:?} -(t|T) FILESYSTEM
    -t:read device
    -T:read cache
EOT
}

if [ "$#" -ne "2" ]
then
  USAGE
  exit 1
fi
OPT=$1
DEV=$2
case ${OPT:?} in
"-t")
  CUT="12"
  ;;
"-T")
  CUT="11"
  ;;
*)
  USAGE
  exit 1
esac 

# It measures 12 times and displays a result.
for i in 0 1 2 3 4 5 6 7 8 9 10 11
do
    sleep 10

    _lines[$i]=`hdparm ${OPT:?} ${DEV:?}`
    echo [$i]  ${_lines[$i]}

    _speeds1[$i]=`echo ${_lines[$i]} | cut -d' ' -f${CUT:?}`
done

# A result is rearranged into an ascending order.
IFS=$'\n'
_speeds1=(`echo "${_speeds1[*]}" | sort`)

# The minimum and the maximum are excepted and average value is calculated.
_sum=0
for i in 1 2 3 4 5 6 7 8 9 10
do
    _speeds2[$i]=${_speeds1[$i]}
done
_avg=`echo "${_speeds2[*]}" | awk '{s+=$1}END{print s/10}'`

# Average value is displayed.
echo "AVG  $_avg MB/sec"
