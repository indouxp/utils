#!/bin/sh
SCRIPT=`basename $0`
LOG=/tmp/${SCRIPT:?}.`date '+%Y%m%d.%H%M%S'`.log

# 引数が0の場合
if [ "$#" -eq "0" ]; then
  echo "${SCRIPT:?} COMMAND-FILE [FILES_FILE-FILE]" 1>&2
  exit 1
fi

date '+%Y/%m/%d_%H:%M:%S' > ${LOG:?}

# 定義されたファイルに記載されているコマンドを実行する
COMMAND_FILE=$1
while read comment cmd
do
  LEADING=`echo ${comment} | cut -c1`
  
  if [ "${comment}" != "" -a "${LEADING}" != "#" -a "${cmd}" != "" ]; then
    banner ${comment:?}     >> ${LOG:?}
    echo ${cmd:?}           >> ${LOG:?}
    ${cmd:?}                >> ${LOG:?}
    RC=$?
    if [ "${RC:?}" -eq "0" ]; then
      echo ${cmd} done      >> ${LOG:?}
    else
      echo ${cmd} fail      >> ${LOG:?}
    fi
    echo ""                 >> ${LOG:?}
  fi
done < ${COMMAND_FILE:?}

[ "$#" -eq "1" ] && exit 0

banner files >> ${LOG:?}

# 定義されたファイルに記載されているファイルを出力する
FILES_FILE=$2
while read file
do
  LEADING=`echo ${file} | cut -c1`
  if [ "${file}" != "" -a "${LEADING}" != "#" ]; then
    echo ${file:?}          >> ${LOG:?}
    cat ${file:?}           >> ${LOG:?}
    echo ""                 >> ${LOG:?}
  fi
done < ${FILES_FILE:?}

[ "$#" -eq "2" ] && exit 0

exit 0
