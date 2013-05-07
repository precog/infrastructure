#!/usr/bin/env perl
#use strict;    # turn on compiler restrictions
use LWP::Simple;

my $file  = "";  my @field   = ();
my $num_args = $#ARGV +1;
if ($num_args < 3) {
# SHould be at least 2 variables... Server & JBoss Node1
  print "\nUsage: check_hastats.pl [servername] [port] [proxy-name] [warn] [critical] \n Only $num_args was supplied...\n";
  exit;
}else
{
	 $mServer = $ARGV[0]; $mPort = $ARGV[1];
	 $specific_line = $ARGV[2];
	 $mWARN = $ARGV[3]; $mCRIT = $ARGV[4];
}
my $browser = LWP::UserAgent->new;
 my @ns_headers = (  'Accept-Charset' => 'iso-8859-1,*,utf-8',
   'Authorization' => 'Basic YWRtaW46YWJjMTIz' );

my $mFile = "/tmp/inha.stats";
my $url = "http://$mServer:$mPort/haproxy/stats;csv";
my $content = $browser->get($url, @ns_headers);  die "Couldn't get $url" unless defined $content;
open (MYFILE, "> $mFile");
print MYFILE $content->content;
close (MYFILE);

open( INFILE, $mFile )  or die("Can not open input file: $mFile");
my $mStats ="";   my $mWarnOk=0;
my $mPerfs ="|";  my $mHitCrit=0;
my $mAlert = "All Slaves OK:";

while ( $file = <INFILE> ) {
    @field = parse_csv($file);
    chomp(@field);
		
    if ( ($field[0] eq $specific_line ) && !($field[1] eq "BACKEND") ) {
	my ($servername) = $field[1] =~ /^([^.]*)/;
        $mStats = "$mStats $servername=$field[4]";
        if ($mPerfs eq "|") {
		$mPerfs = "$mPerfs $servername=$field[4]";
	} else {
		$mPerfs = "$mPerfs, $servername=$field[4]";
	}
	#if (!($field[1] eq "FRONTEND") ) {
        	  if (($field[4] > $mWARN) && ($mHitCrit==0)) {  $mAlert ="Slave Overload:";
        	  	 $mWarnOk=1;
			 if ($field[4] > $mCRIT) {
				 $mAlert ="Slave CRITICAL:";
				 $mHitCrit=1;
				 $mWarnOk=2;
			 }
        	  }
	  #}
    }
}
close(INFILE);
unlink($mFile);
print "$mAlert $mStats $mPerfs\n";
exit $mWarnOk;


sub parse_csv {
    my $text = shift;
    my @new  = ();
    push( @new, $+ ) while $text =~ m{
       "([^\"\\]*(?:\\.[^\"\\]*)*)",?
           |  ([^,]+),?
           | ,
       }gx;
    push( @new, undef ) if substr( $text, -1, 1 ) eq ',';
    return @new;
}
