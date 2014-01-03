# -*- encoding: utf-8 -*-
#
# $CHARを、$COLUMNS個、表示する
#
require 'optparse'

$CHAR = "-"
$COLUMNS = 80

opt = OptionParser.new
opt.on('-n COLUMNS') {|v| $COLUMNS = v }  
opt.on('-c CHAR') {|v| $CHAR = v }  

opt.parse(ARGV)

$COLUMNS.to_i.times do
  print $CHAR
end
print "\n"
