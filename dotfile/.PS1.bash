# http://d.hatena.ne.jp/zariganitosh/20150224/escape_sequence
# https://qiita.com/PruneMazui/items/8a023347772620025ad6
RED="\[\e[31m\]"
GREEN="\[\e[32m\]"
YELLOW="\[\e[33m\]"
BLUE="\[\e[34m\]"
MAGENTA="\[\e[35m\]"
CYAN="\[\e[36m\]"
WHITE="\[\e[37m\]"
_BLUE="\[\e[44m\]"
CLEAR="\[\e[0m\]"                         # 指定をリセットし未指定状態に戻す
BLINK="\[\e[5m\]"                         # ブリンク
BOLD="\[\e[1m\]"                          # 太字
TURN="\[\e[7m\]"                          # 文字色と背景色の反転
UNDER="\[\e[4m\]"                         # アンダーライン
if id | grep "=0[^0-9]" > /dev/null; then # uid=0
  PS1="${RED:?}\$?${CLEAR:?} \D{%y%m%d-%H%M%S} ${RED:?}\u${CLEAR:?}@${UNDER:?}${RED:?}${_BLUE:?}\h${CLEAR:?}:${YELLOW:?}\W${CLEAR:?}:\n# "
else
  PS1="${RED:?}\$?${CLEAR:?} \D{%y%m%d-%H%M%S} ${GREEN:?}\u${CLEAR:?}@${UNDER:?}${RED:?}${_BLUE:?}\h${CLEAR:?}:${YELLOW:?}\W${CLEAR:?}:\n\$ "
fi
