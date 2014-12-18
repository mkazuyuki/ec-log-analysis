#!/usr/bin/perl -w

$pwd = `pwd`;
chdir("/home/kaz/Project/loganalysis/windows/Parse-Evtx-1.1.1/lib");
$CMD = "./evtxdump.pl " . $ARGV[0] ."|";
chdir($pwd);

open (IN, $CMD);
while (<IN>) {
	if(/TimeCreated SystemTime/){
		$time = $_;
	}
	if (/Windows Event Log/) {
		$_ = <IN>;
		if(/実行中/){
			print "PowerON  " . $time;
		} else {
			print "PowerOFF " . $time;
		}	
	}
}

