#!/usr/bin/perl -w
# 全てのデータソースとすべてのインストール済みドライバを列挙する
#
use strict;
use DBI;
my @drivers = DBI->available_drivers();

die "No drivers found!\n" unless @drivers;

foreach my $driver(@drivers) {
  print "Driver: $driver\n";
  my @data_sources = DBI->data_sources($driver);
  foreach my $data_source (@data_sources) {
    print "\tData Source is $data_source\n";
  }
  print "\n";
}
