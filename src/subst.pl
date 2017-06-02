##############################
# This script matches and replaces specific parameters
# of a Rating call record.
#
#############################
use strict;
use warnings;
use Getopt::Std;

# globals
my $column;
my $length;
my $match;
my $newVal;

# function prototypes
sub usage();
sub showRecord();
sub showRecordMatch();
sub replaceMatching();
sub replaceAll();

# options list
my %options;
getopts("ahvi:c:l:m:n:", \%options) or die usage();

# option flags
my $aflag = $options{a};
my $cflag = $options{c};
my $hflag = $options{h};
my $iflag = $options{i};
my $lflag = $options{l};
my $mflag = $options{m};
my $nflag = $options{n};
my $vflag = $options{v};

# files variables
my $input_file = $options{i};
if ((!$iflag || !$cflag || !$lflag)){
    print usage();
    exit(1);
}
my $output_file = $input_file . "\.new";

# opening files
open(INPUT_FILE, '<', $input_file)
    or die "Cannot open '$input_file': $!";
open(OUTPUT_FILE, '>', $output_file)
    or die "Cannot open '$output_file': $!";

# reading input file
my $currLine;
while ($currLine = <INPUT_FILE>){
    if ($hflag){
        usage();
        last;
    } elsif (($cflag && $lflag && !$nflag) && !$mflag){
        showRecord();
    } elsif (($cflag && $lflag && $mflag) && !$nflag){
        showRecordMatch();
    } elsif ($nflag && !$mflag){
        replaceAll();
    } elsif ($nflag && $mflag){
        replaceMatching();
    }
}
print "\n";
# closing files
close(INPUT_FILE)
    or die "Cannot close";
close(OUTPUT_FILE)
    or die "Cannot close";

# cleaning stuff up
my $filesize = -s $output_file;
if ($filesize == 0){
    unlink($output_file);
}

# function definitions
sub usage(){
    print "\n";
    print "Usage: subst.pl -c Column -l Length\n";
    print "       subst.pl -c Column -l Length -m Match\n";
    print "       subst.pl -c Column -l Length -n New Value [-m Match]\n";
    print "\n";
}
sub showRecord(){
    $column = $options{c};
    $length = $options{l};
    my $field = substr($currLine, ($column-1), $length);
    if ($vflag){
        print $currLine;
    } else {
        print "$field\n";
    }
}
sub showRecordMatch(){
    $column = $options{c};
    $length = $options{l};
    $match  = $options{m};
    my $field = substr($currLine, ($column-1), $length);
    if ($field =~ /$match/){
        if ($vflag){
            print $currLine;
        } else {
            print "$field\n";
        }
    }
}
sub replaceAll(){
    $column = $options{c};
    $length = $options{l};
    $newVal = $options{n};
    substr($currLine, ($column-1), $length) = substr($newVal, 0, $length);
    if ($vflag){
        print $currLine;
    }
    print OUTPUT_FILE $currLine;
}
sub replaceMatching(){
    $column = $options{c};
    $length = $options{l};
    $newVal = $options{n};
    $match  = $options{m};
    if(substr($currLine, ($column-1), $length) =~ /$match/){
        substr($currLine, ($column-1), $length) = substr($newVal, 0, $length);
        if ($vflag){
            print $currLine;
        }
    }
    print OUTPUT_FILE $currLine;
}