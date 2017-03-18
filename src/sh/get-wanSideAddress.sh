#!/bin/sh
SCRIPT=${0##*/}
TMP=/tmp/${SCRIPT:?}.$$

TERM() {
  rm -f /tmp/${0##*/}.$$
}

trap 'TERM' 0

LF=$(printf '\\\012_');LF=${LF%_}
USER="adm"
PASS="defleppard"
URL="http://192.168.0.1/index.cgi/info_main"
OUT=/home/pi/tmp/${SCRIPT:?}.out
ORG=/home/pi/tmp/${SCRIPT:?}.org

wget --http-user=${USER:?} --http-password=${PASS:?} -O ${OUT:?} ${URL:?}

cat ${OUT:?}                    | # 必要な区間の行(<table>～</table>を抽出
sed -n '/<table/,/<\/table>/p'  | # 一旦改行コードを全部取り去ってしまう
tr -d '\n'                      |
sed 's#<td#'"${LF:?}"'<td#g'    |
iconv -f EUC-JP -t UTF-8        | # htmlは、euc
awk '
BEGIN{
  target = 0;
  row = 0;
}
{
  if (row != 0 && row == NR) {
    printf("%s\n", $0);
  }
  if (target == 1) {
    if ($0 ~ /IPアドレス／ネットマスク/) {
      row = NR + 1;
    }
  }
  if ($0 ~ /<h2>WAN側状態/) {
    target = 1;
  }
}
END{
}'                                    |
sed "s#<td class='small_item_td2'>##" |
sed 's#</td>.*##'                     > ${TMP:?} 

if [ ! -e ${ORG:?} ]; then
  mv ${OUT:?} ${ORG:?}
  cat ${TMP:?} | mail -s "WAN ADDRESS" indou.tsystem@docomo.ne.jp
else
  if ! diff ${ORG:?} ${OUT:?}; then
    cat ${TMP:?} | mail -s "WAN ADDRESS" indou.tsystem@docomo.ne.jp
    mv ${OUT:?} ${ORG:?}
  fi
fi
