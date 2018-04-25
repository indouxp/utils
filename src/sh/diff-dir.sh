#!/bin/sh
###############################################################################
# 第一引数のディレクトリと、第二引数のディレクトリ内の同名ファイルを比較する
###############################################################################
NAME=${0##*/}

DONE() {
  if [ "${MADE_BY_ME:=0}" = "1" ]; then
    rm -rf /tmp/${0##*/}.d
  fi
}

trap 'DONE' 0

ORG=$1
NEW=$2
TMPD=/tmp/${0##*/}.d

if ! mkdir ${TMPD:?}; then
  echo "${TMPD:?} exist" 1>&2
  exit 1
fi
MADE_BY_ME=1

set -eu

# ORG、NEW、どちらかに存在するファイル一覧を取得
find ${ORG:?} -type f | sed "s#${ORG:?}##" > ${TMPD:?}/org-list
find ${NEW:?} -type f | sed "s#${NEW:?}##" > ${TMPD:?}/new-list
sort -u ${TMPD:?}/org-list ${TMPD:?}/new-list > ${TMPD:?}/list

cat ${TMPD:?}/list |
while read LINE
do
  set +e
  CMD="diff -w ${ORG:?}/${LINE:?} ${NEW:?}/${LINE:?}"
  echo ${CMD:?}
  ${CMD:?}
  RC=$?
  echo "STATUS:${RC:?}"
done

exit 0
