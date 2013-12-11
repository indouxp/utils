#!/bin/sh

if cd /var/www; then
  ln -s /home/indou/work/samples/dom/list* .
  SUFFIX=`date '+%Y%m%d.%H%M%S'`
  su -c "cp -p index.html index.html.${SUFFIX:?}"
  awk '
      BEGIN{
        out = 1;
      }
      {
        if (out == 1) {
          print;
        }
        if ($0 ~ /<div id="contents">/) {
          out = 0;
        }
      }
      END{
      }' index.html > /tmp/index.html
  ls -1 list* |
  awk '
      {
        printf("<a href=\"%s\">%s<br></a>\n", $1, $1);
      }' >> /tmp/index.html
  awk '
      BEGIN{
        out = 0;
      }
      {
        if ($0 ~ /<\/div>/) {
          out = 1;
        }
        if (out == 1) {
          print;
        }
      }
      END{
      }' index.html >> /tmp/index.html
  su -c "cp /tmp/index.html index.html"
else
  echo "$0:fail." 1>&2
  exit 1
fi
exit 0
