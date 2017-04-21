#!/bin/sh
SCRIPT=${0##*/}
TMP=/tmp/${SCRIPT:?}.$$.tmp
LOG=/tmp/${SCRIPT:?}.$$.log
MAILTO=indou.tsystem@docomo.ne.jp

TERM() {
  rm -f /tmp/${0##*/}.$$.*
}

trap 'TERM' 0

LF=$(printf '\\\012_');LF=${LF%_}
USER="adm"                                    # 管理者
PASS="defleppard"                             # password
URL="http://192.168.0.1/index.cgi/info_main"  # lan側からルーターの管理画面にアクセス
OUT=/home/pi/tmp/${SCRIPT:?}.out
ORG=/home/pi/tmp/${SCRIPT:?}.org

wget --http-user=${USER:?} --http-password=${PASS:?} -O ${OUT:?} ${URL:?} > ${LOG:?} 2>&1
RC=$?

if [ "${RC:?}" -ne "0" ]; then
  cat ${LOG:?} | mail -s "WAN ADDRESS wget fail. RC:${RC:?}." ${MAILTO:?}
  exit 1
fi

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
  cat ${TMP:?} | mail -s "WAN ADDRESS address infomation." ${MAILTO:?}
else
  if ! diff ${ORG:?} ${OUT:?}; then
    cat ${TMP:?} | mail -s "WAN ADDRESS address is changed." ${MAILTO:?}
    mv ${OUT:?} ${ORG:?}
  fi
fi
exit 0
