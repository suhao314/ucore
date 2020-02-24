#
#          Copyright (c) 2002-2013, Scientific Toolworks, Inc.
#
# This file contains proprietary information of Scientific Toolworks, Inc.
# and is protected by federal copyright law. It may not be copied or
# distributed in any form or medium without prior written authorization
# from Scientific Toolworks, Inc.
#


use Understand;
use Understand::Option;

package Understand::IReport;
use strict;
sub base { return "IReport"; }
sub kind { return "Interactive Report"; }
sub default_active { return 1; }


#
# Virtual methods to be implemented by new code
#


# Required; return the report name.
sub name {
    return undef;
}


# Required; return the report description.
sub description {
    return undef;
}


# Optional; indicate if this report is available or valid for an architecture.
#  Return -1 to indicate it is not an architecture report.
#  Return 0 to indicate it is an architecture report, but is not defined for this architecture.
#  Return 1 to indicate it is defined for the architecture.
sub test_architecture {
    my $arch = shift;
    return -1;
}


# Optional; indicate if this report is available or valid for an entity.
#  Return -1 to indicate it is not an entity report.
#  Return 0 to indicate it is an entity report, but is not defined for this entity.
#  Return 1 to indicate it is defined for the entity.
sub test_entity {
    my $entity = shift;
    return -1;
}


# Optional; indicate if this report is available as a global report;
# that is, it is not generated for a single specific entity.
#  Return -1 to indicate it is not a global report.
#  Return 1 to indicate it is a globl report.
sub test_global {
    my $db = shift;
    return -1;
}


# Optional; called once at report creation.
sub init {
    my $report = shift;
}


# Required; generate report.
sub generate {
    my $report = shift;
    my $entity = shift; # undef for a global or architecture report.
    my $arch   = shift; # undef unless architecture report.
}


# Optional; indicate if this report supports the abort method().
#  Return 0 to indicate no support.
#  Return 1 to indicate support.
sub support_abort {
    return 0;
}


# Optional; called when the user requests an abort in Gui.
sub abort {
    my $report = shift;
}


# Optional; indicate if this report supports the progress bar().
#  Return 0 to indicate no support.
#  Return 1 to indicate support.
sub support_progress {
    return 0;
}


# Optional; indicate if the options window should be displayed
# initially, before a report is generated.
#  Return -1 to indicate this should be user controlled by a checkbox option.
#  Return 0 to indicate it should not be displayed.
#  Return 1 to indicate it should be displayed.
sub show_initial_options {
    return -1;
}



#
# Non-virtual methods
#

# Return a new report object.
# This must not be overriden by the subclass.
sub new {
    my ($caller,$report) = (@_);
    my $class = ref($caller) || $caller;
    bless \$report, $class;
}


# Access the option object associated with the report.
# This must not be overriden by the subclass.
sub option {
    my $report = shift;
    Understand::Option->new($$report);
}


# Return the database associated with the report.
# This must not be overriden by the subclass.
sub db {
    my $report = shift;
    Understand::Api::object($report,"IReport","db");
}


# Set the background color for the entire report, or reset it to the default
# if $rgb is not specified.
sub bgcolor {
    my $report = shift;
    my $rgb = shift;
    Understand::Api::object($report,"IReport","bgcolor",$rgb);
}

# Enable bold mode for following text. Use nobold() to disable.
sub bold {
    my $report = shift;
    my $mode = shift; # deprecated
    Understand::Api::object($report,"IReport","bold",$mode);
}

# Set the entity for right-click actions for following text, or disable
# the previously set entity if $entity is not specified.
sub entity {
    my $report = shift;
    my $entity = shift;
    Understand::Api::object($report,"IReport","entity",$entity);
}

# Set the font background color for following text, or reset it to the
# default if $rgb is not specified.
sub fontbgcolor {
    my $report = shift;
    my $rgb = shift;
    Understand::Api::object($report,"IReport","fontbgcolor",$rgb);
}

# Set the font color for following text, or reset it to the default
# if $rgb is not specified.
sub fontcolor {
    my $report = shift;
    my $rgb = shift;
    Understand::Api::object($report,"IReport","fontcolor",$rgb);
}

# Set the hover text for following text, or disable the previously
# set hover text if $text is not specified.
sub hover {
    my $report = shift;
    my $text = shift;
    Understand::Api::object($report,"IReport","hover",$text);
}

# Enable Italic mode for following text. Use noitalic() to disable.
sub italic {
    my $report = shift;
    my $mode = shift; # deprecated
    Understand::Api::object($report,"IReport","italic",$mode);
}

# Disable bold mode if it is currently enabled.
sub nobold {
    my $report = shift;
    Understand::Api::object($report,"IReport","nobold");
}

# Disable italic mode if it is currently enabled.
sub noitalic {
    my $report = shift;
    Understand::Api::object($report,"IReport","noitalic");
}

# Text to display (print), including newlines.
sub print {
    my $report = shift;
    my $text = shift;
    Understand::Api::object($report,"IReport","print",$text);
}

# Indicate percent progress towards completion, 0..100.
sub progress {
    my $report = shift;
    my $progress = shift;
    my $text = shift;
    Understand::Api::object($report,"IReport","progress",$progress,$text);
}

# Set the file/line/column to single-click-sync, for following text, or
# disable the previously set sync if no file is specified.
sub syncfile {
    my $report = shift;
    my $file = shift;
    my $line = shift;
    my $column = shift;
    Understand::Api::object($report,"IReport","syncfile",$file,$line,$column);
}

# Create a new tree control, add a node to an existing tree control, or
# end the existing tree control, depending on the value of $level. If
# $level is 0 or is not specified, end the current tree control and issue
# a newline if not currently at the beginning of the line. If $level is
# greater than 0, issue a newline if not currently at the beginning of
# the line, and create a tree control of the specified level, where a
# level of 1 represents the top node of a tree. All text following a
# tree node, including newlines, belongs to that node. If $state is true
# the node will begin in the open state, or if $state is false or not
# specified, the node will begin in the closed state.
sub tree {
    my $report = shift;
    my $level = shift;
    my $state = shift;
    Understand::Api::object($report,"IReport","tree",$level,$state);
}


1;
__END__
