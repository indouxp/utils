#!/bin/sh
###############################################################################
# 引数で与えられたテーブルのinsert文を作成、
# 標準出力に、以下のように出力
# ex)
# SQL> desc tr_sche_settlement_temp
#  Name                                      Null?    Type
#  ----------------------------------------- -------- ----------------------------
#  SHOW_ID                                   NOT NULL VARCHAR2(12)
#  RECEIPT_CLASS                             NOT NULL NUMBER(2)
#  SCHE_NUM                                  NOT NULL NUMBER(2)
#  SETTLEMENT_FLAG                           NOT NULL VARCHAR2(4)
#  DATA_FLAG                                 NOT NULL NUMBER(1)
# 
#  $sql = sprintf("insert into %s", TABLE_NAME);
#  $sql.= "(show_id, receipt_class, sche_num, settlement_flag, data_flag)";
#  $sql.= "values (?, ?, ?, ?, ?)";
#  my $sth = $dbh->prepare($sql);
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
# desc取得し、その出力をパイプする
sqlplus -S /nolog <<EOT                     | tee -a debug |
  whenever sqlerror exit failure rollback
  connect ${UP:?}
  set heading off
  desc ${TAB:?}
  exit 0
EOT
awk '
  BEGIN{
    printf("  %ssql = sprintf(\"insert into %%s\", TABLE_NAME);\n", "\044");
    printf("  %ssql .= \"(", "\044");
    first_field = 1;
    fields = 0;
  }
  {
    if (NF > 0 && NR > 2) { # 1行目はタイトル、二行目は-----
      if (first_field == 1) {
        first_field = 0;
      } else {
        printf(", ");
      }
      printf("%s", tolower($1));
      fields++;
    }
  }
  END {
    printf(")\";\n");
    printf("  %ssql .= \"values (", "\044");
    for (i = 0; i < fields; i++) {
      if (i == 0) {
        printf("?");
      } else {
        printf(", ?");
      }
    }
    printf(")\";\n");
    printf("  my %ssth = %sdbh->prepare(%ssql);\n", "\044", "\044", "\044");
  }
'
