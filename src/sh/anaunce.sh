#!/bin/sh
TALK=~/utils/src/sh/talk.sh
NOTICE=~/notice.txt

if [ ! -e ${NOTICE:?} ]; then
  exit0
fi

YMDHMS=`stat ${NOTICE:?} | grep "^Modify:" | sed 's/Modify: //' | sed 's/\..*$//'`
YMDHMS=`echo ${YMDHMS:?} | sed 's/[0-9][0-9][0-9][0-9]-//'` 
YMDHMS=`echo ${YMDHMS:?} | sed 's/-/月/'`
YMDHMS=`echo ${YMDHMS:?} | sed 's/ /日 /'`
YMDHMS=`echo ${YMDHMS:?} | sed 's/:/時/'`
YMDHMS=`echo ${YMDHMS:?} | sed 's/:/分/'`
YMDHMS=`echo ${YMDHMS:?} | sed 's/$/秒。/'`

echo -n ${YMDHMS:?} > ~/tmp/notice.txt
cat ${NOTICE:?} >> ~/tmp/notice.txt

cat ~/tmp/notice.txt >/dev/null

touch ~/tmp/notice.old
touch ~/tmp/count.txt

NOW=`cat ~/tmp/count.txt`
if [ "${NOW}" = "" ]; then
  NOW=1
else
  NOW=`expr ${NOW:?} + 1`
fi

if ! diff ~/tmp/notice.txt ~/tmp/notice.old > /dev/null; then
  cat ~/tmp/notice.txt | ${TALK:?}
  NOW=1
else
  if [ ${NOW:?} -lt 5 ]; then
    cat ~/tmp/notice.txt | ${TALK:?}
  fi
fi

echo $NOW > ~/tmp/count.txt
cp -p ~/tmp/notice.txt ~/tmp/notice.old

exit 0
