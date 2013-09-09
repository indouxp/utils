#!/bin/sh
# 引数で与えられたファイルを、スクリプト化して実行する。
#
#
SELF=`basename $0`
if [ $# -eq "0" ]; then
  cat <<EOT
Usage
\$ ./${SELF:?} FILE [...]
EOT
  exit 1
fi

term() {
  rm -f /tmp/${SELF:?}.*.sh
}

trap 'term' 0

main() {
  FILE=`basename $1`
  awk '
    function hline(n) {
      for (i = 0; i < n; i++) {
        printf("#");
      }
      printf("\n");
    }
    BEGIN{
      time = sprintf("`date %c+%%Y%%m%%d.%%H%%M%%S%c`", 39, 39);
      printf("#!/bin/sh\n");
    }
    {
      hline(79);
      printf("echo \"%s\"\n", $0);
      printf("%s\n", $0);
      printf("if [ \"$?\" -ne \"0\" ]; then\n");
      printf("  echo \"%s:%s:fail.\" 1>&2\n", time, $0);
      printf("  exit 1\n");
      printf("fi\n");
      printf("echo \"%s:%s:done.\"\n", time, $0, logfile);
    }
    END{
      printf("exit 0\n");
    }
  ' $1 > /tmp/${SELF:?}.${FILE:?}.sh
  if [ "$?" -ne "0" ]; then
    echo "main-awk $1 fail." 1>&2
    exit 1
  fi

  chmod u+x /tmp/${SELF:?}.${FILE:?}.sh
  cat /tmp/${SELF:?}.${FILE:?}.sh >   /tmp/${SELF:?}.${FILE:?}.log
  /tmp/${SELF:?}.${FILE:?}.sh     >>  /tmp/${SELF:?}.${FILE:?}.log 2>&1
  return $?
}

for FILE in $*
do
  main ${FILE:?}
  if [ "$?" -ne "0" ]; then
    echo "main ${FILE:?} fail." 1>&2 
    exit 1
  fi
done
exit 0
