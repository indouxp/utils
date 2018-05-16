#!/bin/sh

set -eu

i=54321; for group in oinstall dba backupdba oper dgdba kmdba; do
  groupadd -g $i $group; i=$(expr $i + 1)
done

useradd -u 1200 -g oinstall -G dba,oper,backupdba,dgdba,kmdba -d /home/oracle oracle 

DO="passwd oracle"

echo ${DO:?}
${DO:?}

mkdir -p /u01/app/oracle

chown -R oracle:oinstall /u01/app

chmod -R 775 /u01 
