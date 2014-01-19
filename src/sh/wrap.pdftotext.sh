#!/bin/sh
script=`basename $0`

hline() {
  awk 'BEGIN{for(i=0; i<80; i++) {printf("%s", "-");}printf("\n");}'
}

usage() {
  cat <<EOT 1>&2
\$ `basename $0` SEARCH FILE [...]
EOT
}

if [ "$#" -lt 2 ]; then
  usage
  exit 1
fi

search=$1
shift
MRC=0
for file in "$@"
do
  set -e
  text=`echo "${file:?}" | sed "s/\.pdf/\.txt/"`
  set +e
  if pdftotext "${file:?}"; then
    grep -En ${search:?} "${text:?}"
    RC=$?
echo "${text:?}:$RC" 1>&2
    if [ "${MRC:?}" -lt "${RC:?}" ]; then
      MRC=${RC:?}
    fi
    if [ "${RC:?}" -eq "0" ]; then
      hline
      set -e
      pages=`wc -l "${text:?}"`
      set +e
      echo "Total Pages:${pages:?}"
      hline
    fi
    #rm "${text:?}"
  else
    echo "${script:?}:pdftotext ${file:?} fail." 1>&2
    exit 1
  fi
done
exit ${MRC:?}
