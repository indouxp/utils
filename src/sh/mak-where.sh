#!/bin/sh
###############################################################################
# 引数で与えられたテーブルのWHERE文を、USER_INDEXES、USER_IND_COLUMNS等から
# 作成し、標準出力に出力する。
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
sqlplus -S /nolog <<EOT |
  whenever sqlerror exit failure rollback
  connect ${UP:?}
  set linesize 150
  set heading off
  set tab off
  set feed off
  column table_name     format a30
  column column_name    format a30
  column data_type      format a10
  column data_length    format 9990
  column data_precision format 9990
  select
    t1.TABLE_NAME     TABLE_NAME,
    t2.COLUMN_NAME    COLUMN_NAME,
    t3.DATA_TYPE      DATA_TYPE,
    t3.DATA_LENGTH    DATA_LENGTH,
    t3.DATA_PRECISION DATA_PRECISION  -- NUMBERデータ型の10進精度
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
  and
    t1.UNIQUENESS = 'UNIQUE'
  order by
    t1.TABLE_NAME,
    t1.INDEX_NAME,
    t2.COLUMN_POSITION
  ;
exit 0
EOT
awk '
function blanks(n) {
  for (j = 0; j < n; j++) {
    printf(" ");
  }
}
BEGIN{
  row = 0;
  max_length = 0;
}
{
  if (NF == 0) {
    next;;
  }
  TAB=$1;
  row++;
  columns[row] = $2;
  if (max_length < length($2)) {
    max_length = length($2);
  }
  if ($3 ~ /NUMBER/) {
    comments[row] = sprintf("%s(%d)", $3, $5);
  } else {
    comments[row] = sprintf("%s(%d)", $3, $4);
  }
}
END{
  printf("WHERE \n");
  for (i = 1; i <= row; i++) {
    printf("  %s = ", columns[i]);
    if (comments[i] ~ /CHAR/) {
      printf("%c?%c", 0x27, 0x27);
    } else {
      printf("?  ");
    }
    blanks(max_length - length(columns[i]));
    printf(" --%s\n", comments[i]);
    if (i != row) {
      printf("and\n");
    }
  }
  printf(";\n");
}
'
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "fail." 1>&2
  exit 1
fi
