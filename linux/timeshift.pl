#!/usr/bin/perl
#
# rc.log.cur のログを60秒進めて 21年 を 2021年 で表示する
# 
# 	timeshift.pl 60 < ./rc.log.cur
#
# trnsv.log.cur のログを12秒戻して 21年 を 2021年 で表示する
# 
# 	timeshift.pl -12 < ./rc.log.cur
#
# alert.log.cur のログの 22年 2022年 で表示する
# 
# 	timeshift.pl < ./alert.log.cur
#

use Time::Local;
 
while(<STDIN>){
	chop;
	if (/^[^\d]{1,2}\d{2}\/\d{2}\/\d{2} \d\d:\d\d:\d\d\.\d\d\d/) {
		$head = $tail = $year = $month = $mday = $hour = $min = $sec = $msec = $_;
		$head  =~ s/^([^\d].*)\d\d\/\d\d\/\d\d \d\d:\d\d:\d\d\.\d{3}.*$/$1/;
		$tail  =~ s/^[^\d].*\d\d\/\d\d\/\d\d \d\d:\d\d:\d\d\.\d{3}(.*)$/$1/;
		$year  =~ s/^[^\d].*(\d\d)\/\d\d\/\d\d \d\d:\d\d:\d\d\.\d{3}.*$/$1/;
		$month =~ s/^[^\d].*\d\d\/(\d\d)\/\d\d \d\d:\d\d:\d\d\.\d{3}.*$/$1/;
		$mday  =~ s/^[^\d].*\d\d\/\d\d\/(\d\d) \d\d:\d\d:\d\d\.\d{3}.*$/$1/;
		$hour  =~ s/^[^\d].*\d\d\/\d\d\/\d\d (\d\d):\d\d:\d\d\.\d{3}.*$/$1/;
		$min   =~ s/^[^\d].*\d\d\/\d\d\/\d\d \d\d:(\d\d):\d\d\.\d{3}.*$/$1/;
		$sec   =~ s/^[^\d].*\d\d\/\d\d\/\d\d \d\d:\d\d:(\d\d)\.\d{3}.*$/$1/;
		$msec  =~ s/^[^\d].*\d\d\/\d\d\/\d\d \d\d:\d\d:\d\d\.(\d{3}).*$/$1/;
		# printf("%d/%02d/%02d %02d:%02d:%02d.%03d\n", $year, $month, $mday, $hour, $min, $sec, $msec);	

		$timecurr = timelocal( $sec, $min, $hour, $mday, ($month - 1), ($year + 100));
		$timecurr += $ARGV[0];
		($sec, $min, $hour, $mday, $month, $year, $wday, $yday, $isdst) = localtime($timecurr);
		printf("%s%d/%02d/%02d %02d:%02d:%02d.%03d%s\n", $head, $year + 1900, $month + 1, $mday, $hour, $min, $sec, $msec, $tail);
	}
}
