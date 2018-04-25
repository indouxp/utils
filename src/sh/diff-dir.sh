#!/bin/sh
###############################################################################
# $BBh0l0z?t$N%G%#%l%/%H%j$H!"BhFs0z?t$N%G%#%l%/%H%jFb$NF1L>%U%!%$%k$rHf3S$9$k(B
###############################################################################
NAME=${0##*/}

DONE() {
  if [ "${MADE_BY_ME:=0}" = "1" ]; then
    rm -rf /tmp/${0##*/}.d
  fi
}

trap 'DONE' 0

ORG=$1
NEW=$2
TMPD=/tmp/${0##*/}.d

if ! mkdir ${TMPD:?}; then
  echo "${TMPD:?} exist" 1>&2
  exit 1
fi
MADE_BY_ME=1

set -eu

# ORG$B!"(BNEW$B!"$I$A$i$+$KB8:_$9$k%U%!%$%k0lMw$r<hF@(B
find ${ORG:?} -type f | sed "s#${ORG:?}##" > ${TMPD:?}/org-list
find ${NEW:?} -type f | sed "s#${NEW:?}##" > ${TMPD:?}/new-list
sort -u ${TMPD:?}/org-list ${TMPD:?}/new-list > ${TMPD:?}/list

cat ${TMPD:?}/list |
while read LINE
do
  set +e
  CMD="diff -w ${ORG:?}/${LINE:?} ${NEW:?}/${LINE:?}"
  echo ${CMD:?}
  ${CMD:?}
  RC=$?
  echo "STATUS:${RC:?}"
done

exit 0
