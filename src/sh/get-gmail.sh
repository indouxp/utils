#!/bin/sh
NAME=${0##*/}
. ${NAME:?}.conf
expect -c "
  set timeout 30
  log_file -noappend ${NAME:?}.log
  spawn openssl s_client -crlf -connect pop.gmail.com:995
  expect {
    -glob \"+OK Gpop ready for requests from \" {
      send \"user ${USER:?}\n\"
      exp_continue
    }
    -glob \"+OK send PASS\" {
      send \"pass ${PASS:?}\n\"
      exp_continue
    }
    -glob \"+OK Welcome\" {
      send \"list\n\"
      exp_continue
    }
    -regexp \"\\n\\.\\r\" {
      exit 0
    }
  }
"
exit 0
# 20180425:-regexp \"\\n\\.\\r\" {成功
