#!/bin/sh
###############################################################################
# SRC$B$+$i(BDEST$B$K%3%T!<$7$F!":o=|$9$k!#(B
# root$B$G<B9T(B
###############################################################################

su - pi -c "ssh -i /home/pi/.ssh/id_rsa2rpi-b_blank pi@rpi-b sudo mount /dev/sda1 /mnt/usb8G"

###############################################################################
# DEST$B$N3NG'(B
DEST=/mnt/usb8G/webcam.bk
if su - pi -c "ssh -i /home/pi/.ssh/id_rsa2rpi-b_blank pi@rpi-b ls -ld ${DEST:?}"
then
  echo "ok:${DEST:?}"
else
  echo "ng:${DEST:?}" 1>&2
  exit 1
fi

###############################################################################
# df$B$G3NG'(B
###############################################################################
df -h

###############################################################################
# rsync(find -mtime +1)$B$7!"@.8y$7$?$i!":o=|(B(find -mtime +2)
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
# df$B$G3NG'(B
###############################################################################
df -h

exit 0
