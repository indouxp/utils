#!/bin/sh
if [ "$1" = "url" ]; then
cat <<EOT
https://www.netdeaoiro.jp/login.html
mcea015201
3059082
EOT
fi

cat <<EOT
131 売掛金
390 事業主貸し
490 事業主借
712 水道光熱費
721 消耗品費
714 旅費交通費

振替伝票入力
借方                   貸方
713 荷造運賃           490 事業主借
714 旅費交通費         490 事業主借
715 通信費             490 事業主借
721 消耗品費           490 事業主借
731 会議費             490 事業主借
732 事務用品費         490 事業主借
733 諸会費             490 事業主借
734 図書費             490 事業主借
EOT

