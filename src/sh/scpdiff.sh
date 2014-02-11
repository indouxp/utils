#!/bin/sh
# user@src_host:path dest_host
#
script=`basename $0`
if [ "$#" -eq "0" ]; then
  cat <<EOT >&2
\$ $script user@src_host:path dest_host
EOT
  exit 1
fi

src=$1
src_host=`echo $src | sed "s/[^@]*@\([^:]*\):.*/\1/"`
dest_host=$2
path=`echo $src | sed "s/[^:]*:\(.*\)/\1/"`
file=`basename $path`
dest=`echo $src | sed "s/$src_host/$dest_host/"`

cmd="scp $src /tmp/$src_host.$file"
echo $cmd
$cmd
rc=$?
if [ "${rc:?}" -ne "0" ]; then
  echo "$script $cmd fail:" 1>&2
  exit 1
fi

cmd="scp $dest /tmp/$dest_host.$file"
echo $cmd
$cmd
rc=$?
if [ "${rc:?}" -ne "0" ]; then
  echo "$script $cmd fail:" 1>&2
  exit 1
fi

diff /tmp/$src_host.$file /tmp/$dest_host.$file
rc=$?
if [ "${rc:?}" -eq "0" ]; then
  echo "$script: $src, $dest is no diff."
fi
exit 0

