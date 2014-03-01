#!/bin/sh
#
# EXPLANATION:テキストファイルの表示(マルチバイト文字には未対応)
#
SCRIPT=`basename $0`
GET_MAX_COLUMNS=/tmp/${SCRIPT:?}.get_max_columns.awk.$$
CAT=/tmp/${SCRIPT:?}.cat.awk.$$

term() {
  rm /tmp/${SCRIPT:?}.*.awk.$$
}

trap 'term' 0

cat <<EOT > ${GET_MAX_COLUMNS:?}
BEGIN {
  max=0;
}
{
  colsize = length(\$0);
  if (max < colsize) {
    max = colsize;
  }
}
END {
  printf("%d\n", max);
}
EOT

cat <<EOT > ${CAT:?}
BEGIN{
  for (i = 0; i < (max_cols + 4); i++) {
    printf("*");
  }
  printf("\n");
}
{
  printf("* ");
  printf("%s", \$0);
  for (i = 0; i < max_cols - length(\$0); i++) {
    printf(" ");
  }
  printf(" *");
  printf("\n");
}
END{
  for (i = 0; i < (max_cols + 4); i++) {
    printf("*");
  }
  printf("\n");
}
EOT

for file in $*
do
  MAX_COLS=`awk -f ${GET_MAX_COLUMNS:?} ${file:?}`
  if [ -e ${file:?} ]; then
    ls -li ${file:?}
    awk -v max_cols=${MAX_COLS} -f ${CAT:?} ${file:?}
  fi
done
exit 0
