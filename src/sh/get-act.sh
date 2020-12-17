#!/bin/sh
###############################################################################
#
# システムのアクティビティ調査
#
###############################################################################
HOST=$(uname -n)
NAME=${HOST:?}_${0##*/}
KILL_FUNC=KILL_${NAME:?}

START=$(date '+%Y%m%d_%H%M%S_%3N')
INTERVAL=5

make_kill() {
  PID=$1

  cat <<EOT
  ps -ef | grep ${PID:?} | grep -v grep
  echo -n "OK?"
  read OK
  kill ${PID:?}
  ps -ef | grep ${PID:?} | grep -v grep
EOT
}

cat <<EOT > ${KILL_FUNC:?}
#!/bin/sh
EOT

# CPU
sar -u ${INTERVAL:?} > ${NAME:?}_${START:?}.sar.u &
PID=$!
make_kill ${PID:?} >> ${KILL_FUNC:?}

# MEMORY
sar -r ${INTERVAL:?} > ${NAME:?}_${START:?}.sar.r &
PID=$!
make_kill ${PID:?} >> ${KILL_FUNC:?}

# SWAP
sar -W ${INTERVAL:?} > ${NAME:?}_${START:?}.sar.W &
PID=$!
make_kill ${PID:?} >> ${KILL_FUNC:?}

# Disk
sar -d -p ${INTERVAL:?} > ${NAME:?}_${START:?}.sar.dp &
PID=$!
make_kill ${PID:?} >> ${KILL_FUNC:?}

# Network
sar -n DEV ${INTERVAL:?} > ${NAME:?}_${START:?}.sar.nDEV &
PID=$!
make_kill ${PID:?} >> ${KILL_FUNC:?}

jobs
chown a+x ${KILL_FUNC:?}
