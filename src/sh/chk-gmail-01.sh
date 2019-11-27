#!/bin/sh
POP_SERVER="pop.gmail.com"
USER_ID="indou.tsystem@gmail.com"
#USER_ID="indou.tsystem"
PASSWORD="dsbxdfyrkuklcfhw"

expect -c "
  set timeout 30
  spawn openssl s_client -connect ${POP_SERVER:?}:995
  expect \"+OK Gpop ready\"
  send \"user ${USER_ID:?}\n\"
  expect \"+OK send PASS\"
  send \"pass ${PASSWORD:?}\n\"
  expect \"+OK Welcome.\"
  send \"stat\n\"
  expect \"+OK\"
  send \"quit\n\"
  expect \"+OK Farewell.\"
  exit 0
" > receive.log
