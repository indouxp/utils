#!/bin/sh
main() {
  sshlogin 106.158.220.236 pi /home/indou/.ssh/id_rsa_sakura4home intatsu1645
}

sshlogin() {
  TIMEOUT=5
  case "$#" in
    3)
      HOST=$1
      USER=$2
      PASSWORD=$3
      HOSTINFO="${USER:?}@${HOST:?}"
      PASSPHRASE=""
      ;;
    4)
      HOST=$1
      USER=$2
      KEY=$3
      PASSPHRASE=$4
      HOSTINFO="${USER:?}@${HOST:?} -i ${KEY:?}"
      PASSWORD=""
      ;;
  esac

  expect -c "
    set timeout ${TIMEOUT:?}
    spawn env LANG=C ssh ${HOSTINFO:?}
    expect {
      \"Are you sure you want to continue connecting (yes/no)?\" {
        send \"yes\n\"
        exp_continue
      }
      -glob \"password:\" {
        send \"${PASSWORD}\n\"
      }
      -reg \"Enter passphrase for key .*:\" {
        send \"${PASSPHRASE}\n\"
      }
    }
    expect \"$\"
    exit 0
  "
}

main "$@"
