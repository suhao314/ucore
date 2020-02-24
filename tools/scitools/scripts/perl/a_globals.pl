#
# Sample Understand perl API program 
#
# Synopsis:   Reports all Ada global variables and any references to them.
#
# Categories: Project Report, Coding Standards
#
# Languages: Ada
#
# Usage:
sub usage ($)
{
    return << "END_USAGE";
${ \( shift @_ ) }
Usage: a_globals -db database [-body] [-out file]
        -db database   Specify Understand database (required for 
                       uperl, inherited from Understand)
	-out file      Specify output file instead of stdout (optional)
	-body          Include globals defined in the package body
END_USAGE
}

# Description:
#   Reports all global variables (objects, constants, tasks, exceptions)
#   and any references to them.
#   Note: long type strings are truncated to $max_type_len (256)
#   Requires an existing Understand for Ada database
#   Standard library entities are ignored
#
#  For the latest Understand perl API documentation, see 
#      http://www.scitools.com/perl/
#  Refer to the documenation for details on using the perl API 
#  with Understand and for details on all Understand perl API calls.
# 
#  08-Jan-2001 TLB
#  03-Aug-2001 DLL - updated for Understand::Gui::db()
#  15-Jul-2004 DLL - added -body globals option at customer request
#
use Understand;
use Getopt::Long;
use strict;

    
# get command line args 
my $dbPath;
my $outFile;
my $bodyOpt;
my $help;
GetOptions(
	   "db=s"  => \$dbPath,
           "out=s" =>\$outFile,
           "body!" =>\$bodyOpt,
	   "help" => \$help,
);

# help message
die usage("") if ($help);

# open the database 
my $db=openDatabase($dbPath);

# check language
if ( $db->language() !~ "Ada" ) {
    die "This script is designed for Ada only\n";
}

# use optional output file
if ($outFile) {
    open(RPT, "> $outFile") or die "Can't open output file $outFile: $!\n";
    print "Writing output to $outFile\n";
    select(RPT);
}

my $max_type_len = 256;

# report all global variables and their references
my @globals;
if ( $bodyOpt ) {
    @globals = $db->ents("Object, Constant, Exception");
}
else {
    @globals = $db->ents("Object ~Local, Task ~Local, Constant ~Local, Exception ~Local");
}

foreach my $obj (sort {lc($a->longname()) cmp lc($b->longname());} @globals) 
{
    # skip std library entities
    next if ($obj->library() eq "Standard");

    # skip those that aren't declared in a package 
    next if ( $bodyOpt && !$obj->refs("declarein", "package"));

    print ( "\n".$obj->longname());
    # report objects type, if any (truncate if excessive length)
    if ($obj->type()) {
	if (length($obj->type()) > $max_type_len) { 
	    printf("  (%.*s...)", $max_type_len, $obj->type());
	}
	else {  
	    print("  (".$obj->type().")");
	}
    }
    print ("\n");
    
    # print each usage of the global var
    foreach my $ref ($obj->refs())
    {
	print ("    ".$ref->kindname().": ".$ref->ent()->name()
	       ." \t[File: ".$ref->file()->longname()
	       ." Line: " .$ref->line()."]\n");
    }
}

close(RPT) if $outFile;
closeDatabase($db);


# subroutines



sub openDatabase($)
{
    my ($dbPath) = @_;
    
    my $db = Understand::Gui::db();

    # path not allowed if opened by understand
    if ($db&&$dbPath) {
	die "database already opened by GUI, don't use -db option\n";
    }

    # open database if not already open
    if (!$db) {
	my $status;
	die usage("Error, database not specified\n\n") unless ($dbPath);
	($db,$status)=Understand::open($dbPath);
	die "Error opening database: ",$status,"\n" if $status;
    }
    return($db);
}

sub closeDatabase($)
{
    my ($db)=@_;

    # close database only if we opened it
    $db->close() if ($dbPath);
}


# get declarein reference of specified entity
# there may be several, so get "best"
sub getDeclareinRef 
{
   my ($ent) =@_;
   return () unless defined($ent);
   
   my @decl=();
   my @declOrder = ("declarein ~spec ~body ~instance ~formal ~incomplete ~private ~stub",
                 "spec declarein",
                 "body declarein",
                 "instance declarein",
                 "formal declarein",
                 "incomplete declarein",
                 "private declarein",
                 "stub declarein");
           
   foreach my $type (@declOrder)
   {
      @decl = $ent->refs($type);
      if (@decl) { last;  }
   }
   return @decl;
}
