# -*- encoding: utf-8 -*-
#
# $CHARを、$COLUMNS個、表示する
#
require 'optparse'

$CHAR = "-"
$FIVE = "+"
$COLUMNS = 80

opt = OptionParser.new
# optにコマンドラインオプションを登録
opt.on('-n COLUMNS') {|v| $COLUMNS = v }  
opt.on('-c CHAR') {|v| $CHAR = v }  

opt.parse(ARGV) # ARGVの解析

$COLUMNS.to_i.times do |t|
  columns = t + 1
  if columns % 10 == 0 then
    print (columns / 10).to_s
  elsif columns % 5 == 0 then
    print $FIVE
  else
    print $CHAR
  end
end
print "\n"

exit 0
