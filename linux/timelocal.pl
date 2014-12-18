#!/usr/bin/perl -w
use Time::Local qw ( timelocal );

my $now = time();
my $now2;

print "now\t: $now\n";
print ''.localtime($now)."\n";
print localtime($now)."\n";

my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($now);
printf("localtime\t: %d/%02d/%02d %02d:%02d:%02d.000\n", $year+1900, $mon+1, $mday, $hour, $min, $sec);

$timeprev = timelocal( $sec, $min, $hour, $mday, $mon, $year );
print "timelocal\t: $timeprev\n";
