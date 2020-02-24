#
#          Copyright (c) 2008, Scientific Toolworks, Inc.
#
# This file contains proprietary information of Scientific Toolworks, Inc.
# and is protected by federal copyright law. It may not be copied or
# distributed in any form or medium without prior written authorization
# from Scientific Toolworks, Inc. 
#


package Understand::Parser;
use strict;
sub base { return "Parser"; }
sub kind { return "Parser"; }


#
# Virtual methods to be implemented by new code
#

# Return the parser name.
sub name {
    return undef;
}


# Parse a file.
sub parse {
    my $file = shift;
    my $text = shift;
}


#
# Callable methods:
#

#  $file->entity(kind,name [,longname])
#    kind =
#      "function"
#      "type"
#      "variable"
#      "parameter"

#  $entity->reference(kind,entity [,line [,column]])
#    kind =
#      "define"
#      "typed"
#      "call"
#      "use"
#      "set"

