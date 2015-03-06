#!/bin/bash
###############################################################################
#
# Product Introduction
#   第一引数のディレクトリから第二引数のリモートディレクトリへ差分コピー
#
###############################################################################

SCRIPT_NAME=`basename $0`
usage() {
  #sed -n "/^# Product Introduction/,/^#\$/p" $0
  sed -n '/^# Product Introduction/,/^#$/p' $0
  cat <<EOT
Usage
  \$ ./${SCRIPT_NAME:?} DIR USER@HOST:DIR 
EOT
}
if [ "$#" -eq "0" ]; then
  usage
  exit 2
fi

set -e

DIR=$1
REMOTE=$2
USER_REMOTE_HOST=`echo ${REMOTE:?} | sed "s/:.*//"`
REMOTE_DIR=`echo ${REMOTE:?} | sed "s/[^:][^:]*://"`
REMOTE_LIST=/tmp/${SCRIPT_NAME:?}.remote
LOCAL_LIST=/tmp/${SCRIPT_NAME:?}.local
TAR_LIST=/tmp/${SCRIPT_NAME:?}.list
TAR_FILE=/tmp/${SCRIPT_NAME:?}.tar.gz
CMD_FILE=/tmp/${SCRIPT_NAME:?}.cmd

echo ${DIR:?}
echo ${REMOTE:?}
echo ${USER_REMOTE_HOST:?}
echo ${REMOTE_DIR:?}

echo -n "${REMOTE:?} PASSWORD:"
read -s PASSWORD
echo

find ${DIR:?} -type f |
  sed "s#${DIR:?}##"  |
  sed "s#^/##"        |
  sort > ${LOCAL_LIST:?} 

sshpass -p ${PASSWORD:?} ssh ${USER_REMOTE_HOST:?} \
  'find '${REMOTE_DIR:?}' -type f'                 |
  sed "s#${REMOTE_DIR:?}##"                        |
  sed "s#^/##"                                     |
  sort > ${REMOTE_LIST:?}

diff ${LOCAL_LIST:?} ${REMOTE_LIST:?} | grep "< " | sed "s/< //" > ${TAR_LIST:?}

awk -v user_remotehost=${USER_REMOTE_HOST:?} \
    -v remotedir=${REMOTE_DIR:?} \
    -v password=${PASSWORD:?} \
    -v dir=${DIR:?} \
    -v cmdfile=${CMD_FILE:?} \
'
  BEGIN{
    single_quote = 39;
    printf("%s\n", dir);
    printf("%s\n", remote);
    line = 1;
  }
  {
    adddir = $0;
    sub(/\/.*/, "", adddir);
    cmds[line++] = sprintf("sshpass -p %c%s%c scp -p \"%s/%s\" %s:%s/%s",
        single_quote, password, single_quote, dir, $0, user_remotehost, remotedir, adddir);
    if (line == 5) {
      system(sprintf("cat /dev/null > %s", cmdfile));
      for(i in cmds) {
        if (cmds[i] != "") {
          printf("%s &\n", cmds[i]) >> cmdfile;
        }
      }
      printf("wait\n") >> cmdfile;
      rc = system(sprintf("sh %s", cmdfile));
      if (rc != 0) {
        printf("\"%s\" fail.\n", cmdfile);
        exit(rc);
      }
      system(sprintf("sed %cs/%s//%c %s", single_quote, password, single_quote, cmdfile));
      printf("done.\n");
      for(i in cmds) {
        cmds[i] = "";
      }
      line = 1;
    }
  }
  END{
    system(sprintf("cat /dev/null > %s", cmdfile));
    for(i in cmds) {
      if (cmds[i] != "") {
        printf("%s &\n", cmds[i]) >> cmdfile;
      }
    }
    printf("wait\n") >> cmdfile;
    rc = system(sprintf("sh %s", cmdfile));
    if (rc != 0) {
      printf("\"%s\" fail.\n", cmdfile);
      exit(rc);
    }
    system(sprintf("sed %cs/%s//%c %s", single_quote, password, single_quote, cmdfile));
    printf("done.\n");
  }
' ${TAR_LIST:?}

exit 0
