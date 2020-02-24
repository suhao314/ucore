package Understand::VariableTracker;
use strict;

#
# This package assists in the construction of variable
# influence tracking.  The main function builds an
# influence tree for a given variable.
#

#
# Known issues:
# - Overloaded functions (constructors in particular) may not be hooked correctly 
#   between call and definition.  This appears to be in the DB.  The result is that 
#   arguments may not be tracked to parameters correctly in these cases.
# - When macros with arguments are invoked, the invocation is not hooked in the DB as a call,
#   but the lexer will parse the invocation as a call.  The result is that arguments
#   may not be tracked to parameters correctly in these cases.
#

#
# constants
#

# pass-by values
my $PB_POINTER = 'pb_pointer';
my $PB_VALUE   = 'pb_value';

# r_value type values
our $T_NONE = 't_none';
our $T_PARAMETER_FORWARD  = 't_parameter_forward';
our $T_PARAMETER_BACKWARD = 't_parameter_backward';
our $T_METHOD_FORWARD     = 't_method_forward';

#
# The tree that is build constists of "Nodes" and "Edges"
# that are hash refs with the following keys:
#
# Node attributes:
# entity => left of an edge, the entity being affected, right of an edge, the entity that affects
# text   => display text of the node
# file   => file entity of this node's occurrence
# line   => line in the file of this node's occurrence
# column => column in the file of this node's occurrence
# type   => r_value type if appropriate
#
# Edge attributes:
# left   => node to the left of the edge
# right  => node to the right of the edge
# text   => display text of the edge
# reference => reference between the two entities the edge connects
# file   => file entity of this edge's occurrence
# line   => line in the file of this edge's occurrence
# column => column in the file of this edge's occurrence
#

# global variables
our @all_nodes = ();
my $abort = 0;

sub init_all
{
  @all_nodes =();
  init_node_exists();
  init_lexer();
  init_arg_list();
  init_call();
  init_parameter_list();
}

sub new_node
{
  my ($entity, $text, $file, $line, $column, $type) = @_;
  my $node =
  {
    'entity' => $entity, # left of an edge, the entity being affected, right of an edge, the entity that affects
    'text'   => $text,   # display text of the node
    'file'   => $file,   # file entity of this node's occurrence
    'line'   => $line,   # line in the file of this node's occurrence
    'column' => $column, # column in the file of this node's occurrence
    'type'   => $type,   # r_value type
    'left_edges'  => [],  # edges to the left of this node
    'right_edges' => [],  # edges to the right of this node
  };
  push(@all_nodes, $node);
  return $node;
}

sub new_edge
{
  my ($left, $right, $text, $reference, $file, $line, $column) = @_;
  my $edge =
  {
    'left'      => $left,      # node to the left of the edge
    'right'     => $right,     # node to the right of the edge
    'text'      => $text,      # display text of the edge
    'reference' => $reference, # reference between the two entities the edge connects
    'file'      => $file,      # file entity of this edge's occurrence
    'line'      => $line,      # line in the file of this edge's occurrence
    'column'    => $column,    # column in the file of this edge's occurrence
  };
  if( $left )
  {
    push(@{$left->{'right_edges'}}, $edge);
  }
  if( $right )
  {
    push(@{$right->{'left_edges'}}, $edge);
  }
  return $edge
}


#
# Receive abort signal
#
sub abort
{
  $abort = 1;
}

# 
# Build a tree with $entity at the root.
#
sub build_tree
{
  my ($entity,               # the entity to use as the root of the tree
      $file, $line, $column, # the location of interest for this entity
      $max_depth,            # maximum depth of the tree
      $progress_func,        # if not undef, then this is a reference to the progress display function
    ) = @_;

  my $node = new_node($entity, $entity->longname(), $file, $line, $column);
  my $filename = "";
  if($file) { $filename = $file->longname(); }
  node_exists($filename, $line, $column, $entity->id());

  my @nodes = ([$node, $max_depth]);
  my $percent = 0;
  while(@nodes)
  {
    if($progress_func) { &{$progress_func}($percent); $percent ++; }
    if($abort) { last; }
    my $n = shift @nodes;
    build_tree_aux($n->[0], $n->[1], \@nodes);
  }
  return $node;
}

#
# Builds children nodes from references to objects
# that influence the value of the entity in the parent
# node.
# 
sub build_tree_aux
{
  my ($parent,    # parent node
      $max_depth, # how many levels to create
      $nodes_ref, # an array of nodes and the depth left in the tree
    ) = @_;
  $max_depth --;
  if( $max_depth <= 0 ) { return; }
  my $entity = $parent->{'entity'};
  if($entity && $entity->kind()->check("Function ~Member")) { return; }
  
  if( $parent && $entity )
  {
    # For every place where $entity is used as an l-value,
    # create a node for every r-value that influences it, then
    # do a recursive call.
    #
    # Avoid infinite recursion by not creating more than one node
    # for each lexeme.
    # Use breadth first strategy

    foreach my $ref ( $entity->refs() )
    {
      my $r_value_lexemes = []; # array of lexemes that are rvalues
      my $is_l = is_lvalue($entity, $ref, $r_value_lexemes, $parent->{'type'});
      if( $is_l > 0 )
      {
	foreach my $r_value (@{$r_value_lexemes})
	{
	  if( $r_value && $r_value->{'lexeme'} && ( ! lexeme_node_exists($r_value->{'lexeme'}) ) )
	  {
	    lexeme_set_node_exists($r_value->{'lexeme'});
 	    my $ent  = $r_value->{'lexeme'}->ent();
	    my $node = new_node($ent, $r_value->{'lexeme'}->text(),
				$ref->file(), $r_value->{'lexeme'}->line_begin(), $r_value->{'lexeme'}->column_begin(),
				$r_value->{'type'});
	    my $edge = new_edge($parent, $node, $ref->kindname(), $ref, $ref->file(), $ref->line(), $ref->column());
	    push(@{$nodes_ref}, [$node, $max_depth]);
	  }
	}
      }
    }
  }
}


# returns true if $entity can be modified as a result of this reference
#
# 1- $entity is on the left hand side of an assignment operator
#    Anything on the right hand side is returned as an rvalue
#    The expression is ended by:
#    a- a semicolon
#    b- returning to a higher level of parens
#    c- a comma at the same level or parens
#
# 2- $ref shows that $entity is an input parameter for a function
#    $r_values is set to the list of real arguments that are passed
#    to the function in the parameter's position
#
# 3- $ref shows that $entity is passed by reference into a function
#    $r_values is set to the list of r_values that modify $entity
#    in the function.
#

# @_ = ($entity, $ref, $r_values)
# $entity = entity of interest
# $ref    = reference with $entity as scope
# $r_values = [] to fill with lexemes that are rvalues from $ref
sub is_lvalue
{
  my ($entity, $ref, $r_values, $type) = @_;
  my $lvalue = -1;
  if($type ne $T_METHOD_FORWARD)
  {
    $lvalue = is_lvalue_assignment(@_);
    if($lvalue > 0) { return $lvalue; }
  }
  if(($type ne $T_PARAMETER_FORWARD) &&
     ($type ne $T_METHOD_FORWARD))
  {
    $lvalue = is_lvalue_parameter(@_);
    if($lvalue > 0) { return $lvalue; }
  }
  if(($type ne $T_PARAMETER_BACKWARD) &&
     ($type ne $T_METHOD_FORWARD))
  {
    $lvalue = is_lvalue_pass_by_pointer(@_);
    if($lvalue > 0) { return $lvalue; }
  }
  if(($type ne $T_PARAMETER_BACKWARD) &&
     ($type ne $T_METHOD_FORWARD))
  {
    $lvalue = is_lvalue_pass_by_reference(@_);
    if($lvalue > 0) { return $lvalue; }
  }
  if($type ne $T_METHOD_FORWARD)
  {
    $lvalue = is_lvalue_method_call(@_);
    if($lvalue > 0) { return $lvalue; }
  }
  if($type eq $T_METHOD_FORWARD)
  {
    $lvalue = is_lvalue_method_forward(@_);
    if($lvalue > 0) { return $lvalue; }
  }
  
  return $lvalue;
}

sub entity_string
{
  my ($e) = @_;
  return "'" . $e->longname() . " ID: " . $e->id() . " (" . $e->kind()->longname() . ")" . " {" . $e->type() . "}'";
}
sub ref_string
{
  my ($r) = @_;

  return   entity_string($r->scope()) . "'(" . $r->kind()->longname() . ") " . $r->file()->longname() . ":" . $r->line() . ":" . $r->column() ."'" .  entity_string($r->ent());
}

sub is_reference_type
{
  my ($entity) = @_;
  return ($entity->type() =~ /\&/);
}
sub is_pointer_type
{
  my ($entity) = @_;
  return ($entity->type() =~ /\*/);
}

#
# If $entity is a method, and $ref shows a data member as an lvalue, then use data member as an r_value.
#
sub is_lvalue_method_forward
{
  my ($entity, $ref, $r_values) = @_;
  my $ret = -1;

  if(!$ref->ent()->kind()->check("Member Object")) { return $ret; }

  my $reverse_reference_kind_name = "";
  if($ref->kind()->check("Set"))
  {
    $reverse_reference_kind_name = "Setby";
  }
  elsif($ref->kind()->check("Use"))
  {
    $reverse_reference_kind_name = "Useby";
  }
  else
  { # unexpected reference kind
    return $ret;
  }

  my $r_entity = $ref->ent();
  foreach my $r_ref ($r_entity->refs($reverse_reference_kind_name, $entity->kind()->longname()))
  {
    if($r_ref->ent()->id() == $entity->id())
    {
      if(is_lvalue($r_entity, $r_ref, $r_values, $T_NONE) > 0)
      {
	$ret = 1;
      }
    }
  }  
  
  return $ret;
}

#
# Find if $entity is modified by having a method called on it at the location specified by $ref
# 
#
sub is_lvalue_method_call
{
  my ($entity, $ref, $r_values) = @_;
  my $ret = -1;

  my ($lexer, $status) = get_lexer($ref->file());
  if( $status ) { return undef; } # FIXME: How do we throw an error?
  my $lexeme = $lexer->lexeme($ref->line(), $ref->column());

  my $entity_lexeme = $lexeme;
  my $method_lexeme = undef;
  my $have_dot_operator = 0;
  # advance past the entity
  $lexeme = $lexeme->next() if $lexeme;
  while ( $lexeme && !$method_lexeme )
  {
    if ( is_whitespace($lexeme) )
    { # skip
    }
    elsif( is_comment($lexeme) )
    { # skip
    }
    elsif( !$have_dot_operator &&
	   ( is_dot_operator($lexeme) ||
	     is_arrow_operator($lexeme) )
      )
    { # expect this before the method call
      $have_dot_operator = 1;
    }
    elsif( $have_dot_operator &&
	   is_identifier($lexeme) )
    { # expect this after the dot operator
      $method_lexeme = $lexeme;
    }
    else
    { # something unexpected has happened, we must not have a method call
      last;
    }
    
    $lexeme = $lexeme->next();
  }

  # check to see if $method_lexeme is a method of the class that $entity_lexeme is an instance of.
  if ( !$entity_lexeme || !$method_lexeme  ) { return $ret; }

  # get the object entity
  my $object_ent = $entity_lexeme->ent();
  if( !$object_ent || ($object_ent->id() != $entity->id()) ) { return $ret; }

  # find the type of the object
  # there should really only be one of these
  my $object_type_ent = undef;
  foreach my $type_ref ($object_ent->refs('Typed', 'Class,Struct'))
  {
    $object_type_ent = $type_ref->ent();
  }
  if ( !$object_type_ent ) { return $ret; }
  
  # get the method entity
  my $method_ent = $method_lexeme->ent();
  if( !$method_ent ) { return $ret; }

  # find the type of the method
  # there should really only be one of these
  my $method_type_ent = undef;
  foreach my $type_ref ($method_ent->refs('Declarein', 'Class,Struct'))
  {
    $method_type_ent = $type_ref->ent();
  }
  if ( !$method_type_ent ) { return $ret; }

  # make sure they are both of the same type
  if ( $method_type_ent->id() != $object_type_ent->id() ) { return $ret; }

  push(@{$r_values}, new_r_value($method_lexeme, $T_METHOD_FORWARD));
  $ret = 1;
  
  return $ret;
}

#
# Search for locations in the function $ref->ent() where the $entity is passed 
# as an actual argument in a function call, and the corresponding parameter
# is a reference parameter.
#
# $entity: the entity that we are searching for as an argument
# $ref->ent(): the function where we are searching for function calls
# $r_values: empty array reference to push lexemes of $entity being used as an actual parameter
#
#
# Algorithm:
# for all function calls in the current function
#    for all arguments to the function call
#      if the argument is the current entity and the formal parameter is a reference
#        push the lexeme of the formal parameter in the
#        function definition in the same position
#
sub is_lvalue_pass_by_reference
{
  my ($entity, $ref, $r_values) = @_;
  my $ret = -1;
  
  my $calls = get_call($ref->ent());
  foreach my $call (@{$calls})
  {
    # skip implicit calls, they have no parameters
    if($call->kind()->check("Implicit")) { next; }
    # skip calls to unresolved or unknown functions
    if($call->ent()->kind()->check("Unresolved,Unknown")) { next; }
    my $args = function_arguments($call);
    my $p_refs = get_parameter_list($call->ent());
#    my @p_refs = $call->ent()->refs('Define', 'Parameter');
    foreach my $arg (@{$args})
    {
      if($arg->{'ent'}->id() == $entity->id())
      {
	my $p_ref = ${$p_refs}[$arg->{'num'}];
#	my $p_ref = $p_refs[$arg->{'num'}];

	# overloaded constructor calls are not hooked correctly in $call
	# so have to check for undef $p_ref, before continuing.
	if($p_ref)
	{
	  if(is_reference_type($p_ref->ent()))
	  {
	    my ($lexer, $status) = get_lexer($p_ref->file());
	    if( $status ) { return undef; } # FIXME: How do we throw an error?
	    my $lexeme = $lexer->lexeme($p_ref->line(), $p_ref->column());
	    push(@{$r_values}, new_r_value($lexeme, $T_PARAMETER_FORWARD));
	    $ret = 1;
	  }
	}
      }
    }
  }
  
  return $ret;
}

#
# Search for locations in the function $ref->ent() where
# the address of $entity is passed as an actual argument in a function call,
# or $entity is a pointer type and is passed as an actual argument.
#
# $entity: the entity that we are searching for as an argument
# $ref->ent(): the function where we are searching for function calls
# $r_values: empty array reference to push lexemes of $entity being used as an actual parameter
#
#
# Algorithm:
# for all function calls in the current function
#    for all arguments to the function call
#      if the argument is (a pointer to the current entity) or (is the current entity and it is a pointer)
#        push the lexeme of the formal parameter in the
#        function definition in the same position
#
sub is_lvalue_pass_by_pointer
{
  my ($entity, $ref, $r_values) = @_;
  my $ret = -1;
  my $calls = get_call($ref->ent());
  foreach my $call (@{$calls})
  {
    # skip implicit calls, they have no parameters
    if($call->kind()->check("Implicit")) { next; }
    # skip calls to unresolved or unknown functions
    if($call->ent()->kind()->check("Unresolved,Unknown")) { next; }
    my $args   = function_arguments($call);
    my $p_refs = get_parameter_list($call->ent());
#    my @p_refs = $call->ent()->refs('Define', 'Parameter');
    foreach my $arg (@{$args})
    {
      if($arg->{'ent'}->id() == $entity->id() &&
	 $arg->{'mode'} eq $PB_POINTER )
      {
	my $p_ref = ${$p_refs}[$arg->{'num'}];
#	my $p_ref = $p_refs[$arg->{'num'}];

	# overloaded constructor calls are not hooked correctly in $call
	# so have to check for undef $p_ref, before continuing.
	if($p_ref)
	{
	  my ($lexer, $status) = get_lexer($p_ref->file());
	  if( $status ) { return undef; } # FIXME: How do we throw an error?
	  my $lexeme = $lexer->lexeme($p_ref->line(), $p_ref->column());
	  push(@{$r_values}, new_r_value($lexeme, $T_PARAMETER_FORWARD));
	  $ret = 1;
	}
      }
    }
  }
  
  return $ret;
}

#
# Find all actual arguments that are passed into this parameter
# 
# Algorithm:
# if $entity is a parameter defined in $ref->ent()
#   find which parameter $entity is for $ref->ent()
#   for all places where $ref->ent() is called
#     find the nth actual argument of the call
#
sub is_lvalue_parameter
{
  my ($entity, $ref, $r_values) = @_;
  
  if($ref->kind()->check("Definein") && $entity->kind()->check("Parameter"))
  {
    # find the 0-indexed parameter number that $entity is of $ref->ent()
    my $count = 0;
    foreach my $r ($ref->ent()->refs("Define ~unknown ~undefined"))
    {
      if($r->ent()->kind()->check("Parameter"))
      {
	if($entity->id() == $r->ent()->id())
	{
	  last;
	}
	$count ++;
      }
    }

    # foreach place where $ref->scope() is called, find the $count'th argument
    foreach my $r ($ref->ent()->refs("Callby ~unknown ~undefined"))
    {
      my $lexeme = function_call_nth_argument($r, $count);
      push(@{$r_values}, new_r_value($lexeme, $T_PARAMETER_BACKWARD));
    }

    return 1;
  }
  
  return -1;
}

#
# return the lexeme of the the arg_number'th argument
# 
sub function_call_nth_argument
{
  my ($ref,        # the reference of a Callby.  Scope is the function that is called, Ent is the calling function
      $arg_number, # the argument number to find.  Starts from 0.
    ) = @_;
  
  my ($lexer, $status) = get_lexer($ref->file());

  if( $status ) { return undef; } # FIXME: How do we throw an error?

  my $lexeme = $lexer->lexeme($ref->line(), $ref->column());

  # find the opening paren
  while($lexeme && $lexeme->next())
  {
    $lexeme = $lexeme->next();
    if( is_left_paren($lexeme) )
    {
      last;
    }
  }
  
  my $count = 0;
  while($lexeme && $lexeme->next())
  {
    $lexeme = $lexeme->next();
    if( is_comma($lexeme) )
    {
      $count ++;
      next;
    }
    if( is_identifier($lexeme) && $count == $arg_number)
    {
      last;
    }
  }
  return $lexeme;
}

sub is_lvalue_assignment
{
  my ($entity, $ref, $r_values) = @_;
  my ($lexer, $status) = get_lexer($ref->file());
  if( $status ) { return 0; } # FIXME: How do we throw an error?
  
  my $lexeme = $lexer->lexeme($ref->line(), $ref->column());

  # try to handle Useby Macrodefine references where $ref->column() is always 0.
  if($ref->column() == 0)
  {
    while($lexeme &&
	  ($lexeme->line_begin() == $ref->line()) &&
	  ((!$lexeme->ent()) || ($lexeme->ent()->id() ne $entity->id()))
	  )
    {
      $lexeme = $lexeme->next();
    }
  }
  
  my $paren_depth = 0;
  
  while( $lexeme )
  {
#    print $lexeme->text();
    if( is_semicolon($lexeme) )
    {
      # found end of statement before assignment operator
      return 0;
    }
    elsif( is_right_paren($lexeme) )
    {
      $paren_depth --;
      if( $paren_depth < 0 )
      {
	# found end of statement before assignment operator
	return 0;
      }
    }
    elsif( is_comma($lexeme) )
    {
#      print "COMMA at $paren_depth\n";
      if($paren_depth <= 0) { return 0; }
    }
    elsif( is_left_paren($lexeme) )
    {
      $paren_depth ++;
    }

    elsif( $lexeme->token() eq "Operator" &&
	   $lexeme->text() eq "=" )
    {
      $lexeme = $lexeme->next();
      while( $lexeme )
      {
#	print $lexeme->text();
	if( is_semicolon($lexeme) )
	{
	  last;
	}
	elsif( is_right_paren($lexeme) )
	{
	  $paren_depth --;
	  if($paren_depth < 0) { last; }
	}
	elsif( is_comma($lexeme) )
	{
#	  print "COMMA at $paren_depth\n";
	  if($paren_depth <= 0) { last; }
	}
	elsif( is_left_paren($lexeme) )
	{
	  $paren_depth ++;
	}
	elsif( is_identifier($lexeme) ||
	       is_literal($lexeme) ||
	       is_string($lexeme) )
	{
	  push(@{$r_values}, new_r_value($lexeme, $T_NONE));
	}
	$lexeme = $lexeme->next();
      }
      return 1;
    }
    $lexeme = $lexeme->next();
  }
  # ran out of lexemes
  return -1;
}

sub is_semicolon
{
  my ($lexeme) = @_;
  return ( $lexeme->token() eq "Punctuation" &&
	   $lexeme->text() eq ";" );
}
sub is_comma
{
  my ($lexeme) = @_;
  return ( $lexeme->token() eq "Operator" &&
	   $lexeme->text() eq "," );
}
sub is_address_operator
{
  my ($lexeme) = @_;
  return ( $lexeme->token() eq "Operator" &&
	   $lexeme->text() eq "&" );
}
sub is_dot_operator
{
  my ($lexeme) = @_;
  return ( $lexeme->token() eq "Operator" &&
	   $lexeme->text() eq "." );
}
sub is_arrow_operator
{
  my ($lexeme) = @_;
  return ( $lexeme->token() eq "Operator" &&
	   $lexeme->text() eq "->" );
}
sub is_right_paren
{
  my ($lexeme) = @_;
  return ( $lexeme->token() eq "Punctuation" &&
	   $lexeme->text() eq ")" );
}
sub is_left_paren
{
  my ($lexeme) = @_;
  return ( $lexeme->token() eq "Punctuation" &&
	   $lexeme->text() eq "(" );
}
sub is_identifier
{
  my ($lexeme) = @_;
  return ( $lexeme->token() eq "Identifier" );
}
sub is_literal
{
  my ($lexeme) = @_;
  return ( $lexeme->token() eq "Literal" );
}
sub is_string
{
  my ($lexeme) = @_;
  return ( $lexeme->token() eq "String" );
}
sub is_whitespace
{
  my ($lexeme) = @_;
  return ( $lexeme->token() eq "Whitespace" );
}
sub is_comment
{
  my ($lexeme) = @_;
  return ( $lexeme->token() eq "Comment" );
}


my %g_nodes;
sub init_node_exists
{
  @all_nodes = ();
  %g_nodes = ();
}
sub node_key
{
  my ($filename, $line, $column, $id) = @_;
  return join(':', $filename, $line, $column, $id);
}
sub node_exists
{
  my $key = node_key(@_);
  return $g_nodes{ $key };
}
sub set_node_exists
{
  my $key = node_key(@_);
  $g_nodes{ $key } = 1;
}
sub lexeme_node_key
{
  my ($lexeme) = @_;
  my $key = undef;
  if($lexeme)
  {
    my $text = $lexeme->text();
    if($lexeme->ent())
    {
      $text = $lexeme->ent()->id();
    }
    my $filename = "";
    if($lexeme->ref())
    {
      $filename = $lexeme->ref()->file()->longname();
    }
    my $line = $lexeme->line_begin();
    my $column = $lexeme->column_begin();
    $key = node_key($filename, $line, $column, $text);
  }
  return $key;
}
sub lexeme_node_exists
{
  my ($lexeme) = @_;
  my $key = lexeme_node_key($lexeme);
  return $g_nodes{ $key };
}
sub lexeme_set_node_exists
{
  my ($lexeme) = @_;
  my $key = lexeme_node_key($lexeme);
  $g_nodes{ $key } = 1;
}

#
# These methods are used to manage a lexer cache so that we do not
# have to repeatedly parse the same files.
#
my %g_lexer;
my @g_lexer_keys;
my $g_lexer_count = 0;
my $g_MAX_LEXER_COUNT = 40;
sub init_lexer
{
  %g_lexer = ();
}
sub get_lexer
{
  my ($file_ref) = @_;
  my $lexer = lexer_exists($file_ref);
  my $status = 0;
  if( !$lexer )
  {
    ($lexer, $status) = $file_ref->lexer();
    if( !$status )
    {
      set_lexer_exists($file_ref, $lexer);
    }
  }
  return ($lexer, $status);
}
sub lexer_key
{
  my ($file_ref) = @_;
  if($file_ref) { return $file_ref->longname(); }
  return "";
}
sub lexer_exists
{
  my ($file_ref) = @_;
  my $key = lexer_key($file_ref);
  return $g_lexer{ $key };
}
sub set_lexer_exists
{
  my ($file_ref, $lexer) = @_;
  my $key = lexer_key($file_ref);
  push(@g_lexer_keys, $key);
  $g_lexer{ $key } = $lexer; # $file_ref->lexer();
  $g_lexer_count ++;
  while($g_lexer_count > $g_MAX_LEXER_COUNT)
  {
    my $key = shift @g_lexer_keys;
    $g_lexer{ $key } = undef;
    delete $g_lexer{ $key };
    $g_lexer_count --;
  }
}

sub function_arguments
{
  my ($call_ref) = @_;
  my $arg_list = get_arg_list($call_ref);
  return $arg_list;
}

#
# This code was lifted from "objfuncuses.pl" and then modified 
# for use here.
# The purpose of this subroutine is to identify the lexemes of all
# real arguments to a function call.
#
# This only works with simple function calls and does not handle overloaded
# functions or multiple objects being passed into the same parameter
#
sub function_arguments_aux
{
  my ($ref) = @_;  # the ref with scope() as the calling function, and ent() as the called function
  my $varlist = [];

  my ($lexer, $status) = get_lexer($ref->file());
  if( $status ) { return undef; } # FIXME: How do we throw an error?
  my $lexeme = $lexer->lexeme($ref->line(), $ref->column());
  
  if ( ($lexeme) &&
       # Identify Function Calls
       ($ref && $ref->kind()->check("call") && $ref->ent()->kind()->check("function")) )
  {
    # Fast forward to starting paren.
    while ($lexeme && !is_left_paren($lexeme) && !is_semicolon($lexeme))
    {
      $lexeme = $lexeme->next();
    }
    if($lexeme && is_semicolon($lexeme)) { $lexeme = undef; } # no parens at all, short circuit the loop
    my $parencount = 1;
    $lexeme = $lexeme->next() if $lexeme;
    my $parameter_count = 0;
    my $next_parameter = new_parameter($parameter_count, undef, $PB_VALUE);
    while ($lexeme && $parencount > 0)
    {
      # push the variables onto @varlist
      if ( is_identifier($lexeme) && $lexeme->ent() )
	# occasionally there is no ent() for an identifier lexeme (e.g. Pixie:containers.h:311:151:key)
      {
	$next_parameter->{'ent'} = $lexeme->ent();
	if ( is_pointer_type($lexeme->ent()) )
	{
	  $next_parameter->{'mode'} = $PB_POINTER;
	}
	push (@{$varlist}, $next_parameter);
	$next_parameter = new_parameter($parameter_count, undef, $PB_VALUE);
      }
      if ( is_address_operator($lexeme) )
      {
	$next_parameter->{'mode'} = $PB_POINTER;
      }
      if ( is_comma($lexeme) && $parencount == 1 )
      {
	$parameter_count ++;
	$next_parameter->{'num'} = $parameter_count;
      }
      # Keep track of extra brackets
      $parencount++ if ( is_left_paren($lexeme) );
      $parencount-- if ( is_right_paren($lexeme) );
      $lexeme = $lexeme->next();
    }
  }
  return $varlist;
}

##############################
# function argument cache
#

my %g_arg_list;  # key is file, line, column of call; value is ref to array of arguments
my @g_arg_list_keys;
my $g_arg_list_count = 0;
my $g_MAX_ARG_LIST_COUNT = 100;

sub init_arg_list
{
  %g_arg_list = ();
}
sub get_arg_list
{
  my ($call_ref) = @_;
  my $arg_list = arg_list_exists($call_ref);
  if( !$arg_list )
  {
    $arg_list = function_arguments_aux($call_ref);
    set_arg_list_exists($call_ref, $arg_list);
  }
  return $arg_list;
}
sub arg_list_key
{
  my ($call_ref) = @_;
  if($call_ref)
  {
    return $call_ref->file()->longname() . ":" . $call_ref->line() . ":" . $call_ref->column();
  }
  return "";
}
sub arg_list_exists
{
  my ($call_ref) = @_;
  my $key = arg_list_key($call_ref);
  return $g_arg_list{ $key };
}
sub set_arg_list_exists
{
  my ($call_ref, $arg_list) = @_;
  my $key = arg_list_key($call_ref);
  push(@g_arg_list_keys, $key);
  $g_arg_list{ $key } = $arg_list;
  $g_arg_list_count ++;
  while($g_arg_list_count > $g_MAX_ARG_LIST_COUNT)
  {
    my $key = shift @g_arg_list_keys;
    $g_arg_list{ $key } = undef;
    delete $g_arg_list{ $key };
    $g_arg_list_count --;
  }
}


#
# function argument cache
##############################


##############################
# function call cache
#
my %g_call;  # key is id of calling function; value is perl-ref to array of calls
my @g_call_keys;
my $g_call_count = 0;
my $g_MAX_CALL_COUNT = 100;

sub init_call
{
  %g_call = ();
}
sub get_call
{
  my ($func_ent) = @_;
  my $calls = call_exists($func_ent);
  if( !$calls )
  {
    $calls = [ $func_ent->refs("Call") ];
    set_call_exists($func_ent, $calls);
  }
  return $calls;
}
sub call_key
{
  my ($func_ent) = @_;
  if($func_ent)
  {
    return $func_ent->id();
  }
  return "";
}
sub call_exists
{
  my ($func_ent) = @_;
  my $key = call_key($func_ent);
  return $g_call{ $key };
}
sub set_call_exists
{
  my ($func_ent, $calls) = @_;
  my $key = call_key($func_ent);
  push(@g_call_keys, $key);
  $g_call{ $key } = $calls;
  $g_call_count ++;
  while($g_call_count > $g_MAX_CALL_COUNT)
  {
    my $key = shift @g_call_keys;
    $g_call{ $key } = undef;
    delete $g_call{ $key };
    $g_call_count --;
  }
}
#
# function call cache
##############################

##############################
# function parameter cache
#
my %g_parameter_list;  # key is id of defined function; value is perl-ref to array of definition refs
my @g_parameter_list_keys;
my $g_parameter_list_count = 0;
my $g_MAX_PARAMETER_LIST_COUNT = 100;

sub init_parameter_list
{
  %g_parameter_list = ();
}
sub get_parameter_list
{
  my ($func_ent) = @_;
  my $parameter_list = parameter_list_exists($func_ent);
  if( !$parameter_list )
  {
    $parameter_list = [ $func_ent->refs('Define', 'Parameter') ];
    set_parameter_list_exists($func_ent, $parameter_list);
  }
  return $parameter_list;
}
sub parameter_list_key
{
  my ($func_ent) = @_;
  if($func_ent)
  {
    return $func_ent->id();
  }
  return "";
}
sub parameter_list_exists
{
  my ($func_ent) = @_;
  my $key = parameter_list_key($func_ent);
  return $g_parameter_list{ $key };
}
sub set_parameter_list_exists
{
  my ($func_ent, $parameter_list) = @_;
  my $key = parameter_list_key($func_ent);
  push(@g_parameter_list_keys, $key);
  $g_parameter_list{ $key } = $parameter_list;
  $g_parameter_list_count ++;
  while($g_parameter_list_count > $g_MAX_PARAMETER_LIST_COUNT)
  {
    my $key = shift @g_parameter_list_keys;
    $g_parameter_list{ $key } = undef;
    delete $g_parameter_list{ $key };
    $g_parameter_list_count --;
  }
}
#
# function parameter cache
##############################





sub new_parameter
{
  my ($num, $ent, $mode) = @_;

  my $next_parameter = { 'num'  => $num,   # e.g. 0, 1, 2, ...
			 'ent'  => $ent,   # e.g. $entity
			 'mode' => $mode,  # e.g. $PB_POINTER, $PB_VALUE
  };
  return $next_parameter;
}

sub new_r_value
{
  my ($lexeme, $type) = @_;
  my $r_value =
  {
    'lexeme' => $lexeme,  # the lexeme of the r_value
    'type'   => $type,    # e.g. $T_NONE, $T_PARAMETER_FORWARD, $T_PARAMETER_BACWARD
    
  };
  return $r_value;
}

1;
