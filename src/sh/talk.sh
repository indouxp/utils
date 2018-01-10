#!/bin/sh
###############################################################################
#
# REFERENCE:https://qiita.com/lutecia16v/items/8d220885082e40ace252
#
###############################################################################
VOICE=/tmp/${0##*/}.$$.voice
WAV=/tmp/${0##*/}.$$.wav

cat | nkf -w > ${VOICE:?}

MAN=/usr/share/hts-voice/nitech-jp-atr503-m001/nitech_jp_atr503_m001.htsvoice
LADY=/usr/share/hts-voice/mei/mei_normal.htsvoice

if open_jtalk \
    -m ${LADY:?} \
    -x /var/lib/mecab/dic/open-jtalk/naist-jdic \
    -ow ${WAV:?} \
    ${VOICE:?}; then

  aplay ${WAV:?}
fi
rm /tmp/${0##*/}.$$.voice
rm /tmp/${0##*/}.$$.wav

