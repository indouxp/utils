#!/bin/sh
###############################################################################
#
# HTTP Proxy経由でsshが可能か
# cygwin上の~/.ssh/configに設定したプロキシの定義を使用し、sshでConoHaのVPSに
# 接続する。
#
DF='+%Y%m%d.%H%M%S'
NAME=${0##*/}
LOG_DIR=/cygdrive/w/docs/chk-httpProxy
#LOG_NAME=${NAME:?}.$(date '+%Y%m%d.%H%M%S').log
LOG_NAME=${NAME:?}.log
LOG_PATH=${LOG_DIR:?}/${LOG_NAME:?}
RESULT=${NAME:?}.result
RESULT_PATH=${LOG_DIR:?}/${RESULT:?}
TIMEOUT=5
PROMPT='indou@118-27-7-9:~$ '

###############################################################################
TARGET=118.27.7.9
CONFIG=~/.ssh/config

###############################################################################
echo "config:${CONFIG:?}" >> ${LOG_PATH:?}
cat ${CONFIG:?} |
awk -v target=${TARGET:?} '
BEGIN{
  output = 0;
}
{
  if ($0 ~ target) {
    output = 1;
  }
  if (output == 1) {
    sub(/#.*/, "");
    if (0 < NF) {
      print;
    }
  }
}
END{
}' >> ${LOG_PATH:?}
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "$(date ${DF:?}): cat ${CONFIG:?} fail." >> ${LOG_PATH:?}
  echo "$(date ${DF:?}): NG"            >> ${RESULT_PATH:?}
  exit 9
fi
echo "$(date ${DF:?}): cat done."              >> ${LOG_PATH:?}

expect -c "
  set timeout ${TIMEOUT:?}
  spawn env LC_ALL=C ssh indou@${TARGET:?}
  expect {
    \"Enter proxy authentication password for 20166038@obprx01.intra.hitachi.co.jp:\" {
      send \"${LDAP_PASSWORD:?}\n\"
      exp_continue
    }
    \"Are you sure you want to continue connecting (yes/no)?\" {
      send \"yes\n\"
      exp_continue
    }
    \"Enter passphrase for key '/home/20166038/.ssh/id_rsa_20166038@GUJPVP163197103':\" {
      send \"${PASSPHRASE:?}\n\"
      exp_continue
    }
    \"${PROMPT:?}\" {
      send \"echo \`hostname\`\n\"
    }
  }
  expect \"${PROMPT:?}\" {
    send \"exit\n\"
  }
  exit 0"                         >> ${LOG_PATH:?}
echo ""                           >> ${LOG_PATH:?}
if [ "${RC:?}" -ne "0" ]; then
  echo "$(date ${DF:?}): expect fail."  >> ${LOG_PATH:?}
  echo "$(date ${DF:?}): NG"            >> ${RESULT_PATH:?}
  exit 9
fi
echo "$(date ${DF:?}): expect done."    >> ${LOG_PATH:?}
echo "$(date ${DF:?}): OK"              >> ${RESULT_PATH:?}

###############################################################################
exit 0
