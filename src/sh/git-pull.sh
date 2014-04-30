#!/bin/sh

for DIR in              \
          utils         \
          work/samples  \
          work/scraping \
          work/design-pattern
do
  if [ -d $HOME/$DIR ]; then
    (cd $HOME/$DIR && git pull)
    echo "`basename $0`:$HOME/$DIR done"
  fi
done
