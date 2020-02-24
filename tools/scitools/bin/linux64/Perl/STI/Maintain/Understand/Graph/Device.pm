#
#          Copyright (c) 2005, Scientific Toolworks, Inc.
#
# This file contains proprietary information of Scientific Toolworks, Inc.
# and is protected by federal copyright law. It may not be copied or
# distributed in any form or medium without prior written authorization
# from Scientific Toolworks, Inc. 
#


package Understand::Graph::Device;
use strict;
sub base { return "Graph::Device"; }
sub kind { return "Graph"; }
sub default_active { return 1; }


#
# Virtual methods to be implemented by new code
#

# Required; return the graph name.
sub name {
    return undef;
}


# Required; return the graph description.
sub description {
    return undef;
}


# Optional; indicate if this graph is available or valid for an entity.
#  Return -1 to indicate it is not an entity graph.
#  Return 0 to indicate it is an entity graph, but is not defined for this entity.
#  Return 1 to indicate it is defined and has content for this entity.
sub test_entity {
    my $entity = shift;
    return -1;
}


# Optional; indicate if this graph is available or valid as a global graph.
#  Return -1 to indicate it is not a global graph.
#  Return 1 to indicate it is a global graph.
sub test_global {
    return -1;
}


# Optional; return array of options.
#  Each array element must be a hash reference, with these keys supported:
#    name    => string name of option.
#    values  => reference of array of option string values; default is ("off","on").
#    default => default string value; default is first values.
#    action  => behavior on option change; "layout" or "load"; default is "layout".
sub define_options {
    return ();
}


# Optional; indicate if the gui should allow a user abort.
sub support_abort {
    return 0;
}


# Optional; called when the user requests an abort in Gui.
sub abort {
    my $graph = shift;
}


# Optional; indicate if the gui should display a progress meter.
sub support_progress {
    return 0;
}


#
# Callable Device members:
#   Begin(width,height)
#   DrawEllipse(x,y,rx,ry,pen[,bgcolor]
#   End
#   DrawLine(array of (x,y),pen)
#   DrawPolygon(array of (x,y),pen[,bgcolor]
#   DrawRectangle(x1,y1,x2,y2[,radius],pen[,bgcolor]
#   DrawText(x,y,text)
#   LookupColor(name or r,g,b), return color
#   LookupFont(name[,size[,style]], return font
#   LookupPen(color[,style[,width]], return pen
#   LookupText(string,font,color[,bgcolor]), return text
#


1;
__END__
