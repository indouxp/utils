#!/bin/sh
###############################################################################
#
# gmail$BFI$_9~$_(B
# REFERENCE:http://www.atmarkit.co.jp/fnetwork/rensai/netpro07/pop3-commands.html
#
#
###############################################################################
NAME=${0##*/}
. ~/.ssh/${NAME:?}.conf

TMP=/tmp/${NAME:?}.$$.tmp

TERM() {
  rm -f /tmp/${NAME:?}.$$.tmp
}

trap 'TERM' 0

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
" > ${TMP:?}

LAST_NO=$(awk '{if ($1 !~ /\./) {LAST_NO = $1;}}END{print LAST_NO;}' ${TMP:?})

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
      send \"retr ${LAST_NO:?}\n\"
    }
  }
"

exit 0
