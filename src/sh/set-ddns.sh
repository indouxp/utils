#!/bin/sh
###############################################################################
#
# https://www.amulet.co.jp/shop-blog/?p=9050
# https://www.value-domain.com/ddns.php?action=howto
# get-wanSideAddress.sh.outを元に、dyn.value-domain.comにdomainとIPを登録する
#
# crontab設定
#0 * * * * /home/pi/utils/src/sh/get-wanSideAddress.sh
#5 * * * * /home/pi/utils/src/sh/set-ddns.sh
###############################################################################
NAME=${0##*/}
DF='+%Y%m%dT%H%M%S'
GIP=$(cat /tmp/get-wanSideAddress.sh.out)      # Global IP
PASSWORD=$(cat ~/dyn.value-domain.pass.txt)    # dyn.value-domainのパス
DOMAIN="indou.tokyo"
RESULT=/tmp/${0##*/}.result
OUTPUT=/tmp/${0##*/}.output
LOG=/tmp/${0##*/}.log
#DNS=ns11.value-domain.com
MAIL_SERVER="mx1.indou.tokyo"

cp /dev/null ${LOG:?}

###############################################################################
# wgetで、dyn.value-domain.comにアクセスし、IPをドメインに登録する
###############################################################################
echo "$(date ${DF:?}): wget 開始" >> ${LOG:?}

URL="http://dyn.value-domain.com/cgi-bin/dyn.fcg?d=${DOMAIN:?}&p=${PASSWORD:?}&h=*&i=${GIP:?}"
wget $URL -o ${RESULT:?} -O ${OUTPUT:?}
RC=$?

if [ "${RC:?}" -ne "0" ]; then
  echo "${NAME:?}: wget fail." | tee -a ${LOG:?}
else
  ###############################################################################
  # 200 OKを取得
  ###############################################################################
  echo "$(date ${DF:?}): grep ${RESULT:?} 開始" >> ${LOG:?}

  if ! grep "応答を待っています... 200 OK" ${RESULT:?} > /dev/null; then
    echo "${NAME:?}: grep ${RESULT:?} fail." >> ${LOG:?}
  fi

  echo "$(date ${DF:?}): grep ${RESULT:?} 終了" >> ${LOG:?}
  
  ###############################################################################
  # status=0を取得
  ###############################################################################
  echo "$(date ${DF:?}): grep ${OUTPUT:?} 開始" >> ${LOG:?}

  if ! grep "status=0" ${OUTPUT:?} > /dev/null; then
    echo "${NAME:?}: grep ${OUTPUT:?} fail. " >> ${LOG:?}
    cat ${OUTPUT:?} >> ${LOG:?}; echo "" >> ${LOG:?}        
  fi

  echo "$(date ${DF:?}): grep ${OUTPUT:?} 終了" >> ${LOG:?}
fi
echo "$(date ${DF:?}): wget 終了" >> ${LOG:?}

###############################################################################
# nslookupで確認
###############################################################################
echo "$(date ${DF:?}): nslookup 開始" >> ${LOG:?}
if nslookup ${MAIL_SERVER:?} ${DNS} | grep -E "(Name:|Address: [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)" >> ${LOG:?}; then
  echo "$(date ${DF:?}): nslookup 成功" >> ${LOG:?}
  exit 0
else
  echo "$(date ${DF:?}): nslookup 失敗" >> ${LOG:?}
  exit 9
fi
