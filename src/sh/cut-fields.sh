#!/bin/sh
###############################################################################
# 第一引数の定義ファイルを読み込み、レイアウト通りに第二引数以降のファイルを
# 出力
#
SCRIPT=`basename $0`

term() {
  rm -f /tmp/${SCRIPT:?}.$$.sh
}

trap 'term' 0

usage() {
cat <<EOT 1>&2
  Usage
  \$ ${SCRIPT:?} CONF FILE [...]
  ex)
  \$ cat conf.txt
  区分  CHAR  1
  名称  CHAR  10
  日付  NUMBER  8
  \$ ${SCRIPT:?} conf.txt file.txt
  区分:CHAR(1) cut -b1-1
  0
  名称:CHAR(10) cut -b2-11
  名称
  日付:NUMBER(8) cut -b12-19
  20140521
  \$
EOT
}
if [ "$#" -eq "0" ]; then
  usage
  exit 1
fi
CONF=$1
shift

awk '
BEGIN{
  start = 1;
}
{
  if (NF>0) {
    name = $1;
    attribute = $2;
    size = $3;
    printf("echo \"%s:%s(%d)\" \"cut -b%d-%d\"\n", name, attribute, size, start, start + size -1);
    printf("LANG=ja_JP.SJIS cat %s1 | cut -b%d-%d | nkf -w \n", "\044", start, start + size -1);
    start += size;
  }
}
END{
}
' ${CONF:?} > /tmp/${SCRIPT:?}.$$.sh

for file in $@
do
  sh /tmp/${SCRIPT:?}.$$.sh $file
done
#cat /tmp/${SCRIPT:?}.$$.sh

exit 0


