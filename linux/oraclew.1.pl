#! /usr/bin/perl -w

# USAGE:
#
# $ cat oraclew.log.cur oraclew.log.pre | ~/Project/loganalysis/linux/oraclew.pl
#

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
			print $time1 . "\t". $time2 ."\n";
		}
	}
}

