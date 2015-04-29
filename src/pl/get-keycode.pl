#!/usr/bin/perl
# http://www2u.biglobe.ne.jp/~MAS/perl/waza/hitanykey.html
use strict;
use warnings;
use Term::ReadKey;
use Time::HiRes;

print "Hit Any Key:";
my $key;
while (not defined ($key = ReadKey(-1))) {
    Time::HiRes::sleep(0.1);
}
printf "\ninput key is [%s][%d]\n", $key, ord $key;
