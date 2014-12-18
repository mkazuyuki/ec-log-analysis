#!/usr/bin/perl -w

#
# Normarizing [hostname]/log/alt/alertlog.alt
#

my %hn = ();

open(IN, $ARGV[0]) or die;
@line = <IN>;

foreach(@line){
	if(/^\d/){
		@tmp = split(/\s+/);
		$hn{$tmp[5]}++;
	}
}

foreach(@line){
	if(/^\d/){
		chop;
		@tmp	= split(/\s+/);

		$idx	= shift(@tmp);
		$mdate	= shift(@tmp);
		$mtime	= shift(@tmp);
		#$hdate	= shift(@tmp);
		shift(@tmp);
		#$htime	= shift(@tmp);
		shift(@tmp);
		$hname	= shift(@tmp);
		$mod	= shift(@tmp);
		$eid	= shift(@tmp);
		$lvl	= shift(@tmp);
		$msg	= join(' ',@tmp);

		$tab = "";
		foreach(sort keys %hn){
			if($hname eq $_){
				$msg = $tab . $msg;
				last;
			}
			$tab .= "\t";
		}
	
		#printf "%4s %s %s %s %s %s %7s %4d %2d %s\n", $idx, $mdate, $mtime, $hdate, $htime, $hname, $mod, $eid, $lvl, $msg;
		push @lines, sprintf("%4s %s %s %s %7s %4d %2d %s\n",
			$idx, $mdate, $mtime, $hname, $mod, $eid, $lvl, $msg);
	}
}

print @lines;

