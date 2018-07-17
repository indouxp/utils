# http://d.hatena.ne.jp/zariganitosh/20150224/escape_sequence
RED="\[\e[31m\]"
GREEN="\[\e[32m\]"
YELLOW="\[\e[33m\]"
BLUE="\[\e[34m\]"
MAGENTA="\[\e[35m\]"
CYAN="\[\e[36m\]"
WHITE="\[\e[37m\]"
CLEAR="\[\e[0m\]"
if id | grep "=0[^0-9]" > /dev/null; then # uid=0
  #PS1="\$? \[\e[36m\e[41m\]\D{%y%m%d-%H%M%S} \u@\h:\W:\$\[\e[0m\] "
  #PS1="\$? \[\e[31m\e[40m\]\D{%y%m%d-%H%M%S} \u@\h:\W:\$\[\e[0m\] "
  PS1="${RED:?}\$?${CLEAR:?} \D{%y%m%d-%H%M%S} ${RED:?}\u${CLEAR:?}@\h:${YELLOW:?}\W${CLEAR:?}:\n# "
else
  #PS1="\$? \[\e[37m\e[44m\]\D{%y%m%d-%H%M%S} \u@\h:\W:\$\[\e[0m\] "
  #PS1="\$? \[\e[36m\e[40m\]\D{%y%m%d-%H%M%S} \u@\h:\W:\$\[\e[0m\] "
  PS1="${RED:?}\$?${CLEAR:?} \D{%y%m%d-%H%M%S} ${GREEN:?}\u${CLEAR:?}@\h:${YELLOW:?}\W${CLEAR:?}:\n\$ "
fi
