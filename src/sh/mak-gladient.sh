#!/bin/sh
###############################################################################
# to bottomのグラデーションのbackground-imageのcss構文を作成する。
# href="http://www.css-lecture.com/log/css3/css3-gradient.html"
# href="http://ie.microsoft.com/testdrive/Graphics/CSSGradientBackgroundMaker/"
###############################################################################
SCRIPT_NAME=`basename $0`
usage() {
  cat <<EOT 1>&2
Usage
\$ ${SCRIPT_NAME:?} from-color to-color
\$ ${SCRIPT_NAME:?} from-color from-rate to-color to-rate
EOT
  grep -E "^#[^!]+[^#]+" $0
}
if [ "$#" -eq "0" ]; then
  usage
  exit 1
fi 

if [ "$#" -eq "2" ]; then
  FROM_COLOR=$1
  FROM_RATE=0
  TO_COLOR=$2
  TO_RATE=100
fi

if [ "$#" -eq "4" ]; then
  FROM_COLOR=$1
  FROM_RATE=$2
  TO_COLOR=$3
  TO_RATE=$4
fi

FROM_VALUE=`expr ${FROM_RATE:?} / 100`
TO_VALUE=`expr ${TO_RATE:?} / 100`

cat <<EOT
  /* IE10 Consumer Preview */ 
  background-image: -ms-linear-gradient(top, #${FROM_COLOR:?} ${FROM_RATE:?}%, #${TO_COLOR:?} ${TO_RATE:?}%);
  /* Mozilla Firefox */ 
  background-image: -moz-linear-gradient(top, #${FROM_COLOR:?} ${FROM_RATE:?}%, #${TO_COLOR:?} ${TO_RATE:?}%);
  /* Opera */ 
  background-image: -o-linear-gradient(top, #${FROM_COLOR:?} ${FROM_RATE:?}%, #${TO_COLOR:?} ${TO_RATE:?}%);
  /* Webkit (Safari/Chrome 10) */ 
  background-image: -webkit-gradient(linear, left top, left bottom, color-stop(${FROM_VALUE:?}, #${FROM_COLOR:?}), color-stop(${TO_VALUE:?}, #${TO_COLOR:?}));
  /* Webkit (Chrome 11+) */ 
  background-image: -webkit-linear-gradient(top, #${FROM_COLOR:?} ${FROM_RATE:?}%, #${TO_COLOR:?} ${TO_RATE:?}%);
  /* W3C Markup, IE10 Release Preview */ 
  background-image: linear-gradient(to bottom, #${FROM_COLOR:?} ${FROM_RATE:?}%, #${TO_COLOR:?} ${TO_RATE:?}%);

  /* 角丸め */
  border-radius: 10px;          /* CSS3草案 */  
  -webkit-border-radius: 10px;  /* Safari,Google Chrome用 */  
  -moz-border-radius: 10px;     /* Firefox用 */ 

EOT
