#!/bin/sh
# for SunOS 5.10
# find / -exec ls -ld {} \; を比較

#ORG=$1
#NEW=$2
ORG=v120.ls.ld.txt
NEW=v120.ls.ld.new.txt

for file in $ORG $NEW
do
  cat $file                       |
  awk '{
        printf("%s %s %s %s %s ", $1, $2, $3, $4, $5); 
        for (i = 9; i <= NF; i++) {
          printf("%s ", $i);
        }
        printf("\n");
      }' $file                    |
  grep -v "/system/contract"      |
  grep -v "/proc"                 |
  grep -v "/etc/svc/volatile"     |
  grep -v "/dev/fd"               |
  grep -v "/tmp"                  |
  grep -v "/var/run"              |
  grep -v "/devices"              |
  grep -v "/system/object"        |
  sort -k6 > $file.1
done

diff $ORG.1 $NEW.1
