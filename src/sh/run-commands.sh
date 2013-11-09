#!/bin/sh
###############################################################################
# 引数で与えられたファイルを、スクリプト化して実行する。
# 同一ファイルのパラレル実行に対応
#
#
###############################################################################
SELF=`basename $0`
if [ $# -eq "0" ]; then
  cat <<EOT
Usage
\$ ./${SELF:?} FILE [...]
EOT
  exit 1
fi

term() {
  rm -f /tmp/${SELF:?}.*.$$.sh
}

trap 'term' 0

main() {
  FULLNAME=$1
  BASENAME=`basename $1`
  awk '
    # nカラムのコメント作成
    function hline(n) {
      result = "";
      for (i = 0; i < n; i++) {
        result = result "#"
      }
      return result;
    }
    BEGIN{
      # date
      time = sprintf("`date %c+%%Y%%m%%d.%%H%%M%%S%c`", 39, 39);
      # シェバング行
      printf("#!/bin/sh\n");
      printf("echo `basename \$0`\n");
    }
    {
      gsub(/#+.*/, "");
      if (NF == 0) {next;}
      #printf("%s\n",hline(79));
      printf("\n");
      printf("echo \"%s\"\n",hline(79));
      printf("echo \"%s:%s\"\n", time, $0);
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
  ' ${FULLNAME:?} > /tmp/${SELF:?}.${BASENAME:?}.$$.sh
  if [ "$?" -ne "0" ]; then
    echo "main-awk ${FULLNAME:?} fail." 1>&2
    exit 1
  fi

  chmod u+x /tmp/${SELF:?}.${BASENAME:?}.$$.sh
  cat /dev/null                             >   /tmp/${SELF:?}.${BASENAME:?}.$$.log
  echo "${BASENAME:?} list"                 >>  /tmp/${SELF:?}.${BASENAME:?}.$$.log
  cat -n ${FULLNAME:?}                      >>  /tmp/${SELF:?}.${BASENAME:?}.$$.log
  echo "${SELF:?}.${BASENAME:?}.$$.sh list" >>  /tmp/${SELF:?}.${BASENAME:?}.$$.log
  cat -n /tmp/${SELF:?}.${BASENAME:?}.$$.sh >>  /tmp/${SELF:?}.${BASENAME:?}.$$.log
  echo ""                                   >>  /tmp/${SELF:?}.${BASENAME:?}.$$.log 
  echo "${SELF:?}.${BASENAME:?}.$$.sh log"  >>  /tmp/${SELF:?}.${BASENAME:?}.$$.log
  /tmp/${SELF:?}.${BASENAME:?}.$$.sh        >>  /tmp/${SELF:?}.${BASENAME:?}.$$.log 2>&1
  return $?
}

for FILE in $*
do
  main ${FILE:?}
  RC=$?
  if [ "${RC:?}" -ne "0" ]; then
    echo "main ${FILE:?} fail. Status is ${RC:?}." | tee -a /tmp/${SELF:?}.${BASENAME:?}.$$.log 1>&2 
    exit 1
  fi
done
exit 0
