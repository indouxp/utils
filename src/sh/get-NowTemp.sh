#!/bin/sh
###############################################################################
#
# 国土交通省-気象庁のサイトからデータを取得
# https://www.data.jma.go.jp/obd/stats/data/mdrr/docs/csv_dl_readme.html
#
###############################################################################
NAME=${0##*/}
OUT=/tmp/${NAME:?}.out.$$
ORG=/tmp/${NAME:?}.org.$$
PLACE="八王子"
PLACE=$1

###############################################################################
TERM(){
  for SUFFIX in out org
  do
    mv /tmp/${0##*/}.${SUFFIX:?}.$$ /tmp/${0##*/}.${SUFFIX:?}
  done
}
trap 'TERM' 0

###############################################################################
# https://www.data.jma.go.jp/obd/stats/data/mdrr/docs/csv_dl_format_mxtem.html
MAXTEMP="https://www.data.jma.go.jp/obd/stats/data/mdrr/tem_rct/alltable/mxtemsadext00_rct.csv"
# https://www.data.jma.go.jp/obd/stats/data/mdrr/docs/csv_dl_format_mntem.html
MINTEMP="https://www.data.jma.go.jp/obd/stats/data/mdrr/tem_rct/alltable/mntemsadext00_rct.csv"

###############################################################################
if [ ! -x $(which nkf) ]; then
  echo "${NAME:?}: nkf not found." 1>&2
  exit 9
fi
if [ ! -x $(which gawk) ]; then
  echo "${NAME:?}: gawk not found." 1>&2
  exit 9
fi

###############################################################################
for TEMP in ${MAXTEMP:?}@MAX ${MINTEMP:?}@MIN
do
  WHICH=$(echo ${TEMP:?} | sed 's/[^@]*@//')
  URL=$(echo ${TEMP:?} | sed 's/@[^@]*//')
  if wget -O ${OUT:?} ${URL:?} 2>/dev/null; then
    nkf -w -Lu -d ${OUT:?} |
    grep ${PLACE:?} |
    tee  ${ORG:?}   |
    gawk -v FPAT='([^,]+)|(\"[^\"]+\")' \
        -v NAME=${NAME:?} \
        -v WHICH=${WHICH:?} \
        -v PLACE=${PLACE:?} \
      '{printf("%s-%s: %s: %4.2f %04d/%02d/%02d %02d:%02d (%02d:%02d)\n", NAME, PLACE, WHICH, $9, $4, $5, $6, $7, $8, $11, $12);}'
    #cat ${ORG:?}
  fi
done

###############################################################################
exit 0
