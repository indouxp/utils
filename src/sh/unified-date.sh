#!/bin/sh
#
# 9999/9/9  → 9999/99/99
# 9999/9/99 → 9999/99/99
# 9999/99/9 → 9999/99/99
#

main() {
  if [ "$#" -eq "0" ]; then
    while read line
    do
      unified $line
    done
  else
    for file in "$@"
    do
      while read line
      do
        unified $line
      done < $file
    done
  fi
}

unified() {
  echo "$@"                                                                          |
  sed "s#^\([0-9][0-9][0-9][0-9]\)/\([0-9]\)/\([0-9]\)\$#\1/0\2/0\3#g"     |
  sed "s#^\([0-9][0-9][0-9][0-9]\)/\([0-9]\)/\([0-9][0-9]\)\$#\1/0\2/\3#g" |
  sed "s#^\([0-9][0-9][0-9][0-9]\)/\([0-9][0-9]\)/\([0-9]\)\$#\1/\2/0\3#g"
}

main $@
