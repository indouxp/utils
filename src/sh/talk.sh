#!/bin/sh
###############################################################################
#
# REFERENCE:https://qiita.com/lutecia16v/items/8d220885082e40ace252
#
###############################################################################
NAME=${0##*/}
IS_LOCK=0
LOCK_DIR=/tmp/${NAME:?}.lock.d

term() {
  if [ ${IS_LOCK:?} != 0 ]; then
    rmdir /tmp/${NAME:?}.lock.d
  fi
}
trap 'term' 0 1 2 3 15

while true
do
  if mkdir ${LOCK_DIR:?} 2>/dev/null; then
    IS_LOCK=1
    break
  fi
  sleep 1
done

VOICE=/tmp/${0##*/}.$$.voice
WAV=/tmp/${0##*/}.$$.wav
SPEED=0.5

sudo amixer cset numid=1 98.4% > /dev/null 2>&1
sudo alsactl store

cat | nkf -w > ${VOICE:?}

MAN=/usr/share/hts-voice/nitech-jp-atr503-m001/nitech_jp_atr503_m001.htsvoice
LADY=/usr/share/hts-voice/mei/mei_normal.htsvoice

if open_jtalk \
    -m ${LADY:?} \
    -x /var/lib/mecab/dic/open-jtalk/naist-jdic \
    -ow ${WAV:?} \
    -r ${SPEED:?}\
    ${VOICE:?}; then

  aplay --quiet ${WAV:?}
fi
rm /tmp/${0##*/}.$$.voice
rm /tmp/${0##*/}.$$.wav

