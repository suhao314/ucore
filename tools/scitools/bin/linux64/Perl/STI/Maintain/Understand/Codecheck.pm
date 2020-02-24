#
#          Copyright (c) 2005-2011, Scientific Toolworks, Inc.
#
# This file contains proprietary information of Scientific Toolworks, Inc.
# and is protected by federal copyright law. It may not be copied or
# distributed in any form or medium without prior written authorization
# from Scientific Toolworks, Inc.
#


use Understand;
use Understand::Option;

package Understand::Codecheck;
use strict;
sub base { return "Codecheck"; }
sub kind { return "Codecheck"; }


#
# Virtual methods to be implemented by new code
#


# Return the unique codecheck name or names supplied by this script.
sub name {
  return undef;
}


# Return a brief textual description of the codecheck.
sub description {
  return undef;
}


# Return a detailed textual description of the codecheck.
sub detailed_description {
  return undef;
}


# Return true if codecheck is valid for this entity. If entity is undefined,
# return true if codecheck is valid for entities, in general.
sub test_entity {
  my $entity = shift;
  return 0;
}


# Return true if codecheck is a global check.
sub test_global {
  return 0;
}


# Return true if codecheck is designed for the language specified.
# Language values: Ada, C++, C#, Fortran, Java, Jovial, Pascal,
#   PL/M, Web, VHDL
sub test_language {
  my $language = shift;
  return 1;
}


# Define options, via the option() method.
sub define_options {
    my $check = shift;
}


# Do these codechecks.
sub check {
  my $check = shift;
  my $entity = shift; # undef for a global codecheck
}


# Register all static text that should translatable. add_tr_text() is only
# when called within this function.
sub register_tr_text {
  my $check = shift;
  # $check->add_tr_text($text);
}



#
# Non-virtual methods
#

# Return the database associated with the codecheck.
sub db {
  my $check = shift;
  Understand::Api::object($check,"Codecheck","db");
}


# Add translatable text, only valid when called within register_tr_text.
sub add_tr_text {
  my $check = shift;
  my $text = shift;
  Understand::Api::object($check,"Codecheck","add_tr_text",$text);
}


# Return the list of all files selected for a global check.
sub get_files {
  my $check = shift;
  Understand::Api::object($check,"Codecheck","get_files");
}


# Return true if the user has requested an abort.
sub is_abort {
  my $check = shift;
  Understand::Api::object($check,"Codecheck","is_abort");
}


# Access the option object associated with the codecheck. This object provides
# access to the following methods to create options and lookup values:
#     option->checkbox($name,$text,$default) - create a checkbox option
#     option->checkbox_horiz($name,$text,@choices,@defaults) - create a
#         horizontal group of checkbox options
#     option->checkbox_vert($name,$text,@choices,@defaults) - create a
#         vertical group of checkbox options
#     option->choice($name,$text,@choices,$default) - create a choice option
#     option->file($name,$text,$default) - create a file choice option
#     option->integer($name,$text,$default) - create an integer option
#     option->radio_horiz($name,$text,@choices,$default) - create a horizontal
#         radio button option
#     option->radio_vert($name,$text,@choices,$default) - create a vertical
#         radio button option
#     option->text($name,$text,$default) - create a text option
#     option->lookup($name) - lookup the value or values for an option
sub option {
  my $check = shift;
  Understand::Option->new($$check);
}


# Issue a violation warning. Allow additional arguments to replace %1, %2, etc.
sub violation {
  my $check = shift;
  my $entity = shift; # specify 0 if none
  my $file = shift;   # specify 0 if none
  my $line = shift;   # specify -1 if none
  my $column = shift; # specify -1 if none
  my $text = shift;
  my @text_args = @_; # optional args to replace %1, %2,... in $text
  Understand::Api::object($check,"Codecheck","violation",$entity,$file,$line,$column,$text,@text_args);
}


# Issue a warning, with an entity context. The file, line and column of the
# violation are optional.
sub entity_violation {
  my $check = shift;
  my $text = shift;
  my $entity = shift;
  my $file = @_? shift: 0; # optional
  my $line = @_? shift: -1; # optional
  my $column = @_? shift: -1; # optional
  Understand::Api::object($check,"Codecheck","violation",$entity,$file,$line,$column,$text);
}


# Issue a warning, with no entity context. The file, line and column of the
# violation are optional.
sub global_violation {
  my $check = shift;
  my $text = shift;
  my $file = @_? shift: 0; # optional
  my $line = @_? shift: -1; # optional
  my $column = @_? shift: -1; # optional
  Understand::Api::object($check,"Codecheck","violation",0,$file,$line,$column,$text);
}


1;
__END__
