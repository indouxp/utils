#!/bin/sh
###############################################################################
# 引数で与えられたテーブルのSELECT文を作成、
# 出力:slt.テーブル名.sql、slt.テーブル名.sh
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
if [ -e slt.${TAB:?}.sh -o -e slt.${TAB:?}.sql ]; then
  echo "`basename $0`:slt.${TAB:?}.{sql,sh} exist." 1>&2
  exit 1
fi

###############################################################################
# desc取得し、その出力をパイプする
sqlplus -S /nolog <<EOT                     | tee desc.${TAB:?} |
  whenever sqlerror exit failure rollback
  connect ${UP:?}
  set heading off
  desc ${TAB:?}
  exit 0
EOT
awk -v table=${TAB:?} '
  BEGIN{
    field_no = 0;
    linesize = 0;
  }
  {
    if (3 <= NR && 0 < NF) {
      field = $1;
      attribute = $NF;
      #printf("%s:%s\n", field, attribute);
      if ($NF ~ /VARCHAR2/) {
        sub(/VARCHAR2\(/, "", attribute);
        sub(/\)/, "", attribute);
        columns[field_no] = sprintf("column %s format A%d", field, attribute);
        linesize += attribute;
      } else if ($NF ~ /NUMBER/) {
        sub(/NUMBER\(/, "", attribute);
        sub(/\)/, "", attribute);
        linesize += attribute;
        fmt = "";
        for (i = 0; i <= attribute; i++) {
          fmt = sprintf("%s9", fmt);
        }
        columns[field_no] = sprintf("column %s format %s", field, fmt);
      }
      fields[field_no++] = field;
    }
  }
  END{
      #printf("set linesize %d\n", linesize);
      printf("whenever sqlerror exit failure rollback\n");
      printf("alter session set nls_date_format = %sYYYY/MM/DD HH24:MI:SS%s;\n", "\047", "\047");
      printf("set tab off\n");
      for(i = 0; i < field_no; i++) {
        printf("%s\n", columns[i]);
      }
      printf("desc %s\n", table);
      printf("select\n");
      for(i = 0; i < field_no; i++) {
        printf("  %s", fields[i]);
        if (i == (field_no-1)) {
          printf("\n");
        } else {
          printf(",\n");
        }
      }
      printf("from\n");
      printf("  %s\n", table);
      printf(";\n");
      printf("exit 0\n");
  }
' > slt.${TAB:?}.sql
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  echo "fail." 1>&2
  exit 1
fi

cat <<EOT > slt.${TAB:?}.sh
#!/bin/sh
sqlplus -S ${UP:?} @\`dirname \$0\`/slt.${TAB:?}.sql
RC=\$?
if [ "\${RC:?}" -ne "0" ]; then
  echo "fail." 1>&2
  exit 1
fi
exit 0
EOT

grep -v "fail\." slt.${TAB:?}.sh > chk.${TAB:?}.sh

chmod a+x {slt,chk}.${TAB:?}.sh
exit 0
