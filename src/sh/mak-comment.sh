#!/bin/sh
# TABLE <- FILEのコメントを作成する
set -e

SCRIPT=`basename $0`
term() {
  rm -f /tmp/`basename $0`.$$.*
}
trap 'term' 0

if [ "$#" -ne "2" ]; then
  cat <<EOT
  \$ ${SCRIPT:?} USER/PASS perlscript
EOT
  exit 1
fi

UP=$1
PERLSCRIPT=$2


LF=$(printf '\\\012_');LF=${LF%_}

sed 's/#.*$//' ${PERLSCRIPT:?}    |
  tr -d '\012'                    |
  sed 's/;/;'"$LF"'/g'            |
  sed 's/}/}'"$LF"'/g'            |
  sed 's/^  *//'                  > /tmp/${SCRIPT:?}.$$.tmp

grep 'DATA_FILE_NAME' /tmp/${SCRIPT:?}.$$.tmp |
  awk '$2 ~ /DATA_FILE_NAME/ {print $3;}'     |
  sed 's/"//g;s/[{}]//g;s/;//g'               > /tmp/${SCRIPT:?}.$$.data_file_name

grep 'TABLE_NAME' /tmp/${SCRIPT:?}.$$.tmp |
  awk '$2 ~ /TABLE_NAME/ {print $3;}'     |
  sed 's/"//g;s/[{}]//g;s/;//g'           > /tmp/${SCRIPT:?}.$$.table_name

DATA_FILE_NAME=`cat /tmp/${SCRIPT:?}.$$.data_file_name`
TABLE_NAME=`cat /tmp/${SCRIPT:?}.$$.table_name`

sqlplus -S /nolog <<EOT         |
connect ${UP}
desc ${TABLE_NAME:?}
exit 0
EOT
awk '
{
  if (2 < NR) {
    printf("%-30s %s\n", $1, $NF);
  }
}'                              > /tmp/${SCRIPT:?}.$$.desc


grep -E 'execute'  /tmp/${SCRIPT:?}.$$.tmp  | # executeするときのフィールドを取得
  sed 's/.*execute(//'                      |
  sed 's/);//'                              |
  sed 's/\$//g'                             |
  sed 's/  *//g'                            |
  sed 's/,/'"$LF"'/g'                       > /tmp/${SCRIPT:?}.$$.from 


awk '
BEGIN{
  chk = 0;
}
{
  if ($3 ~ "values") {
    chk = 0;
  }
  if (chk == 1) {
    print;
  }
  if ($3 == "sprintf(\"insert") {
    chk = 1;
  }
}' /tmp/${SCRIPT:?}.$$.tmp      | # insert into TABLEのフィールドを取得
  sed 's/\$sql *.=//'           |
  sed 's/"//g'                  |
  sed 's/(//'                   |
  sed 's/)//'                   |
  sed 's/;//'                   |
  sed 's/,/'"$LF"'/g'           |
  sed 's/  *//g'                |
  awk 'NF>0'                    > /tmp/${SCRIPT:?}.$$.to


for field in `cat /tmp/${SCRIPT:?}.$$.to`
do
  awk -v field=${field:?} '
  {
    if ($1 == toupper(field)) {
      printf("%-15s %-15s <-\n", field, $NF);
      exit 0;
    }
  }' /tmp/${SCRIPT:?}.$$.desc
done > /tmp/${SCRIPT:?}.$$.1

for field in `cat /tmp/${SCRIPT:?}.$$.from`
do
  awk -v field=${field:?} '
  BEGIN{
    ok = 0;
  }
  {
    if (ok == 0 && $1 == field) {
      printf("%-15s\n", $NF);
      ok = 1;
    }
  }
  END{
    if (ok == 0) {
      printf("[%-15s]\n", field);
    }
  }' fields.txt
done  > /tmp/${SCRIPT:?}.$$.2

for field in `cat /tmp/${SCRIPT:?}.$$.2`
do
  awk -v field=${field:?} '
  BEGIN{
    ok = 0;
  }
  {
    if (ok == 0 && $1 == field) {
      printf("%s(%d)\n", $2, $3);
      ok = 1;
    }
  }
  END{
    if (ok == 0) {
      printf("[%s]\n", field);
    }
  }' ${DATA_FILE_NAME:?}.txt
done  > /tmp/${SCRIPT:?}.$$.3

paste  /tmp/${SCRIPT:?}.$$.1  /tmp/${SCRIPT:?}.$$.2 /tmp/${SCRIPT:?}.$$.3 | sed "s/^/# /"
