#!/bin/sh
# 20180425:-regexp \"\.\r\$\"まで
NAME=${0##*/}

USER="indou.tsystem@gmail.com"
PASS=homfmingwdzqkkik
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
    -regexp \"\.\r\$\" {
      exit 0
    }
  }
"
