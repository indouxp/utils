#!/bin/sh
# sysctlよりバッテリの状態を取得する。
# for FreeBSD 9.1-RELEASE
#
sysctl hw.acpi.battery | tee `basename $0`.log |
	nawk '
		BEGIN{
      #システムに載っているバッテリ全てをひっくるめての容量
      key = "hw.acpi.battery.life";
      comments[key] = "バッテリのチャージ率";
      format[key] = "%s:%d%s\n";
      unit[key] = "%";

      #推定活動限界時間
      key = "hw.acpi.battery.time";
      comments[key] = "バッテリの残り時間";
      format[key] = "%s:%d%s\n";
      unit[key] = "分";

      #バッテリの数
			key = "hw.acpi.battery.units";
      comments[key] = "バッテリの数";
      format[key] = "%s:%d%s\n";
      unit[key] = "個";

      #バッテリ情報が有効な秒数、バッテリ情報の取得は割と重い処理なので、頻繁に取得しないようにするため。
      key = "hw.acpi.battery.info_expire";
      comments[key] = "バッテリ情報が有効な秒数";
      format[key] = "%s:%d%s\n";
      unit[key] = "秒";

      #バッテリの状態
			key = "hw.acpi.battery.state";
      comments2[key] = "バッテリの状態";
      format2[key] = "%s:%s%s\n";
      unit2[key] = "";
      remarks[1] = "放電中";
      remarks[2] = "充電中";
      remarks[7] = "なし";
		}
		{
      for (i in comments) {
        if ($1 == i":") {
          printf(format[i], comments[i], $2, unit[i]);
        }
      }
      for (i in comments2) {
        if ($1 == i":") {
          printf(format[i], comments2[i], remarks[$2], unit2[i]);
        }
      }
		}
		END{
		}'
sysctl hw.acpi.acline | tee -a `basename $0`.log |
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
