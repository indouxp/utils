#!/bin/sh
###############################################################################
# 引数で与えられたファイルの定義(ファイル名.txt)と、fields.txtを読み込み、ワーク定義を作成
# 標準出力に、以下のように出力
# ex)
#[l_bat@c53 ut.tools]$ cat TEM240_SCHEDULE_S.txt
#データ区分        CHAR  1
#Ｌコード          CHAR  5
#受付方法          CHAR  2
#スケジュール№   NUMBER  3
#決済方法ＩＤ      CHAR  2
#決済方法名称      CHAR  30
#更新日            NUMBER  8
#更新時刻          NUMBER  6
#[l_bat@c53 ut.tools]$ head fields.txt
#adjust_num_flag         整理番号フラグ
#artist_kana             アーティストカナ
#artist_name             アーティスト名
#authority_id            権限ID
#cancel_end_date         ｷｬﾝｾﾙ待ち受付終了日
#cancel_start_date               ｷｬﾝｾﾙ待ち受付開始日
#cancel_touraku_date             ｷｬﾝｾﾙ当落発表日時
#cancel_unit_ts          TSｷｬﾝｾﾙ待ち切替単位
#cancel_wait_flag                ｷｬﾝｾﾙ待ち切換ﾌﾗｸﾞ
#carrier_id              キャリアコード
#[l_bat@c53 ut.tools]$
#[l_bat@c53 ut.tools]$ ./mak-file-work.sh TEM240_SCHEDULE_S
#  my $data_flag;           # データ区分
#  my $show_id;             # Ｌコード
#  my $receipt_flag;        # 受付方法
#  my $sche_num;            # スケジュール№
#  my $settlement_flag;     # 決済方法ＩＤ
#  my $settlement_name;     # 決済方法名称
#  my $upd_ymd;             # 更新日
#  my $upd_hms;             # 更新時刻
#    ($data_flag, $show_id, $receipt_flag, $sche_num, $settlement_flag, $settlement_name, $upd_ymd, $upd_hms)
#            = unpack("A1A5A2A3A2A30A8A6", $_);
#
###############################################################################
# 引数
if [ "$#" -ne "1" ]; then
  cat <<EOT 1>&2
\$ `basename $0` FILE
EOT
  exit 1
fi
FILE=$1
awk -vfile=${FILE:?}.txt '
  BEGIN{
    max = 0;
    cnt = 1;
    while(getline <file > 0) {
      if (0 < NF) {
        max = cnt;
        field_names[cnt] = $1;
        field_attributes[cnt] = $3;
        cnt++;
      }
    }
  }
  {
    if ($0 !~ /^#/) {
      field_id = $1;
      field_name = $2;
      for(i = 1; i <= max; i++) {
        if (field_names[i] == field_name) {
          field_ids[i] = field_id;
        }
      }
    }
  }
  END{
    for(i = 1; i <= max; i++) {
      printf("  my %s%-20s # %s\n", "\044", field_ids[i]";", field_names[i]);
    }
    printf("    (");
    for(i = 1; i <= max; i++) {
      if (i != 1) {
        printf(", ");
      }
      printf("%s%s", "\044", field_ids[i]);
    }
    printf(")\n");
    printf("      = unpack(");
    for (i = 1; i <= max; i++) {
      printf("A%d", field_attributes[i]);
    }
    printf("\", %s_);\n", "\044");
  }
' fields.txt
