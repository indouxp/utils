#!/bin/sh
#
# 標準入力を標準に出力に、catし、物差しをつける
# scale環境変数に値がセットされている場合は、その値ごとに物差しをつける。
#
# 物差しは、5byte毎に'+'か、十の位の数値
# ----+----1----+----2--
#
# でも、
# 最大の長さを読み込むけれど、lengthで取得しているため、マルチバイトが混じる場合は、最大長を正しくカウントしない。
#

scale() {
  awk '
    function display_scale() {
      for(i = 1; i <= max; i++) {
        if ((i % 5) == 0) {
          if ((i % 10) == 0) {
            display = sprintf("%s", i/10);
            gsub(/\([0-9]*\)\([0-9]\)/, "\2", display);
            printf("%s", display);
          } else {
            printf("+");
          }
        } else {
          printf(".");
        }
      }
      printf("\n");
    }
    BEGIN{
      if (ENVIRON["scale"] == "") {
        scale = 10;
      } else {
        scale = ENVIRON["scale"];
      }
      max = 0;
    }
    {
      buf[NR] = $0;
      if (max < length($0)) {
        max = length($0);
        #cmd = sprintf("echo %c%s%c | wc -c", "\047", $0, "\047");
        #cmd | getline max;
      }
    }
    END{
      display_scale();
      for(rec = 1; rec <= NR; rec++) {
        if (scale != 0 && (rec % scale) == 0) {
          display_scale();
        }
        printf("%s\n", buf[rec]);
      }
    }
'
}

if [ "$#" -eq "0" ]; then
  scale
else
  for file in "$@"
  do
    cat $file | scale
  done
fi
