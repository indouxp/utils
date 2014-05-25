#!/usr/bin/perl
###############################################################################
# CSVファイルから、固定長ファイル(SJISでEncode)を作成
# 1:CSVファイル名
# 2:固定長(テキスト)ファイル名
#
use strict;
use warnings;
use File::Basename;
use Encode 'encode', 'decode';
use utf8;

binmode(STDOUT, ":utf8"); # PerlIOレイヤ

if ($#ARGV == -1) {
  usage();
  die '$#ARGV';
}

sub usage {
  print "Usage\n";
  print sprintf("\$ %s FILE.csv\n", basename(__FILE__));
  my $stmts =<<'EOT';
Format
    a　　ASCII string(ヌル文字が補完される)
    A　　ASCII string(スペースが補完される)
    b　　bit string(昇順ビットオーダ)
    B　　bit string(降順ビットオーダ)
    h　　hex string(low nybble first)
    H　　hex string(high nybble first)
    c　　符号付き1バイト数値(-128 ～ 127)
    C　　符号無し1バイト数値(0～255)
    s　　符号付きshort数値(通常2バイト)
    S　　符号無しshort数値(通常2バイト)
    i　　符号付きint数値(通常4バイト)
    I　　符号無しint数値(通常4バイト)
    l　　符号付きlong数値(通常4バイト)
    L　　符号無しlong数値(通常4バイト)
    n　　short数値(ネットワークバイトオーダ)
    N　　long数値(ネットワークバイトオーダ)
    x　　ヌル文字
    X　　back up a byte
    f　　単精度浮動小数点
    d　　倍精度浮動小数点
    p　　文字列へのポインタ
    u　　uuencodeされた文字列
    @　　絶対位置までヌル文字を埋める
EOT
  #my $out = sprintf("%s", encode('utf8', $stmts));
  print "$stmts\n";
}

my $csv_file = shift;
my $out_file = shift;
open(CSV, "<$csv_file") or die "$csv_file can't open."; 
open(OUT, ">$out_file") or die "$out_file can't open."; 

my $format_row = 0;
my @formats = ();

my $records = []; # 空の配列へのリファレンス
while(<CSV>) {
  chomp($_);
  my $line = decode('utf8', $_);  # decodeがないと、encodeでSJISにならない。
  if ($line =~ /^#/) {            # コメント行
    next;
  }
  if ($format_row == 0) {
    $format_row = 1;
    #@formats = split(/\t+/, $line);
    @formats = split(/,/, $line);
    #foreach my $i (@formats) {
    #  print "[$i]\n";
    #}
    next;
  }
  #my @record = split(/\t+/, $line);
  my @record = split(/,/, $line);
  #print "@record\n";

  $line = "";
  my $no = 0;
  foreach my $i (@formats) {
    $line .= pack($i, encode('shiftjis', $record[$no++]));
  }
  print OUT "$line\n";
}
close(OUT);
close(CSV);

exit(0);
