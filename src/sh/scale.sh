#!/bin/sh
DIR=`dirname $0`/../src/rb
SRC=`basename $0 | sed "s/\.sh/\.rb/"`
ruby ${DIR:?}/${SRC:?} $@
exit $?
