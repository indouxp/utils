#!/bin/sh

for DIR in utils work/samples work/scraping
do
  (cd $HOME/$DIR && git pull)
  echo "`basename $0`:$HOME/$DIR done"
done
