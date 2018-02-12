#!/bin/sh
###############################################################################
# SRCからDESTにコピーして、削除する。
# rootで実行
###############################################################################

su - pi -c "ssh -i /home/pi/.ssh/id_rsa2rpi-b_blank pi@rpi-b sudo mount /dev/sda1 /mnt/usb8G"

###############################################################################
# DESTの確認
DEST=/mnt/usb8G/webcam.bk
if su - pi -c "ssh -i /home/pi/.ssh/id_rsa2rpi-b_blank pi@rpi-b ls -ld ${DEST:?}"
then
  echo "ok:${DEST:?}"
else
  echo "ng:${DEST:?}" 1>&2
  exit 1
fi

###############################################################################
# dfで確認
###############################################################################
df -h

###############################################################################
# rsync(find -mtime +1)し、成功したら、削除(find -mtime +2)
###############################################################################
SRC=/mnt/usb8G/webcam
if cd ${SRC:?}
then
  if find . -mtime +1 -type f -print0 | su - pi -c "rsync -a -e \"ssh -i /home/pi/.ssh/id_rsa2rpi-b_blank \" --files-from=- --from0 ${SRC:?}/ pi@rpi-b:${DEST:?}/"
  then
    echo "ok:find rsync"
    if find . -mtime +2 -exec /bin/rm {} \;
    then
      echo "ok:find rm"
    else
      echo "ng:find rm" 1>&2
      exit 1
    fi
  else
    echo "ng:find rsync" 1>&2
    exit 1
  fi
else
  echo "ng:cd ${SRC:?}" 1>&2
  exit 1
fi

###############################################################################
# dfで確認
###############################################################################
df -h

exit 0
