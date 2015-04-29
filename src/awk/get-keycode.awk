#!/usr/bin/awk -f
# http://www.kt.rim.or.jp/~kbk/gawk-30/gawk_16.html
#
BEGIN {
  _ord_init()
  for (;;) {
    printf("文字を入力してください: ")
    if (getline var <= 0)
      break
    printf("ord(%s) = %d\n", var, ord(var))
  }
}

function _ord_init(low, high, i, t) {
    low = sprintf("%c", 7) # BEL は ASCIIコードの 7
    if (low == "\a") {    # 通常のASCII
        low = 0
        high = 127
    } else if (sprintf("%c", 128 + 7) == "\a") {
        # ascii, mark parity
        low = 128
        high = 255
    } else {        # EBCDIC(!)
        low = 0
        high = 255
    }

    for (i = low; i <= high; i++) {
        t = sprintf("%c", i)
        _ord_[t] = i
    }
}

function ord(str, c) {
    # 最初のキャラクタだけに注目する。
    c = substr(str, 1, 1)
    return _ord_[c]
}

