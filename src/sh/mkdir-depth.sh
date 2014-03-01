#!/bin/sh
#
# EXPLANATION:引数で与えられた深さのディレクトリを作成
#
# indou@vipi7920p6t ~/tmp
# $ mkdir-depths.sh 4
# 
# indou@vipi7920p6t ~/tmp
# $ ls -l
# 合計 0
# drwxr-xr-x+ 1 indou None 0 3月   1 17:28 dir.0.000.d
# 
# indou@vipi7920p6t ~/tmp
# $ find dir.0.000.d/
# dir.0.000.d/
# dir.0.000.d/dir.1.000.d
# dir.0.000.d/dir.1.000.d/dir.2.000.d
# dir.0.000.d/dir.1.000.d/dir.2.000.d/dir.3.000.d
# 
# indou@vipi7920p6t ~/tmp
# $ 
# 
SCRIPT=`basename $0`
if [ "$#" -eq "0" ]; then
  cat <<EOT 1>&2
Usage
\$ `basename $0` n
  n:depth
EOT
  exit 1
fi

depth=$1
first=000
prefix="dir"
for i in `awk -v depth=${depth:?} 'BEGIN{for (i = 0; i < (depth + 0); i++) {print i;}}'`
do
  if mkdir ${prefix:?}.${i:?}.${first:?}.d; then
    cd     ${prefix:?}.${i:?}.${first:?}.d
  else
    echo "${SCRIPT:?}: fail." 1>&2
    exit 1
  fi
done

