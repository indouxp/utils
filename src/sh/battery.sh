#!/bin/sh
###############################################################################
# description:sysctlよりバッテリの状態を取得する。
# for FreeBSD 9.1-RELEASE
# http://www.init-main.com/acpirensai/acpi-features.txt (accessed 20130402)
###############################################################################
logbasename=`basename $0`.log
logdirname=/tmp
logname=${logdirname:?}/${logbasename:?}

[ `uname -o` = "FreeBSD" ] || exit 1

set -e
sysctl hw.acpi.battery | tee ${logname:?} |
	nawk '
    function addkey(key, comment, format, unit) {
      comments[key] = comment;
      formats[key] = format;
      units[key] = unit;
    }
    function addkey2(key, comment, format) {
      comments2[key] = comment;
      formats2[key] = format;
    }
		BEGIN{
      #システムに載っているバッテリ全てをひっくるめての容量
      addkey("hw.acpi.battery.life",
              "バッテリのチャージ率",
              "%s:%d%s\n",
              "%");

      #推定活動限界時間
      addkey("hw.acpi.battery.time",
              "バッテリの残り時間",
              "%s:%d%s\n",
              "分");

      #バッテリの数
			addkey("hw.acpi.battery.units",
              "バッテリの数",
              "%s:%d%s\n",
              "個");

      #バッテリ情報が有効な秒数、バッテリ情報の取得は割と重い処理なので、頻繁に取得しないようにするため。
      addkey("hw.acpi.battery.info_expire",
              "バッテリ情報が有効な秒数",
              "%s:%d%s\n",
              "秒");

      #バッテリの状態
			addkey2("hw.acpi.battery.state",
              "バッテリの状態",
              "%s:%s\n");
      remarks2[0] = "0";
      remarks2[1] = "放電中";
      remarks2[2] = "充電中";
      remarks2[4] = "容量なし";
      remarks2[7] = "バッテリなし";
		}
		{
      for (i in comments) {
        if ($1 == i":") {
          printf(formats[i], comments[i], $2, units[i]);
        }
      }
      for (i in comments2) {
        if ($1 == i":") {
          printf(formats2[i], comments2[i], remarks2[$2]);
        }
      }
		}
		END{
		}'

sysctl hw.acpi.acline | tee -a ${logname:?} |
	nawk '
		BEGIN{
      #AC電源の状態
			key = "hw.acpi.acline";
      comments2[key] = "AC電源の状態";
      format2[key] = "%s:%s%s\n";
      unit2[key] = "";
      remarks[0] = "未接続";
      remarks[1] = "接続中";
		}
		{
      for (i in comments2) {
        if ($1 == i":") {
          printf(format2[i], comments2[i], remarks[$2], unit2[i]);
        }
      }
		}
		END{
		}'
