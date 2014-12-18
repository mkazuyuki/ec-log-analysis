#! /usr/bin/perl -w

# USAGE:
#
# $ cat oraclew.log.cur oraclew.log.pre | ~/Project/loganalysis/linux/oraclew.pl
#

use Time::Local

@lines =();
while(<STDIN>){
	chomp;
	if ((/\* START/) || (/\* END/)){
		$_ =~ s/ (START )(\[.*?\] )/ $2$1/;
		$_ =~ s/ (END )(\[.*?\] )/ $2$1/;
		# print;
		#exit;
		push @lines, $_;
	}
}
@lines = sort @lines;
print "Date, Delay\n"; 
foreach my $idx (0 .. $#lines) {
	if ( $lines[ $idx ] =~ m/START/ ) {
		my $flag = 0;
		$time1 = $pid = $lines[ $idx ];
		#$pid =~ s/^(.*?\s){3}(.+?)\s.*$/$2/;
		$pid =~ s/^.*START \[(.*?):.*$/$1/;
		$time1 =~ s/^.*?\s\[(.*?)\].*$/$1/;
		#print("[D] [ ". $pid . ":" . $time1 . " ]\n");
		for my $idx2 ($idx .. $#lines) {
			#if (( $lines [ $idx2 ] =~ m/$pid/ ) &&
			#	( $lines [$idx2] =~ m/dchydb01/ )){
			#	$flag = 1;
			#	last;	
			#}
			if ($lines [ $idx2 ] =~ m/END.*$pid/){
				$time2 = $lines[$idx2];
				$time2 =~ s/^.*?\[(.*?)\].*$/$1/;
				last;
			}
		}
		if ($flag){
			next;
		} else {
			my ($begin_year, $begin_mon, $begin_mday, $begin_hour, $begin_min, $begin_sec, $begin_msec) =
				$time1 =~ /^([0-9]{4})\/([0-9]{2})\/([0-9]{2}) ([0-9]{2}):([0-9]{2}):([0-9]{2})\.([0-9]{3})$/;
			my ($end_year, $end_mon, $end_mday, $end_hour, $end_min, $end_sec, $end_msec) =
				$time2 =~ /^([0-9]{4})\/([0-9]{2})\/([0-9]{2}) ([0-9]{2}):([0-9]{2}):([0-9]{2})\.([0-9]{3})$/;

			my $begin_time = timelocal($begin_sec, $begin_min, $begin_hour, $begin_mday, $begin_mon-1, $begin_year-1900);
			my $end_time = timelocal($end_sec, $end_min, $end_hour, $end_mday, $end_mon-1, $end_year-1900);
			my $diff = "$end_time.$end_msec" - "$begin_time.$begin_msec";
			$time1 =~ s/\.\d{3}$//;
			printf "$time1,%.3f\n", $diff;
			# printf "$time1\t[ $begin_time.$begin_msec ][ $end_time.$end_msec ] %.3f\n", $diff;
			#print $time1 . "\t". "[ $begin_time.$begin_msec ][ $end_time.$end_msec ]" . $diff ."\n";
			# print $time1 . ",". $diff ."\n";
		}
	}
}

