#
#  Synopsis: Lists functions and external functions/variables used within them.
#  
# Categories: Project Report
#
# Languages: C
#
# Usage:
sub usage ($)
{
    return << "END_USAGE";
${ \( shift @_ ) }
Usage: C_functionIO.pl -db database
  -db database      Specify Understand database (required for
	            uperl, inherited from Understand)
END_USAGE
}

#  For the latest Understand perl API documentation, see 
#      http://www.scitools.com/perl.html
# 


use Understand;
use Getopt::Long;
use strict;

my $dbPath;
my $threshold;
my $help;
GetOptions(
	   "db=s" => \$dbPath,
	   "help" => \$help,
          );

# help message
die usage("") if ($help);

# open the database 
my $db=openDatabase($dbPath);

#check to make sure valid language

if ( $db->language() !~ "C" ) {
    die usage("This script is designed for C only\n");
}


# get a list of subroutines, functions, subprograms, and 
# main programs from the database. Exclude intrinsics.
# sort the list on the longname.

my @funcs = sort {$b->longname() <=> $a->longname();} $db->ents("Function ~unresolved");
my $func;

foreach $func (@funcs)
{
    my $funcdef;

    #if the function has a definition, print it out
    # in a double click visitable form (File: Line:)

    if ($funcdef = $func->ref("definein"))
    {
      print $func->kindname() . " " . $func->name() . " \n\tFile: " . $funcdef->file()->longname() . " Line: " . $funcdef->line() . "\n";
    }

    my $refType;
    my $entKind;
  
    $refType = "Set";
    $entKind = "";
        
    # Now for this function get a list of all entities that are
    # changed by it

    my @ents;
    my $first = 1;
    
    @ents = $func->ents($refType,$entKind);
    
    foreach my $var (@ents)
    {

       #if external variable, report it
      
       my $vardef;
       if ($vardef = $var->ref("definein"))  #find the definition
       {
         if ($var->ref("definein")->ent()->id() == $funcdef->ent->id())
         {
           # if first external found, print the header
           if ($first) 
           {  
             print $refType . "s: \n";
             $first = 0;
            }

           print "\t" . $var->kindname() . " " . $var->longname() . "\n";
           print "\t\tFile:" . $vardef->file()->longname() . " Line: " . $vardef->line() . "\n";
         } 
       }
     }
    
    $refType = "Use";
    $entKind = "";
     
    # Now for this function get a list of all entities that are
    # changed by it

    my @ents;
    my $first = 1;
    
    @ents = $func->ents($refType,$entKind);
    
    foreach my $var (@ents)
    {

       #if external variable, report it
      
       my $vardef;
       if ($vardef = $var->ref("definein"))  #find the definition
       {
         if ($var->ref("definein")->ent()->id() == $funcdef->ent->id())
         {
           # if first external found, print the header
           if ($first) 
           {  
             print $refType . "s: \n";
             $first = 0;
            }

           print "\t" . $var->kindname() . " " . $var->longname() . "\n";
           print "\t\tFile:" . $vardef->file()->longname() . " Line: " . $vardef->line() . "\n";
         } 
       }
     }
    
    $refType = "Call";
    $entKind = "~unresolved";
     
    # Now for this function get a list of all entities that are
    # changed by it

    my @ents;
    my $first = 1;
    
    @ents = $func->ents($refType,$entKind);
    
    foreach my $var (@ents)
    {

       #if external variable, report it
      
       my $vardef;
       if ($vardef = $var->ref("definein"))  #find the definition
       {
           # if first external found, print the header
           if ($first) 
           {  
             print $refType . "s: \n";
             $first = 0;
            }

           print "\t" . $var->kindname() . " " . $var->longname() . "\n";
           print "\t\tFile:" . $vardef->file()->longname() . " Line: " . $vardef->line() . "\n";
       }
     }
    
    print "\n\n";
    
closeDatabase($db);

}


  
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

