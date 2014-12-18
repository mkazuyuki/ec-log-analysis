#! /usr/bin/perl -w

# Oracle監視の遅延具合をチェックするために、監視処理に要した時間を出力するスクリプト
# 2014.06 高瀬物産に投入

@lines =();
while(<STDIN>){
	chomp;
	push @lines, $_;
}

foreach my $idx (0 .. $#lines) {
	if ($lines[ $idx ] =~ m/ START /){
		#my $flag = 0;
		$time1 = $pid = $lines[ $idx ];
		$pid =~ s/^(.*?\s){4}\[(.+?):.*$/$2/;
		$time1 =~ s/^(.*?\s){2}\[(.*?\s.*?)\].*$/$2/;
		#print("[D] ". $time . "\n");
		for my $idx2 ($idx+1 .. $#lines) {
			#if (($lines [ $idx2 ] =~ m/$pid/) &&
			#	($lines [$idx2] =~ m/dchydb01/)){
			#	$flag = 1;
			#	last;	
			#}
			if (($lines [ $idx2 ] =~ m/$pid/) &&
				($lines [$idx2] =~ m/ END /)){
				$time2 = $lines[$idx2];
				#$time2 =~ s/^(.*?\s)(.*?\s.*?)\s.*$/$2/;
				$time2 =~ s/^(.*?\s){2}\[(.*?\s.*?)\].*$/$2/;
				last;
			}
		}
		#if ($flag){
		#	next;
		#} else {
			print $time1 . "\t". $time2 ."\n";
		#}
	}
}

