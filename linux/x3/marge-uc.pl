#!/usr/bin/perl -w

use Time::Local 'timelocal';
my ($sec, $min, $hour, $mday, $month, $year, $wday, $stime);
if ($#ARGV != 0){
	print("Error : Input root of log directories.\n");
	exit 1;
}

opendir(IN, $ARGV[0]);
@files = readdir(IN) or die ("Error : Could not open directory");
closedir(IN);

my $tab="\t";
my $timedelta = 60 * 60;
my $adjust = 0;

foreach $file (sort @files){
	if(($file =~ /^\./) or -f $file){
		print "[D]$file\n";
		next;
	} else {
		#print "[D]\t$_\n";	# Directory check by -d could not determin the directory as a directory.
		print "[D] $ARGV[0]/$file/log/alert.log.cur\n";
		open(IN, "$ARGV[0]/$file/log/alert.log.cur") or die "[E] Not found: $ARGV[0]/$file/log/alert.log.cur";
		while(<IN>){
			if ((!/^.\s\d\d\//) || (/not exist, now create it./)){next;}
			if (!/.* save alert to local file:/){next;}
			chop;
			s/.* save alert to local file://;
			@tmp = split(/[\s,]/);
			$mdate	= shift(@tmp);
			$mtime	= shift(@tmp);
			$mod	= shift(@tmp);
			shift(@tmp);
			$lvl	= shift(@tmp);
			$msg	= join(' ', @tmp);
			if ($lvl == 1) { $lvl = "ERR " }
			elsif ($lvl == 2) { $lvl = "WARN" }
			elsif ($lvl == 3) { $lvl = "INFO" };

	$year = $month = $mday = $hour = $min = $sec = $msec = "$mdate $mtime";
	$year	 =~ s/^(.{4}).*/$1/;
	$month =~ s/^.{5}(.{2}).*/$1/;
	$mday	=~ s/^.{8}(.{2}).*/$1/;
	$hour	=~ s/^.{11}(.{2}).*/$1/;
	$min 	=~ s/^.{14}(.{2}).*/$1/;
	$sec 	=~ s/^.{17}(.{2}).*/$1/;
	$msec	=~ s/^.{20}(.{3}).*/$1/;
	$month	-= 1;
	$year	-= 1900;

	#printf("$epoch %d/%02d/%02d %02d:%02d:%02d.%03d\t", $year+1900, $month+1, $mday, $hour, $min, $sec, $msec);
	$epoch = timelocal($sec, $min, $hour, $mday, $month, $year);

	$epoch -= $timeadjust;

	($sec, $min, $hour, $mday, $month, $year, $wday, $stime) = localtime($epoch);
	#printf("$epoch %d/%02d/%02d %02d:%02d:%02d.%03d\n", $year+1900, $month+1, $mday, $hour, $min, $sec, $msec);
	$date = sprintf("%d/%02d/%02d %02d:%02d:%02d.%03d", $year+1900, $month+1, $mday, $hour, $min, $sec, $msec);

			#$line = sprintf("$mdate $mtime $file $lvl %7s $tab$msg\n", $mod);
			$line = sprintf("$date $file $lvl %7s $tab$msg\n", $mod);
			push @lines, $line;
		}
		close(IN);
	}
	$tab .= "\t";
	$timeadjust += $timedelta;
}

use Time::Local qw( timelocal );
my $init = 0;
my $timeprev;
my $timecurr;
foreach $line (sort @lines){
	chop $line;
	$year = $month = $mday = $hour = $min = $sec = $line;
	if ("/" =~ /^.../) {
		# 3文字目までに / があれば、YY/MM/DD の書式
		$year	=~ s/^(.{2}).*/$1/;
	}else{
		# 3文字目までに / がなけば、YYYY/MM/DD の書式
		$year	=~ s/^(.{4}).*/$1/;
	}
	#print "[D] $year\n";
	$month	=~ s/^.{5}(.{2}).*/$1/;
	$mday	=~ s/^.{8}(.{2}).*/$1/;
	$hour	=~ s/^.{11}(.{2}).*/$1/;
	$min	=~ s/^.{14}(.{2}).*/$1/;
	$sec	=~ s/^.{17}(.{2}).*/$1/;
	$month	-= 1;
	$year	-= 1900;

	# printf("%d/%02d/%02d %02d:%02d:%02d.000\n", $year+1900, $month+1, $mday, $hour, $min, $sec);

	$timecurr = timelocal( $sec, $min, $hour, $mday, $month, $year );

	if(!$init){

		if ($sec > 59) {print "[D] $sec, $min, $hour, $mday, $month, $year \n";}
		
		# $timeprev = timelocal( $sec, $min, $hour, $mday, $month, $year );
		$timeprev = timelocal( 0, $min, $hour, $mday, $month, $year );
		$timeprev += 60;
		$init = 1;
	}

	while($timecurr > $timeprev){
		my($sec, $min, $hour, $mday, $month, $year, $wday, $yday, $isdst) = localtime($timeprev);
		# printf("$timeprev : $timecurr : %d/%02d/%02d %02d:%02d:%02d.000\n", $year+1900, $month+1, $mday, $hour, $min, $sec);
		printf("%d/%02d/%02d %02d:%02d:%02d.000\n", $year+1900, $month+1, $mday, $hour, $min, $sec);
		if     ($timecurr - $timeprev > 60*60*24){
			eval{
				$timeprev = timelocal(0, 0, 0, $mday+1, $month, $year);
			};
			if($@){
				$timeprev += 60*60*24;
			}
		} elsif($timecurr - $timeprev > 60*60){
			eval{
				$timeprev = timelocal(0, 0, $hour+1, $mday, $month, $year);
			};
			if($@){
				$timeprev += 60*60;
			}
		} else {
			eval{
				$timeprev = timelocal(0, $min+1, $hour, $mday, $month, $year);
			};
			if($@){
				$timeprev += 60;
			}
		}
	}
	print $line . "\n";
}
