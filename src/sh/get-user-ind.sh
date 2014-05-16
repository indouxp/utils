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
  column data_type format a10
  column data_length format 990
  clear breaks
  break on table_name on index_name on uniqueness
  select
    t1.TABLE_NAME TABLE_NAME,
    t1.INDEX_NAME INDEX_NAME,
    t1.UNIQUENESS UNIQUENESS,
    t2.COLUMN_NAME,
    t3.DATA_TYPE,
    t3.DATA_LENGTH
  from
    USER_INDEXES t1,
    USER_IND_COLUMNS t2,
    USER_TAB_COLUMNS t3
  where
    t1.TABLE_NAME = t2.TABLE_NAME
  and
    t1.INDEX_NAME = t2.INDEX_NAME
  and
    t1.TABLE_NAME = UPPER('${TAB:?}')
  and
    t1.TABLE_NAME = t3.TABLE_NAME
  and
    t2.COLUMN_NAME = t3.COLUMN_NAME
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
