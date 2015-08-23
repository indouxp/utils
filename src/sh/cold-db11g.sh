#!/bin/sh
#
# stdのdb11gのcold backupを、tw-mk18へ
#
ssh oracle@std                                              \
  'cd /; tar czvf -                                         \
  ./u01/app/oracle/oradata/db11g/control01.ctl              \
  ./u01/app/oracle/fast_recovery_area/db11g/control02.ctl   \
  ./u01/app/oracle/oradata/db11g/redo03.log                 \
  ./u01/app/oracle/oradata/db11g/redo02.log                 \
  ./u01/app/oracle/oradata/db11g/redo01.log                 \
  ./u01/app/oracle/oradata/db11g/temp01.dbf                 \
  ./u01/app/oracle/oradata/db11g/users01.dbf                \
  ./u01/app/oracle/oradata/db11g/undotbs01.dbf              \
  ./u01/app/oracle/oradata/db11g/sysaux01.dbf               \
  ./u01/app/oracle/oradata/db11g/system01.dbf               \
  ' | tar xzvf -
