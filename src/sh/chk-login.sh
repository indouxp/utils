#!/bin/sh
###############################################################################
#
# sudo もしくは、rootで実行する
#
###############################################################################
SCRIPT=${0##*/}
MAIL=indou.tsystem@docomo.ne.jp
MASTER=/var/log/${SCRIPT:?}.master
NOW=/var/log/${SCRIPT:?}.now
TMP=/tmp/${SCRIPT:?}.tmp
# last
# -a:ホスト名を最後の欄に表示する。
# -d:IP アドレスをホスト名に変換し直して表示する。
last -a -d |	
awk '
	BEGIN{
	}
	{
    if ($1 == "reboot") {
			next;
		}
		if ($NF ~ /192\.168\./) {
			next;
		}
		if ($NF ~ /tsystem\.gr\.jp/) {
			next;
		}
		if ($NF ~ /0\.0\.0\.0/) {
			next;
		}
		print;
	}
	END{
	}' > ${NOW:?}
RC=$?
[ ${RC:?} -ne 0 ] && exit 9

touch ${MASTER:?}
diff ${MASTER:?} ${NOW:?} | head -2 | tail -1 > ${TMP:?}
RC=$?
[ ${RC:?} -ne 0 ] && exit 9

if [ -s ${TMP:?} ]; then
  cat ${TMP:?} | mail -s "Invasion information" ${MAIL:?}
fi

mv ${NOW:?} ${MASTER:?}
exit 0
