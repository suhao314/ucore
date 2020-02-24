#
#          Copyright (c) 2005-2013, Scientific Toolworks, Inc.
#
# This file contains proprietary information of Scientific Toolworks, Inc.
# and is protected by federal copyright law. It may not be copied or
# distributed in any form or medium without prior written authorization
# from Scientific Toolworks, Inc.
#


package Understand::Graph::Gv;
use strict;
sub base { return "Graph::Gv"; }
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
    my $db = shift;
    return -1;
}


# Optional; called once at graph creation. This is the only time options
# may be defined.
sub init {
    my $graph = shift;
}


# Load graph. Create nodes/edges.
sub do_load {
    my $graph = shift;
    my $entity = shift; # undef for a global graph
}


# Optional; indicate if the gui should allow a user abort.
sub support_abort {
    return 0;
}


# Optional; called when the user requests an abort in Gui.
sub abort {
    my $graph = shift;
}


#
# Callable Graph methods:
#   cluster([label]) - create a cluster subgraph.
#   db() - return the open db.
#   default(name,value[,kind]) - set an attribute default.
#   edge(node,node[,label[,ref]]) - create edge between two nodes.
#   node() - create unnamed, unlabeled node.
#   node(entity[,label]) - create a node associated with an antity.
#   node([label]) - create a node.
#   options - return an options object for the graph.
#   progress(percent [,text]) -
#   set(name,value) - set an attribute.
#   subgraph() - create a subgraph.
#   yield() - yield time to the UI
#
# Callable Node methods:
#   set(name,value) - set an attribute.
#   sync(fileentity [,line[,column]]) - set sync file, line and column
#   sync(ref)
#
# Callable Edge methods:
#   set(name,value) - set an attribute.
#   sync(fileentity [,line[,column]]) - set sync file, line and column
#   sync(ref)
#
# Callable Options methods:
#   define(name,values,default) - define a new option
#   lookup(name) - return the value for an option
#
# Graph attributes:
#   bgcolor   - cluster background color.
#
# Node attributes:
#   fillcolor - fill color of node.
#   color     - line color of node.
#   entity
#   font
#   fontcolor
#   fontsize
#   label
#   shape
#
# Edge attributes:
#   color
#


1;
__END__
