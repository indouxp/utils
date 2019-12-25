#!/bin/bash
###############################################################################
#
# 192.168.0.0/24にパラでping
#
# xargsで、パラレルに実行し、標準入力のパラメータ数を一つに指定して、ping
# -P: 同時に実行するプロセス数
# -n: 1回のコマンドラインで使用する引数の上限
# ping
# -s: データのバイト数
# -c: パケット数
# -W: レスポンスの待ち時間(秒)
#
###############################################################################
TMPFILE=/tmp/${0##*/}.tmp

TERM(){
  rm -f /tmp/${0##*/}.tmp
}
trap 'TERM' 0

date
echo 192.168.0.{1..254} 192.168.10.{1..254} | # 192.168.0.0全てを確認
  xargs -P256 -n1 ping -s1 -c1 -W1          | # １アドレス毎、256パラ
  grep ttl |
  awk -v tmpfile=${TMPFILE:?} '
    function get_name(tmpfile){ 
      while ((getline result < tmpfile) >0) {
        if (result ~ /name =/){
          gsub(/..*name = /, "", result);
          close(tmpfile);
          return result;
        }
      }
      close(tmpfile);
      return;
    }
    {
      addr = $4;
      sub(/:/, "", addr); # アドレス最後のコロンを外す
      cmd = sprintf("nslookup %s >%s", addr, tmpfile);
      system(cmd);
      close(cmd);
      printf("%-16s %s\n", addr, get_name(tmpfile));
    }'
