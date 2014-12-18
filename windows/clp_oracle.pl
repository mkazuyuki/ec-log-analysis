#! /usr/bin/perl -w

@lines =();
while(<STDIN>){
	chomp;
	push @lines, $_;
}

foreach my $idx (0 .. $#lines) {
	if ($lines[ $idx ] =~ m/Logging Start/){
		my $flag = 0;
		$time1 = $pid = $lines[ $idx ];
		$pid =~ s/^(.*?\s){3}(.+?)\s.*$/$2/;
		$time1 =~ s/^(.*?\s)(.*?\s.*?)\s.*$/$2/;
		#print("[D] ". $time . "\n");
		for my $idx2 ($idx .. $#lines) {
			if (($lines [ $idx2 ] =~ m/$pid/) &&
				($lines [$idx2] =~ m/dchydb01/)){
				$flag = 1;
				last;	
			}
			if (($lines [ $idx2 ] =~ m/$pid/) &&
				 ($lines [$idx2] =~ m/Logging Stop/)){
				$time2 = $lines[$idx2];
				$time2 =~ s/^(.*?\s)(.*?\s.*?)\s.*$/$2/;
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

