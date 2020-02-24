#
#          Copyright (c) 2002-2013, Scientific Toolworks, Inc.
#
# This file contains proprietary information of Scientific Toolworks, Inc.
# and is protected by federal copyright law. It may not be copied or
# distributed in any form or medium without prior written authorization
# from Scientific Toolworks, Inc.
#


package Understand::Option;
use strict;

# Class or object method. Return a new report object.
sub new {
    my ($caller,$option) = (@_);
    my $class = ref($caller) || $caller;
    bless \$option, $class;
}


sub checkbox       {my $self=shift; Understand::Api::object($self,"option","new","cb",@_);}
sub checkbox_horiz {my $self=shift; Understand::Api::object($self,"option","new","cbhor",@_);}
sub checkbox_vert  {my $self=shift; Understand::Api::object($self,"option","new","cbver",@_);}
sub choice         {my $self=shift; Understand::Api::object($self,"option","new","choice",@_);}
sub directory      {my $self=shift; Understand::Api::object($self,"option","new","directory",@_);}
sub file           {my $self=shift; Understand::Api::object($self,"option","new","file",@_);}
sub integer        {my $self=shift; Understand::Api::object($self,"option","new","int",@_);}
sub label          {my $self=shift; Understand::Api::object($self,"option","new","label",@_);}
sub lookup         {my $self=shift; Understand::Api::object($self,"option","lookup",@_);}
sub radio_horiz    {my $self=shift; Understand::Api::object($self,"option","new","radhor",@_);}
sub radio_vert     {my $self=shift; Understand::Api::object($self,"option","new","radver",@_);}
sub text           {my $self=shift; Understand::Api::object($self,"option","new","text",@_);}


1;
__END__
