#!/bin/sh
###############################################################################
#
# rpiのswapをoffに
#
###############################################################################

RUN_IGN_STATUS(){
  CMD="$@"
  echo $CMD
  $CMD
  return 0
}

RUN(){
  CMD="$@"
  echo $CMD
  $CMD
  RC=$?
  if [ "${RC:?}" -ne "0" ]; then
    echo fail:$CMD
  else
    echo done:$CMD
  fi
  return ${RC:?}
}

CMD="sudo dphys-swapfile swapoff"
RUN $CMD
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  exit ${RC:?}
fi
CMD="free"
RUN_IGN_STATUS $CMD
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  exit ${RC:?}
fi
CMD="sudo systemctl stop dphys-swapfile"
RUN $CMD
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  exit ${RC:?}
fi
CMD="sudo systemctl disable dphys-swapfile"
RUN $CMD
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  exit ${RC:?}
fi
CMD="sudo systemctl status dphys-swapfile"
RUN_IGN_STATUS $CMD
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  exit ${RC:?}
fi

exit 0
