#!/bin/sh
###############################################################################
# 引数で与えられたテーブルのキーを表示
#
###############################################################################
# 引数
if [ "2" -ne "$#" ]; then
  cat <<EOT 1>&2
\$ `basename $0` USER/PASS TABLE
EOT
  exit 1
fi
UP=$1
TAB=$2

###############################################################################
# sqlplus
sqlplus -S /nolog <<EOT
  whenever sqlerror exit failure rollback
  connect ${UP:?}
  set linesize 150
  column table_name format a30
  column index_name format a30
  column uniqueness format a10
  column column_name format a30
  select
    t1.TABLE_NAME,
    t1.INDEX_NAME,
    t1.UNIQUENESS,
    t2.COLUMN_NAME
  from
    USER_INDEXES t1,
    USER_IND_COLUMNS t2
  where
    t1.TABLE_NAME = t2.TABLE_NAME
  and
    t1.INDEX_NAME = t2.INDEX_NAME
  and
    t1.TABLE_NAME = UPPER('${TAB:?}')
  order by
    t1.TABLE_NAME,
    t1.INDEX_NAME,
    t2.COLUMN_POSITION
  ;
exit 0
EOT
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "fail." 1>&2
  exit 1
fi
