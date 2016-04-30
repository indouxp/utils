# http://d.hatena.ne.jp/zariganitosh/20150224/escape_sequence
if id | grep "=0[^0-9]" > /dev/null; then # uid=0
  #PS1="\$? \[\e[36m\e[41m\]\D{%y%m%d-%H%M%S} \u@\h:\W:\$\[\e[0m\] "
  PS1="\$? \[\e[31m\e[40m\]\D{%y%m%d-%H%M%S} \u@\h:\W:\$\[\e[0m\] "
else
  #PS1="\$? \[\e[37m\e[44m\]\D{%y%m%d-%H%M%S} \u@\h:\W:\$\[\e[0m\] "
  PS1="\$? \[\e[36m\e[40m\]\D{%y%m%d-%H%M%S} \u@\h:\W:\$\[\e[0m\] "
fi
