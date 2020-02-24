#
#          Copyright (c) 2000-2013, Scientific Toolworks, Inc.
#
# This file contains proprietary information of Scientific Toolworks, Inc.
# and is protected by federal copyright law. It may not be copied or
# distributed in any form or medium without prior written authorization
# from Scientific Toolworks, Inc.
#


#
# Understand
#
package Understand;
use strict;

sub license {Understand::Api::license(@_);}
sub open    {Understand::Db->open(@_);}
sub version {Understand::Api::version(@_);}


#
# Understand::Db
#
package Understand::Db;
use strict;

sub new {my ($class,$db)=@_; bless \$db,$class if $db;}
sub DESTROY { my $db=shift; Understand::Api::db_destroy($$db); }

sub open {
  my $class = shift;
  my ($db, $status) = Understand::Api::db_open(@_);
  bless \$db,$class;
  return wantarray? (\$db, $status): \$db;
}

sub lookup {
  my ($db,$name,$kind,$case) = @_;
  # handle non-regex
  if ($name !~ m/[\*\?]/) {
    $name = lc($name) if !$case;
    my @ents;
    foreach my $ent ($db->ents($kind)) {
      if (($case && ($ent->name() eq $name || $ent->longname() eq $name)) ||
          (!$case && (lc($ent->name()) eq $name || lc($ent->longname()) eq $name))) {
        return $ent if !wantarray;
        push @ents, $ent;
      }
    }
    return @ents;
  }

  $name =~ s/\\/\\\\/g;
  $name =~ s/\./\\\./g;
  $name =~ s/\+/\\\+/g;
  $name =~ s/\[/\\\[/g;
  $name =~ s/\]/\\\]/g;
  $name = "\^".$name if $name !~ /^\^/;
  $name = $name."\$" if $name !~ /\$$/;
  $name =~ s/\*/\.\*/g;
  $name =~ s/\?/\./g;
  my @ents;
  foreach my $ent ($db->ents($kind)) {
    if (($case && (($ent->name() =~ /$name/) || ($ent->longname() =~ /$name/))) ||
        !$case && (($ent->name() =~ /$name/i) || ($ent->longname() =~ /$name/i))) {
      return $ent if !wantarray;
      push @ents, $ent;
    }
  }
  return @ents;
}

sub language {
  my $db = shift;
  my @langs = Understand::Api::db_language($$db);
  return wantarray? @langs: "@langs";
}

sub lookup_uniquename {
  my $db = shift;
  my $uniquename = shift;
  my $ent = Understand::Api::db_lookup_uniquename($$db,$uniquename);
  return Understand::Ent->new($ent);
}

sub ent_from_id {
  my $db = shift;
  my $id = shift;
  return Understand::Ent->new(Understand::Api::db_ent_from_id($$db,$id));
}

sub close           {my $db=shift; Understand::Api::db_close($$db);}
sub docformat       {my $db=shift; Understand::Doc::setformat($$db,@_);}
sub draw            {my $db=shift; Understand::Api::db_draw($$db,@_);}
sub ents            {my $db=shift; Understand::Ent->list($$db,@_);}
sub lookup_snapshot {my ($db,$n)=@_; Understand::Snapshot->new(Understand::Api::db_lookup_snapshot($$db,$n));}
sub metric          {my $db=shift; Understand::Api::db_metric($$db,@_);}
sub metrics         {my $db=shift; Understand::Api::db_metrics($$db);}
sub name            {my $db=shift; Understand::Api::db_name($$db);}
sub snapshots       {my $db=shift; Understand::Snapshot->new(Understand::Api::db_snapshots($$db));}

sub metrics_treemap {
  my $db=shift;
  my $arraysize = @_;
  if($arraysize == 5){
    my $arch = pop(@_);
    Understand::Api::db_metrics_treemap($$db,@_, $$arch);
  }
  else{
    Understand::Api::db_metrics_treemap($$db,@_);
  }
}

sub root_archs {
  my $db = shift;
  my @archs = Understand::Api::db_root_archs($$db);
  return Understand::Arch->new(@archs);
}
sub archs      {
  my $db = shift;
  my $ent = shift;
  my @archs = Understand::Api::db_archs($$db,$$ent);
  return Understand::Arch->new(@archs);
}
sub lookup_arch {
  my $db = shift;
  my $arch = Understand::Api::db_lookup_arch($$db,@_);
  return Understand::Arch->new($arch);
}

sub annotations{
  my $db = shift;
  my @atns = Understand::Api::db_annotations($$db);
  my @finalAtns = ();
  while (scalar @atns){
    push @finalAtns, Understand::Atn->new(shift @atns, shift @atns,
      $db->lookup_uniquename(shift @atns), shift @atns);
  }
  my $err = Understand::Api::annotations_errors();
  return (\@finalAtns, $err);

}


#
# Understand::Arch
#
package Understand::Arch;
use strict;

sub new {
  my $class = shift;
  if (!wantarray) {
    my $arch = shift;
    return $arch? bless \$arch,$class: undef;
  }
  my @archs;
  foreach my $arch (@_) {
    push @archs, bless \$arch,$class if $arch;
  }
  return @archs;
}

sub depends{
  return Understand::Dep->new(shift,1,@_);
}
sub dependsby{
  return Understand::Dep->new(shift,0,@_);
}

sub DESTROY  {my $arch=shift; Understand::Api::arch_destroy($$arch);}
sub name     {my $arch=shift; Understand::Api::arch_name($$arch);}
sub longname {my $arch=shift; Understand::Api::arch_longname($$arch);}
sub metric   {my $arch=shift; Understand::Api::arch_metric($$arch,@_);}
sub metrics  {my $arch=shift; Understand::Api::arch_metrics($$arch,@_);}
sub parent   {my $arch=shift; Understand::Arch->new(Understand::Api::arch_parent($$arch));}
sub children {my $arch=shift; Understand::Arch->new(Understand::Api::arch_children($$arch));}
sub ents     {my $arch=shift; Understand::Ent->newlist(Understand::Api::arch_ents($$arch,@_));}
sub contains {my $arch=shift; my $ent=shift; Understand::Api::arch_contains($$arch,$$ent,@_);}

#
# Understand::Dep
#

package Understand::Dep;

sub new {
  my $class = shift;
  my $ent = shift;
  my $forward = shift;

  my @keys;
  my @values;
  if(ref($ent) eq "Understand::Ent"){
    # Get the entity part of the dependency
    @keys = Understand::Api::ent_depends_ents($$ent,$forward);
    # Get the reference part of the dependency
    foreach my $ref (Understand::Api::ent_depends_refs($$ent,$forward)){
      my $newref = Understand::Ref->new($ref);
      push @values, $newref;
    }
  }
  else{
    #We're actually doing an arch
    @keys = Understand::Api::arch_depends_archs($$ent,$forward,@_);
    foreach my $ref (Understand::Api::arch_depends_refs($$ent,$forward,@_)){
      my $newref = Understand::Ref->new($ref);
      push @values, $newref;
    }
  }

  my @ents; # The final array that will hold all the keys
  my @refs; # The final array that will hold all the values

  my $curIndex = 0; # The index in values
  my $curEntsIndex = 0; # The index in keys
  my $numelements = @keys; #The total number of items in keys

  if ($numelements < 2){
    return;
  }

  while ($curEntsIndex < $numelements){
    # Add the key to the key array
    if(ref($ent) eq "Understand::Ent"){
      my $key =Understand::Ent->new($keys[$curEntsIndex]);
      push @ents,$key;
    }
    else{
      my $key =Understand::Arch->new($keys[$curEntsIndex]);
      push @ents,$key;
    }

    # Grab indexes to split up reference array
    my $firstindex = $curIndex;
    $curIndex += $keys[$curEntsIndex+1];
    my $lastindex = $curIndex -1;

    # Add the correct range of references to the reference array
    my @vals = @values[$firstindex .. $lastindex];
    push @refs, [@vals];

    # Update Ent Index
    $curEntsIndex += 2;
  }
  my $self = [[@ents],[@refs],[@values]];
  bless $self, $class;
  return $self;
}
sub keys {
  # This is the same as keys %hash would give
  my ($self) = @_;
  my @ents = @{$self->[0]};
  my $elements = @ents;
  return @ents;
}
sub values {
  # This is the same as values %hash would give
  my ($self) = @_;
  my @refs = @{$self->[2]};
  return @refs;
}
sub value {
  # This is what %hash{key} would give (if an Understand::Ent could be used)
  my ($self,$ent) = @_;
  my @ents = @{$self->[0]};
  my $numElements = @ents;
  my @refs = @{$self->[1]};

  foreach my $index (0 .. $numElements-1){
    my $trueValue = $ents[$index]->id() eq $ent->id() if ref($ent) eq "Understand::Ent";
    $trueValue = $ents[$index]->longname() eq $ent->longname() if not defined($trueValue);
    if ($trueValue){
      my @returnRefs = @{$refs[$index]};
      return @returnRefs;
    }
  }
  return ();
}

#
# Understand::Atn
#
package Understand::Atn;

sub new {
  my($class,$author,$date,$ent,$text) = @_;
  my $self = {
    'author'     => $author,
    'date'       => $date,
    'ent'        => $ent,
    'text'       => $text
  };
  bless $self, $class;
  return $self;
}

sub author{
  my $self = shift;
  return $self->{'author'};
}

sub date{
  my $self = shift;
  return $self->{'date'};
}

sub ent{
  my $self = shift;
  return $self->{'ent'};
}

sub text{
  my $self = shift;
  return $self->{'text'};
}


#
# Understand::Ent
#

package Understand::Ent;
use strict;
use overload
  qw("") => sub {
    my $ent = shift;
    Understand::Api::ent_as_string($$ent);
  },
  "<=>"  => sub {
    my ($ent1, $ent2, $rev) = @_;
    if ($rev) {
      my $temp = $ent1;
      $ent1 = $ent2;
      $ent2 = $temp;
    }
    return 0  if (!$ent1 && !$ent2);
    return +1 if (!$ent2);
    return -1 if (!$ent1);
    Understand::Api::ent_compare($$ent1,$$ent2);
  },
  "bool" => sub {defined $_[0];};

sub new {
  my ($class, $ent) = @_;
  if ($ent) {bless \$ent,$class;}
}

sub newlist {
  my $class = shift;
  my @ents;
  foreach my $ent (@_) {
    push @ents, bless \$ent,$class;
  }
  return @ents;
}

sub DESTROY { my $db=shift; Understand::Api::ent_destroy($$db); }

sub annotations{
  my $ent = shift;
  my @atns = Understand::Api::ent_annotations($$ent);
  my @finalAtns = ();
  while (scalar @atns){
    push @finalAtns, Understand::Atn->new(shift @atns, shift @atns, Understand::Ent->new(shift @atns),
      shift @atns);
  }
  my $err = Understand::Api::annotations_errors();
  return (\@finalAtns, $err);

}
sub depends {
  return Understand::Dep->new(shift,1);
}

sub dependsby {
  return Understand::Dep->new(shift,0);
}
sub ents {
  my $ent = shift;
  my $newent;
  if (wantarray) {
    my @ents;
    foreach $newent (Understand::Api::ent_ents($$ent,@_)) {
      push @ents, ref($ent)->new($newent);
    };
    return @ents;
  } else {
    ($newent) = Understand::Api::ent_ents($$ent,@_);
    return ref($ent)->new($newent);
  }
}

sub filerefs {
  my $ent = shift;
  return Understand::Ref->listfile($$ent,@_);
}

sub lexer {
  my $ent = shift;
  my ($lexer, $status) = Understand::Api::ent_lexer($$ent,@_);
  $lexer = Understand::Lexer->new($lexer);
  return wantarray? ($lexer, $status): $lexer;
}

# Return status text for if we were to try to create a lexer, or return undef
# if there would be no error.
sub lexer_test { my $ent = shift; return Understand::Api::ent_lexer_test($$ent); }

sub list {
  my $class = shift;
  my $newent;
  my @ents;
  foreach $newent (Understand::Api::db_ents(@_)) {
    push @ents, $class->new($newent);
  };
  return @ents;
}

sub macroexpansion {
  my $file = shift;
  my $macro = shift;
  my $line = shift;
  my $column = shift;
  my ($text,$status) = Understand::Api::ent_macroexpansion($$file,$macro,$line,$column);
  return wantarray? ($text,$status): $text;
}

sub parameters {
  my $ent = shift;
  my $params = Understand::Api::ent_parameters($$ent,@_);
  return undef if !defined $params;
  return $params if !wantarray;
  return split(/,/,join(',',$params));
}

sub refs {
  my $ent = shift;
  return wantarray? Understand::Ref->list($$ent,@_): Understand::Ref->first($$ent,@_);
}

sub doc {
  my $ent = shift;
  $_[1] = "raw", unless $_[1];
  &Understand::Doc::parse(Understand::Api::ent_comments($$ent,@_));
}

sub draw {
  use warnings;
  # with warnings enabled, the call to ent_draw emits multiple warnings:
  #   Use of uninitialized value in Subroutine entry at...
  no warnings;
  my $ent = shift;
  Understand::Api::ent_draw($$ent,@_);
}

sub comments     {my $ent = shift; Understand::Api::ent_comments($$ent,@_);}
sub contents     {my $ent = shift; Understand::Api::ent_contents($$ent);}
sub extname      {my $ent = shift; Understand::Api::ent_extname($$ent);}
sub freetext     {my $ent = shift; Understand::Api::ent_freetext($$ent,@_);}
sub ib           {my $ent = shift; Understand::Api::ent_ib($$ent,@_);}
sub id           {my $ent = shift; Understand::Api::ent_id($$ent);}
sub kind         {my $ent = shift; Understand::Kind->new(Understand::Api::ent_kind($$ent));}
sub kindname     {my $ent = shift; Understand::Api::kind_name(Understand::Api::ent_kind($$ent));}
sub language     {my $ent = shift; Understand::Api::ent_language($$ent);}
sub library      {my $ent = shift; Understand::Api::ent_library($$ent);}
sub longname     {my $ent = shift; Understand::Api::ent_longname($$ent,@_);}
sub metric       {my $ent = shift; Understand::Api::ent_metric($$ent,@_);}
sub metrics      {my $ent = shift; Understand::Api::ent_metrics($$ent,@_);}
sub name         {my $ent = shift; Understand::Api::ent_name($$ent);}
sub parent       {my $ent = shift; Understand::Ent->new(Understand::Api::ent_parent($$ent));}
sub parsetime    {my $ent = shift; Understand::Api::ent_parsetime($$ent);}
sub ref          {my $ent = shift; Understand::Ref->first($$ent,@_);}
sub relname      {my $ent = shift; Understand::Api::ent_relname($$ent);}
sub simplename   {my $ent = shift; Understand::Api::ent_simplename($$ent);}
sub type         {my $ent = shift; Understand::Api::ent_type($$ent);}
sub uniquename   {my $ent = shift; Understand::Api::ent_uniquename($$ent);}
sub value        {my $ent = shift; Understand::Api::ent_value($$ent);}


#
# Understand::Gui
#
package Understand::Gui;
use strict;

sub active         {Understand::Api::gui_active();}
sub analyze        {my $db=shift; Understand::Api::gui_analyze($$db,@_);}
sub disable_cancel {Understand::Api::gui_disable_cancel();}
sub column         {Understand::Api::gui_column();}
sub do_command     {Understand::Api::gui_do_command(@_);}
sub db             {Understand::Db->new(Understand::Api::gui_db());}
sub entity         {Understand::Ent->new(Understand::Api::gui_entity());}
sub file           {Understand::Ent->new(Understand::Api::gui_file());}
sub filename       {Understand::Api::gui_filename();}
sub flush          {Understand::Api::gui_flush();}
sub line           {Understand::Api::gui_line();}
sub open_file      {Understand::Api::gui_open_file(@_);}
sub open_files     {Understand::Api::gui_open_files();}
sub progress_bar   {Understand::Api::gui_progress_bar(@_);}
sub script         {Understand::Api::gui_script();}
sub scope          {Understand::Ent->new(Understand::Api::gui_scope());}
sub selection      {Understand::Api::gui_selection();}
sub tab_width      {Understand::Api::gui_tab_width();}
sub word           {Understand::Api::gui_word();}
sub yield          {Understand::Api::gui_yield();}



#
# Understand::CommandLine
#
package Understand::CommandLine;
use strict;

sub active         {!Understand::Api::gui_active() && Understand::Gui::db();}
sub db             {Understand::Gui::db();}



#
# Understand::Kind
#
package Understand::Kind;
use strict;

sub list_entity    {Understand::Kind->newlist(Understand::Api::kind_list_entity(@_));}
sub list_reference {Understand::Kind->newlist(Understand::Api::kind_list_reference(@_));}

sub newlist {
  my $class = shift;
  my @ents;
  foreach my $ent (@_) {
    push @ents, bless \$ent,$class;
  }
  return @ents;
}

sub new      {my ($class,$kind)=@_; bless \$kind,$class if $kind;}
sub DESTROY  {my $kind = shift; Understand::Api::kind_destroy($$kind);}
sub check    {my ($kind, $kinds) = @_; Understand::Api::kind_check($$kind,$kinds);}
sub inv      {my $kind = shift; ref($kind)->new(Understand::Api::kind_inv($$kind));}
sub longname {my $kind = shift; Understand::Api::kind_longname($$kind);}
sub name     {my $kind = shift; Understand::Api::kind_name($$kind);}



#
# Understand::Lexeme
#
package Understand::Lexeme;
use strict;
use overload
  "<=>"  => sub {
    my ($lexeme1,$lexeme2,$rev) = @_;
    return 0  if (!$lexeme1 && !$lexeme2);
    return +1 if (!$lexeme1);
    return -1 if (!$lexeme2);
    Understand::Api::lexeme_compare($$lexeme1,$$lexeme2);
  },
  "bool" => sub {defined $_[0];};

sub new {
  my $class=shift;
  if (!wantarray) {
    my $lexeme=shift;
    return $lexeme? bless \$lexeme,$class: undef;
  }
  my @lexemes;
  foreach my $lexeme (@_) {
    push @lexemes, bless \$lexeme,$class if $lexeme;
  }
  return @lexemes;
}
sub DESTROY      {my $lexeme = shift; Understand::Api::lexeme_destroy($$lexeme);}
sub column_begin {my $lexeme = shift; Understand::Api::lexeme_columnbegin($$lexeme);}
sub column_end   {my $lexeme = shift; Understand::Api::lexeme_columnend($$lexeme);}
sub ent          {my $lexeme = shift; Understand::Ent->new(Understand::Api::lexeme_entity($$lexeme));}
sub entity       {my $lexeme = shift; Understand::Ent->new(Understand::Api::lexeme_entity($$lexeme));}
sub inactive     {my $lexeme = shift; Understand::Api::lexeme_inactive($$lexeme);}
sub line_begin   {my $lexeme = shift; Understand::Api::lexeme_linebegin($$lexeme);}
sub line_end     {my $lexeme = shift; Understand::Api::lexeme_lineend($$lexeme);}
sub next         {my $lexeme = shift; Understand::Lexeme->new(Understand::Api::lexeme_next($$lexeme));}
sub previous     {my $lexeme = shift; Understand::Lexeme->new(Understand::Api::lexeme_previous($$lexeme));}
sub ref          {my $lexeme = shift; Understand::Ref->new(Understand::Api::lexeme_ref($$lexeme));}
sub text         {my $lexeme = shift; Understand::Api::lexeme_text($$lexeme);}
sub token        {my $lexeme = shift; Understand::Api::lexeme_token($$lexeme);}
sub nextUseful   {my $lexeme = shift;
                  $lexeme = Understand::Lexeme->new(Understand::Api::lexeme_next($$lexeme));
          return unless $lexeme;
          my $value = Understand::Api::lexeme_token($$lexeme);
          while ( $value eq "Whitespace" || $value eq "Comment" || $value eq "Newline" ) {
            $lexeme = Understand::Lexeme->new(Understand::Api::lexeme_next($$lexeme));
          return unless $lexeme;
            $value = Understand::Api::lexeme_token($$lexeme);
          }
          return $lexeme;}
sub prevUseful   {my $lexeme = shift;
                  $lexeme = Understand::Lexeme->new(Understand::Api::lexeme_previous($$lexeme));
          return unless $lexeme;
          my $value = Understand::Api::lexeme_token($$lexeme);
          while ( $value eq "Whitespace" || $value eq "Comment"  || $value eq "Newline" ) {
            $lexeme = Understand::Lexeme->new(Understand::Api::lexeme_previous($$lexeme));
          return unless $lexeme;
            $value = Understand::Api::lexeme_token($$lexeme);
          }
          return $lexeme;}


#
# Understand::Lexer
#
package Understand::Lexer;
use strict;

sub new     {my ($class,$lexer)=@_; bless \$lexer,$class if $lexer;}
sub DESTROY {my $lexer = shift; Understand::Api::lexer_destroy($$lexer);}
sub first   {my $lexer = shift; Understand::Lexeme->new(Understand::Api::lexer_first($$lexer));}
sub lexeme  {my $lexer = shift; Understand::Lexeme->new(Understand::Api::lexer_lexeme($$lexer,@_));}
sub lexemes {my $lexer = shift; Understand::Lexeme->new(Understand::Api::lexer_lexemes($$lexer,@_));}
sub lines   {my $lexer = shift; Understand::Api::lexer_lines($$lexer);}



#
# Understand::Metric
#
package Understand::Metric;
use strict;

sub description {Understand::Api::metric_description(@_);}
sub list {Understand::Api::metric_list(@_);}



#
# Understand::Ref
#
package Understand::Ref;
use strict;

sub list {
  my $class = shift;
  my $ref;
  my @refs;
  foreach $ref (Understand::Api::ent_refs(@_)) {
    push @refs, $class->new($ref);
  };
  return @refs;
}

sub listfile {
  my $class = shift;
  my $ref;
  my @refs;
  foreach $ref (Understand::Api::ent_filerefs(@_)) {
    push @refs, $class->new($ref);
  };
  return @refs;
}

sub first {
  my $class = shift;
  return $class->new(Understand::Api::ent_ref(@_));
}

sub lexeme    {
  my $ref = shift;
  my $file = Understand::Ent->new(Understand::Api::ref_file($$ref));
  
  my ($lexer, $status) = Understand::Api::ent_lexer($$file,@_);
  $lexer = Understand::Lexer->new($lexer);
  return unless $lexer;
  my $lexeme = Understand::Lexeme->new(Understand::Api::lexer_lexeme($$lexer,$ref->line,$ref->column));
  return $lexeme;
}


sub macroexpansion {
  my $ref = shift;
  my $file = Understand::Ent->new(Understand::Api::ref_file($$ref));
  my $ent  = Understand::Ent->new(Understand::Api::ref_ent($$ref));
  my $entname = Understand::Api::ent_name($$ent);
  my $scope  = Understand::Ent->new(Understand::Api::ref_scope($$ref));
  my $scopename = Understand::Api::ent_name($$scope);
  my $line = Understand::Api::ref_line($$ref);
  my $column = Understand::Api::ref_column($$ref);
  my ($text,$status) = Understand::Api::ent_macroexpansion($$file,$entname,$line,$column);
  my ($text2,$status2) = Understand::Api::ent_macroexpansion($$file,$scopename,$line,$column);
  if($text){
    return $text;
  }elsif($text2){
    return $text2;
  }
}


sub new        {my ($class,$ref)=@_; bless \$ref,$class if $ref;}
sub DESTROY    {my $ref = shift; Understand::Api::ref_destroy($$ref);}
sub column     {my $ref = shift; Understand::Api::ref_column($$ref);}
sub ent        {my $ref = shift; Understand::Ent->new(Understand::Api::ref_ent($$ref));}
sub file       {my $ref = shift; Understand::Ent->new(Understand::Api::ref_file($$ref));}
sub is_forward {my $ref = shift; Understand::Api::ref_is_forward($$ref);}
sub kind       {my $ref = shift; Understand::Kind->new(Understand::Api::ref_kind($$ref));}
sub kindname   {my $ref = shift; Understand::Api::kind_name(Understand::Api::ref_kind($$ref));}
sub line       {my $ref = shift; Understand::Api::ref_line($$ref);}
sub scope      {my $ref = shift; Understand::Ent->new(Understand::Api::ref_scope($$ref));}



#
# Understand::Snapshot
#
package Understand::Snapshot;
use strict;

sub new {
  my $class=shift;
  if (!wantarray) {
    my $snapshot=shift;
    return $snapshot? bless \$snapshot,$class: undef;
  }
  my @snapshots;
  foreach my $snapshot (@_) {
    push @snapshots, bless \$snapshot,$class if $snapshot;
  }
  return @snapshots;
}
sub DESTROY {my $s=shift; Understand::Api::snapshot_destroy($$s);}
sub name    {my $s=shift; Understand::Api::snapshot_name($$s);}
sub open    {my $s=shift; Understand::Db->new(Understand::Api::snapshot_open($$s));}


#
# Understand::Doc
#
# tools to access comment-embedded documents (javadoc style)
package Understand::Doc;
use strict;
use Carp;


sub setformat($$$$) {
  carp ('Usage:: Understand::Doc::setformat($db, $header, $body, $footer)') unless ($#_ == 3);
  my $db = shift @_;
  my ($header, $body, $footer) = @_;

  my $get_pat = sub ($$) {
    my $a = shift @_;
    my $tag_list = shift @_;

    # save out the tag (see the substitution for details).
    my ($tag) = ($a =~ m/^~(?:.*[^\\]&)?(.+?)~$/x);

    $tag =~ s/\\&/&/g;  # any "\&" can now be returned to "&"
    $tag =~ s/\\~/~/g;  # also with the "\~" to "~"
    push @$tag_list, $tag;

    # now we replace the whole string with the pattern.
    $a =~ s/^~      # starts the actual ~pattern&tag~ bit.
       (?:    # pattern is optional
        (.*[^\\])   # this is the pattern (can't end in "\")
        &     # and the divider
       )?     # optional, remember?
       .+?    # the tag part.
       ~$     # terminate the pattern
       /\($1\)/x;   # replace with "(pattern)" in the regex.
    $a =~ s/\\~/~/g;    # remove any "\~" and replace with "~"
    $a =~ s:\(\)$:\(\\w\+\):; # if empty regex, replace with "\w+"
    return $a;
  };

  my $make_pattern = sub (@) {
    my @ret;
    foreach my $pattern (@_) {
      # replace () with (?:)
      $pattern =~ s/
       \(     # find open parens in the equation
       (?!\?) # that aren't part of a (?xxx construct
       /\(\?:/gx; # replace them with (?: [grouping,non-counting]
      # find ~.+~ [ignoring "\~"]
      my @tags;
      $pattern =~ s/((?<!\\)~.*?(?!\\).~)/&$get_pat($1, \@tags)/eg;
#      print 'Pattern is: "', $pattern, "\"\n";
      unshift @tags, $pattern;
      push @ret, \@tags;
    }
    return @ret;
  };

  my ($p_head, $p_body, $p_foot) = &$make_pattern($header, $body, $footer);

#  print "made pattern: ", $body, "\n";

  &Understand::Api::doc_header($db, @$p_head);
  &Understand::Api::doc_tags($db, @$p_body);
  &Understand::Api::doc_footer($db, @$p_foot);
}

sub parse ($) {
  my $string = join("\n", @_);
  my %docs;     # will be "doc" object.
  $docs{"literal"} = $string; # save the literal string if we need it.

  # eventually, we should specify the database.  For now, it is unused.
  my ($header_pattern, @header_tags) =
    Understand::Api::doc_header("0 - unused");
  my ($body_pattern, @body_tags)     =
    Understand::Api::doc_tags("0 - unused");
  my ($footer_pattern, @footer_tags) =
    Understand::Api::doc_footer("0 - unused");

#  print 'Body pattern "', $body_pattern, '" has tags: "', join('", "', @body_tags), "\"\n";

  # make sure that the header matches the beginning.
  $header_pattern =~ s/^\^?/\^/;
  # make tags pattern match where last search ended.
#  $body_pattern =~ s/^(?:\\G)?/\\G\.\*\?/;
  # (not needed because we are doing replace)
  # make footer pattern match at the end.
  $footer_pattern =~ s/\$?$/\$/;

  # keep track of matches so we can later correlate them with tags.
  my (@headers, @body, @bodies, @footers, $at);
  $docs{"header"} = {};
  $docs{"body"} = {};
  $docs{"footer"} = {};


  if ($string =~ s/($header_pattern)// && $#header_tags) {
    $_ = $1;
    @headers = ($_ =~ m/$header_pattern/);
    for (0..$#header_tags) {
      if ($header_tags[$_] ne "@") {
        push @{$docs{"header"}{$header_tags[$_]}}, $headers[$_];
      } else {
        $at = $headers[$_] unless $at;
        push @{$docs{"header"}{$at}}, $headers[$_];
      }
    }
  }

#  print "using string ", $body_pattern, "\n";
  BODY: while ($string =~ s/($body_pattern)// && $#body_tags) {
    $_ = $1;
    undef $at;
    @body = ($_ =~ m/$body_pattern/);
    #   print "[@body_tags] : (@body)\n";
    for (0..$#body) {
      next unless $body[$_];
      if ($body_tags[$_] ne "@") {
        push @{$docs{"body"}{$body_tags[$_]}}, $body[$_];
      } else {
        if ($at) {
          push @{$docs{"body"}{$at}}, $body[$_];
        } else {
          $at = $body[$_] unless $at;
        }
      }
    }
  };

  if ($string =~ s/($footer_pattern)// && $#footer_tags) {
    $_ = $1;
    @footers = ($_ =~ m/$footer_pattern/);
    undef $at;
    for (0..$#footers) {
      if ($footer_tags[$_] ne "@") {
        push @{$docs{"footer"}{$footer_tags[$_]}}, $footers[$_];
      } else {
        $at = $footers[$_] unless $at;
        push @{$docs{"footer"}{$at}}, $body[$_];
      }
    }
  }

  # save the other text as well, in case we want it.
  $docs{"remains"} = $string;

  delete $docs{"header"}{''};
  delete $docs{"body"}{''};
  delete $docs{"footer"}{''};

  # now we bless the hash, and send it off into the world.
  return bless \%docs;
}

sub body ($) {
  my $this = shift @_;
  return $this->{"remains"};
}

sub tag ($$;$) {
  my ($this, $tagname, $sections) = @_;
  $sections = "header body footer" unless ($sections);

  my @retval;
  if ( defined $this->{"header"}{$tagname} and $sections =~ m/\bheader\b/ ) {
    push @retval, @{$this->{"header"}{$tagname}};
  }
  if ( $this->{"body"}{$tagname} and $sections =~ m/\bbody\b/ ) {
    foreach my $elem (@{$this->{"body"}{$tagname}} ) {
      push @retval, $elem;
#     print "Added $elem from @{$this->{body}{$tagname}}\n";
    }
  }
  if ( $this->{"footer"}{$tagname} and $sections =~ m/\bfooter\b/ ) {
    push @retval, @{$this->{"footer"}{$tagname}};
  }

  return @retval;
}

sub tags ($;$) {
  my ($this, $sections) = @_;
  $sections = "header body footer" unless ($sections);
  my %retval = ( %{$this->{"header"}},
                %{$this->{"body"}},
                %{$this->{"footer"}} );
  return keys %retval;
}

#
# Understand::Script
#
# adapted from perlembed doc
#
package Understand::Script;
use Symbol qw(delete_package);
use strict;

my %Cache;
sub run {
  my $filename = shift;
  my $do_cache = shift;
  my $initial_dir = shift;
  chdir $initial_dir if $initial_dir;
  @ARGV = @_;
  my $mtime = -M $filename;

  # make valid package name
  my $name = $filename;
  $name =~ s/([^A-Za-z0-9\/])/sprintf("_%2x",unpack("C",$1))/eg;
  $name =~ s|/(\d)|sprintf("/_%2x",unpack("C",$1))|eg;
  $name =~ s|/|::|g;
  $name = "Understand::Script::x" . Understand::Util::checksum($name);

  # add package to cache if needed
  if (!defined $Cache{$name}{mtime} || $Cache{$name}{mtime} > $mtime) {
    # read file
    local *FH;
    open FH, $filename or return 1;   # error
    local ($/) = undef;
    my $sub = <FH>;
    close FH;

    # wrap the code in a new subroutine
    delete_package($name);
    my $eval = qq{no strict; package $name; sub handler {shift; select STDOUT; $sub;}};
    { my ($filename,$mtime,$name,$sub); eval $eval; }
    if ($@) { # syntax error
      delete_package($name);
      die $@;
    }

    # mark file/package in cache
    $Cache{$name}{mtime} = $mtime if $do_cache;
  }

  # run script
  eval {$name->handler(@ARGV);};
  delete_package($name) if (!$do_cache or $@);
  delete $Cache{$name}{mtime} if ($do_cache and $@);
  die $@ if $@;         # error

  return $name;
}


#
# Understand::Stdout
#
package Understand::Stdout;
use strict;

my $OUT = *STDOUT;
tie *STDOUT, 'Understand::Stdout';

sub TIEHANDLE {my ($class, $fh) = @_; bless \$fh,$class;}
sub PRINT     {shift; my $s = join "",@_; print $OUT $s unless Understand::Api::print($s);}
sub PRINTF    {my $self = shift; @_ = ($self, sprintf shift, @_); goto &PRINT;}


#
# Understand::Util
#
package Understand::Util;
use strict;

sub checksum {Understand::Api::util_checksum(@_);}


#
# Understand::Api
#
package Understand::Api;
use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader);
$VERSION = '1.30';
if (!defined(&Understand::Api::db_open)) {
  bootstrap Understand::Api $VERSION;
};


1;
__END__



=head1 NAME

Package Understand - perl class interface to Understand databases.

L<Back to Top|/__index__>

=head1 SYNOPSIS

C<use Understand;>

The package Understand provides class-oriented access to I<Understand>
databases.

A list of entities (files, functions, variables, etc) may be obtained
from an open database. In addition to the name, kind and type of an
entity, a variety of metric values are available (lines of code,
complexity, etc). A list of all references made to or from an
entity (calls, includes, sets, etc) may be obtained. Reference
information includes file, line and column, reference kind and
referencing and referenced entity.

L<Back to Top|/__index__>

=head1 DESCRIPTION

=head2 Licensing

Use of the Understand package requires proper licensing. Presently, this
means a user- or host-locked license, or an available floating license,
for the product I<Understand>.

A license regcode, file or directory may be specified with
C<Understand::license(filename)>.

However, this is usually unnecessary, as the license file will be found
automatically with the following checks, in order:

=over 4

=item *

Understand::license(name)

=item *

The environment variable $STILICENSE

=item *

In the subdirectory conf/license of an installed Understand product.

=back

L<Back to Top|/__index__>

=head2 Open/Close a Database

A database is opened with the command
C<($db, $status) = Understand::open($name)>.

If the open fails, $status will be defined with a string indicating the kind
of failure. On a successful open, the returned $db will be an object from
the class Understand::Db. An open database may be closed with the command
C<$db-E<gt>close()>.

L<Back to Top|/__index__>

=head2 List of Entities

A list of all entities, such as files, functions and variables, may be
obtained from an Understand::Db object with the command
C<$db-E<gt>ents()>. The returned list may be refined with a filter
that specifies the kind of entities desired. For example,
C<$db-E<gt>ents("File")> will return just file entities. All entities
returned are objects of the class Understand::Ent.

L<Back to Top|/__index__>

=head2 Entity Attributes

There are a variety of attributes available for an Understand::Ent object. The
command C<$ent-E<gt>name()> returns the name of the entity, while
C<$ent-E<gt>longname()> returns a long name, if available.
Examples of entities with long names include files, C++ members and most Ada
entities.

If an entity has a type or return type associated with, for example a
variables, types or functions, the type may be determined with the command
C<$ent-E<gt>type()>.

The kind of an entity, such as File or Function, may be determined
with the command C<$ent-E<gt>kindname()>. If desired, the command:
C<$ent-E<gt>kind()> may be used instead, which returns an object of the
class Understand::Kind. This is sometimes useful when more detailed
information about the kind is required.

L<Back to Top|/__index__>

=head2 List of References

A list of references for an entity may be obtained from an Understand::Ent
object with the command C<$ent-E<gt>refs()>. The list may be refined
with a filter that specifies the kind of references desired. For example,
C<$ent-E<gt>refs("Define")> will return definition references. The
list may be even further refined with a second filter that specifies the
kind of referenced entities desired. For example,
C<@refs=$ent-E<gt>refs("Define","Parameter")> will return just definition
references for parameter entities. A final parameter with value 1 may be
used to specify that only unique entities be returned. For example,
C<@refs=$ent-E<gt>refs("Call","Function",1)> will return a list of
references to called functions, where only the first reference to each
unique function is returned. All references returned are objects of
the class Understand::Ref.

L<Back to Top|/__index__>

=head2 Comment Association

If associated comments have been stored in the database, they may be
retrieved for an entity. (Note, use the und command line option
-option_save_comments or the language specific option in the Project
Configuration). Associated comments are comments that occur near the
declaration of an entity in source code. Some entity kinds have different
kinds of declarations, which can be explicity specified. Also, comment
position, before or after the declaration, can be specified. The returned
comments can be a formatted string (the default) or may be an array of raw
comment strings.

L<Back to Top|/__index__>

=head2 Project Metrics

Metric values associated with the entire database or project are available
for Understand::Db objects. The command C<$db-E<gt>metrics()> returns
a list of all available project metric names. The command
C<$db-E<gt>metric(@mets)> returns a list of values for specific metrics.

L<Back to Top|/__index__>

=head2 Entity Metrics

Metric values associated with a specific entity are available for
Understand::Ent objects. The command C<$ent-E<gt>metrics()> returns
a list of all available entity metric names. The command
C<$ent-E<gt>metric(@mets)> returns a list of values for specific metrics.

L<Back to Top|/__index__>

=head2 Graphics

Graphical views of entities may be created and saved as jpg, png or svg files,
using the command C<$ent-E<gt>draw()>. Visio vdx files may also be created.

L<Back to Top|/__index__>

=head2 Info Browser

The text for Info Browser views of entities may be created using the command
C<$ent-E<gt>ib()>.

L<Back to Top|/__index__>

=head2 Lexer

A lexical stream may be generated for a file entity, if the original file
exists and is unchanged from the last database reparse. The lexical stream
is created with C<$ent-E<gt>lexer()>. Individual lexemes (tokens) may be
accessed for a lexer object, either sequentially with
C<$lexer-E<gt>first()> and C<$lexeme-E<gt>next()>, or as an array with
C<$lexer-E<gt>lexemes()>. Each lexeme object indicates its token kind
(C<$lexeme-E<gt>token()>), its text (C<$lexeme-E<gt>text()>), its referenced
entity (C<$lexeme-E<gt>ent()>) and its line and column position.

L<Back to Top|/__index__>


=head2 Gui

When a script is being run from within the Understand application, the class
Gui becomes available. This class gives access to the current open database
and information about the cursor position and current selection for the file
being edited.

L<Back to Top|/__index__>

=head2 Kind Filters

Kind filters are conceptually fairly simple, and in practice are also fairly
easy to use. However, there are many details involved that can make
documenting them quite daunting.

There are approximately 75 to 150 different defined kinds of entities and
references, depending on the language. Some concepts of kind are simple to
describe in some languages. For example, there is a single kind which
represents file entities in Ada. However, in C++ there are three different
kinds which represent different kinds of files. (Actually, there is a fourth
kind, but it is used internally only and should not occur in usage of this
api).

Each distinct kind is represented by a string of tokens that read together
something like a sentence. A Kind string always has a token representing
language (C, Ada, Fortran, Java, Jovial or Pascal), and one more more tokens
which describe the kind. The tokens have been chosen to be common, when
appropriate, among several similar kinds. For example, in C++, the three
kinds of files are "C Code File", "C Header File" and "C Unknown Header File".
Notice how the token "File" is common to all three kinds and the token
"Header" is common to two of the kinds? This is very important when
specifying a filter.

A filter string is used to match one or more related or unrelated kinds,
for purposes of selecting entities or references from the database. In order
for a filter string to match a kind, each token in the filter string must be
present as a token in the kind string. This can be thought of as an "and"
relationship. For example, the filter "File" will match all three C file
kinds, since all three have the token "File" in their strings. The filter
"Header File" will match the two C file kinds that have both "Header" and
"File" in their strings.

A filter string may use the tilde "~" to indicate the absence of a token.
So, again for example, the filter string "File ~Unknown" will match the two
C file kinds that both have the token "File" in their string and also do not
have the token "Unknown" in their string.

In addition to "and" filters, "or" filters can also be constructed with
the comma"," Groups of tokens separated by a comma are essentially treated as
different filters. When each filter is calculated the results are combined
with duplicates discarded. So, the filter string "Code File, Header File"
will again match two of the C file kinds.

With proper knowledge of all the kinds available, kind filters can provide
a powerful mechanism for selecting entities and references. On the one hand,
specifying "File" will match all file kinds; on the other hand, "Undefined"
will match undefined files in addition to all other entity kinds that
represent the concept "undefined".

L<Back to Top|/__index__>

=head1 Examples

The following examples are meant to be complete, yet simplistic, scripts
that demonstrate one or more features each. For the sake of brevity and
readability, common elements, such as testing the open $status or sorting,
are not repeated in each example. Most examples are for C++; however, Ada,
Fortran, Java, Jovial and Pascal examples would be very similar.

L<Back to Top|/__index__>

=head3 Sorted list of All Entities

  # test open status
  use Understand;
  ($db, $status) = Understand::open("test.udb");
  die "Error status: ",$status,"\n" if $status;

  # sort function
  foreach $ent (sort {$a->name() cmp $b->name();} $db->ents()) {

    # print entity and its kind
    print $ent->name(),"  [",$ent->kindname(),"]\n";
  }

L<Back to Top|/__index__>


=head3 List of Files

  use Understand;
  $db = Understand::open("test.udb");
  foreach $file ($db->ents("File")) {

    # print the long name (ie, show directory names)
    print $file->longname(),"\n";
  }

L<Back to Top|/__index__>


=head3 Lookup an entity

  use Understand;
  $db = Understand::open("test.udb");

  # find all 'File' entities that match test*.cpp
  foreach $file ($db->lookup("test*.cpp","File")) {
    print $file->name(),"\n";
  }

L<Back to Top|/__index__>

=head3 Global Variable Usage

  use Understand;
  $db = Understand::open("test.udb");
  foreach $var ($db->ents("Global Object ~Static")) {
    print $var->name(),":\n";
    foreach $ref ($var->refs()) {
      printf "  %-8s %-16s %s (%d,%d)\n",
        $ref->kindname(),
        $ref->ent()->name(),
        $ref->file()->name(),
        $ref->line(),
        $ref->column();
    }
    print "\n";
  }

L<Back to Top|/__index__>

=head3 List of Functions with Parameters

  use Understand;
  $db = Understand::open("test.udb");
  foreach $func ($db->ents("Function")) {
    print $func->longname(),"(";
    $first = 1;

    # get list of refs that define a parameter entity
    foreach $param ($func->ents("Define","Parameter")) {
      print ", " unless $first;
      print $param->type()," ",$param->name;
      $first = 0;
    }
    print ")\n";
  }

L<Back to Top|/__index__>

=head3 List of Functions with Associated Comments

  use Understand;
  $db = Understand::open("test.udb");
  foreach $func ($db->ents("function ~unresolved ~unknown")) {
    @comments = $func->comments("after");
    if (@comments) {
      print $func->longname(),":\n";
      foreach $comment (@comments) {print "  ",$comment,"\n";}
      print "\n";
      }
  }

L<Back to Top|/__index__>

=head3 List of Ada Packages

  use Understand;
  $db = Understand::open("test.udb");

  print "Standard Packages:\n";
  foreach $package ($db->ents("Package")) {
    print "  ",$package->longname(),"\n"
      if ($package->library() eq "Standard");
  }

  print "\nUser Packages:\n";
  foreach $package ($db->ents("Package")) {
    print "  ",$package->longname(),"\n"
      if ($package->library() ne "Standard");
  }

L<Back to Top|/__index__>

=head3 All Project Metrics

  use Understand;
  $db = Understand::open("test.udb");

  # loop through all project metrics
  foreach $met ($db->metrics()) {
    print $met," = ",$db->metric($met),"\n";
  }

L<Back to Top|/__index__>


=head3 Cyclomatic Complexity of Functions

  use Understand;
  $db = Understand::open("test.udb");

  # lookup a specific metric
  foreach $func ($db->ents("Function")) {
    $val = $func->metric("Cyclomatic");

    # only if metric is defined for entity
    print $func->name()," = ",$val,"\n" if defined($val);
  }

L<Back to Top|/__index__>

=head3 Called By Graphs of Functions

  use Understand;
  $db = Understand::open("test.udb");

  # loop through all functions
  foreach $func ($db->ents("Function")) {
    $file = "callby_" . $func->name() . ".png";
    print $func->longname(), " -> ", $file,"\n";
    $func->draw("Called By",$file);
  }

L<Back to Top|/__index__>

=head3 Info Browser view of Functions

  use Understand;
  $db = Understand::open("test.udb");

  # loop through all functions
  foreach $func ($db->ents("Function")) {
    print $func->ib(),"\n";
  }

L<Back to Top|/__index__>


=head3 Lexical stream

  use Understand;
  $db = Understand::open("test.udb");

  # lookup file entity, create lexer
  $file = $db->lookup("test.cpp");
  $lexer = $file->lexer();

  # regenerate source file from lexemes
  # add a '@' after each entity name
  foreach $lexeme ($lexer->lexemes()) {
    print $lexeme->text();
    if ($lexeme->ent()) {
      print "@";
    }
  }

L<Back to Top|/__index__>

=head3 Gui access

  # This script is only designed to run from within the understand application
  use Understand;
  die "Must be run from within Understand" if !Understand::Gui::active();
  die "Must be run with a db open" if !Understand::Gui::db();

  my $db = Understand::Gui::db();
  printf("Database: %s\n",$db->name());

  my $filename = Understand::Gui::filename();
  my $col      = Understand::Gui::column();
  my $line     = Understand::Gui::line();
  printf("File '%s' [%d,%d]\n",$filename,$line,$col) if ($filename);

  my $entity = Understand::Gui::entity();
  printf("Entity '%s'\n",$entity->name()) if $entity;

  my $selection = Understand::Gui::selection();
  my $word = Understand::Gui::word();
  printf("Selection '%s'\n",$selection) if $selection;
  printf("Word '%s'\n",$word) if $word;

L<Back to Top|/__index__>

=head3 Annotations

  use Understand;
  $db = Understand::open("test.udb");

  #retrieve all annotations for the database
  my ($atns_ref, $err) = $db->annotations();

  #report any errors
  print "Error: $err\n";

  #report the number of annotations
  print "Annotations: ", scalar @$atns_ref, "\n";

  #print annotations
  foreach my $atn (@$atns_ref) {
    if(defined($atn->ent())){
      print $atn->ent()->name(), "\n";
    }
    else {
      print "orphaned\n";
    }
    print $atn->author(),"\n", $atn->date(),"\n", $atn->text(), "\n\n";
  }

L<Back to Top|/__index__>

=head1 Reference

=head2 Understand package

=head4 Understand::license(name)

  Specify a regcode string, or a specific path to an Understand license.

L<Back to Top|/__index__>

=head4 Understand::open(path)

  Open a database. Returns ($db, $status). $db is an object in the
  class Understand::Db. $status, if defined, will be:

    "DBAlreadyOpen"      - only one database may be open at once
    "DBCorrupt"          - sorry, bad database file
    "DBOldVersion"       - database needs to be rebuilt
    "DBUnknownVersion"   - database needs to be rebuilt
    "DBUnableOpen"       - database is unreadable or does not exist
    "NoApiLicense"       - Understand license required

L<Back to Top|/__index__>

=head4 Understand::version()

  Return the build number for the current installed uperl module.

L<Back to Top|/__index__>

=head2 Understand::Db class

=head4 C<$db-E<gt>annotations()>

  Return ($atns, $err) where $atns is an array of Understand::Atn containing
  all the annotations for the database and err is a string describing any errors
  that took place. The "Could not find file" error is only given the first time
  annotations are used, and thereafter the missing file is ignored.

L<Back to Top|/__index__>

=head4 C<$db-E<gt>archs($ent)>

  Returns the list of architectures that contain entity $ent.

L<Back to Top|/__index__>

=head4 C<$db-E<gt>close()>

  Closes a database so that another database may be opened. This is not
  available when run from within the Understand application.

L<Back to Top|/__index__>

=head4 C<$db-E<gt>docformat($header, $body, $footer )>

  Sets the comment format for the database for use with the
  Understand::Doc module.  Using this module, it is possible to
  extract structured information from the comments associated with an
  entity.  The comments will be searched based on the patterns
  specified by $header, $body, and $footer.  Each of these is a
  regular expression using '~<pattern>&<tag>~' construct to designate
  a pattern which should be associated with a contextual tag.

  Precisely, the pattern will first be searched for the $header
  expression at the beginning of the comment, followed by a maximimal
  number of matches of the $body pattern, closing with one instance
  of the $footer pattern.  If any of the patterns do not match, they
  will be skipped, and no tags for that section will be generated.

  The comment format is based on perl regular expressions, with a new
  operator for saving sub-patterns. '(' and ')' will perform grouping,
  but they will not save information and behave identically to '(?:'.
  Sub-patterns can be saved using the '~<pattern>&<tag>~' format, where
  the text matching <pattern> will be stored in the doc object under
  the tag <tag>.  The tag '@' will produce a tag entry with the name
  of the first '@' pattern in the match.

  For example, to match javadoc-format strings in the body of the
  message, the call:
      $db->docformat('', '\@~\w+&@~ - ~[^$]*&@~', '');
  would set the format to recognize the first word after the @ symbol
  to be a javadoc tagname, and store the name and the rest of the line
  under the name of the javadoc tag.

L<Back to Top|/__index__>

=head4 C<$db-E<gt>draw( $kind, $filename [,$options] )>

  Generates a project graphics file. The $filename parameter must end with
  the extension .jpg, .png, .dot, .vdx or .svg.  This command is not supported
  when running scripts through the command line tool und.

  A status string will be returned if there is an error.

  The $kind parameter should specify the kind of graph for the entity. This will
  vary by language, but the $kind parameter will be the same as the graph name in
  the Understand GUI. Some examples would be:

    "File Dependencies"
    "UML Class Diagram"

  The optional string $options may be used to specify some parameters used
  to generate the graphics. The format of the options string is "name=value".
  Multiple options are separated with a semicolon. Spaces are allowed and
  are significant between multi-word field names, whereas, case is not significant
  The valid names and values are the same as appear in that graphs right click menu
  and vary by view. They may be abbreviated to any unique prefix of their full names.
  Some example options string:
    "Layout=Crossing; name=Fullname;Level=All Levels"
    "Display Preceding Comments=On;Display Entity Name=On"

L<Back to Top|/__index__>

=head4 C<$db-E<gt>ent_from_id($id)>

  Returns an entity from the numeric identifier obtained from $ent->id().
  This should only be called for identifiers that have been obtained
  while the database has remained open. When a database is reopened the
  identifier is not guaranteed to remain consistent and refer to the
  same entity.

L<Back to Top|/__index__>

=head4 C<$db-E<gt>ents( [$kindstring] )>

  Returns a list of entities. If the optional parameter $kindstring is not
  passed, then all entities in the database are returned. Otherwise,
  $kindstring should be a language-specific entity filter string.
  Each returned entity is an object in the class Understand::Ent.

L<Back to Top|/__index__>

=head4 C<$db-E<gt>language()>

  If called in an array context, returns a list of languages used in the
  database. Otherwise, returns a string of languages, separated by spaces.
  Possible language names are:"Ada", "C", "C#", "Fortran", "Java", "Jovial",
  "Pascal", "Plm", "VHDL" or "Web". C++ is included with "C".

L<Back to Top|/__index__>

=head4 C<$db-E<gt>lookup($name [,$kindstring] [,$case])>

  Returns a list of entities that match the specified $name. The special
  character '?' may be used to indicate a match of any single character
  and the special character '*' may be used to indicate a match of 0 or
  more characters. If the optional parameter $kindstring is passed, it
  should be a language-specific entity filter string. If the optional
  parameter $case is passed, it should be 0 to mean case-insensitive
  and 1 to mean case-sensitive lookup. The default is case-insensitive.

L<Back to Top|/__index__>

=head4 C<$db-E<gt>lookup_arch($longname)>

  Lookup the architecture by longname and return an Arch object or undef
  if it is not found.

L<Back to Top|/__index__>

=head4 C<$db-E<gt>lookup_snapshot($name)>

  Lookup the snapshot by name and return a Snapshot object or undef if it
  is not found.

L<Back to Top|/__index__>

=head4 C<$db-E<gt>lookup_uniquename($uniquename)>

  Returns the entity identified by uniquename, or UNDEF if no entity is
  found. Uniquename is the name returned by $ent->uniquename().

L<Back to Top|/__index__>

=head4 C<$db-E<gt>metric(@metriclist)>

  Returns a project metric value for each specified metric name in
  @metriclist

L<Back to Top|/__index__>

=head4 C<$db-E<gt>metrics()>

  Returns a list of all project metric names.

L<Back to Top|/__index__>

=head4 C<$db-E<gt>metrics_treemap($file,$sizemetric,$colormetric[,$enttype[,$arch]]))>

  Export a metrics treemap to the given $file (must be jpg or png). The parameters
  $sizemetric and $colormetric should be the API names of the metrics. The optional
  parameter $arch is the group-by arch. If none is given, the graph will be flat.
  The optional parameter $enttype is the type of entities to use in the treemap. It
  must be a string either "file" "class" or "function". If none is given,
  file is assumed. Note: This function cannot be run from und (Understand::CommandLine).

L<Back to Top|/__index__>

=head4 C<$db-E<gt>name()>

  Returns the filename of the database.

L<Back to Top|/__index__>

=head4 C<$db-E<gt>root_archs()>

  Returns the list of root architectures for the database.

L<Back to Top|/__index__>

=head4 C<$db-E<gt>snapshots()>

  Returns the list of snapshots in the database.

L<Back to Top|/__index__>

=head2 Understand::Arch class

=head4 C<$arch-E<gt>name()>

  Return the short name of the architecture.

L<Back to Top|/__index__>

=head4 C<$arch-E<gt>longname()>

  Return the long name of the architecture.

L<Back to Top|/__index__>

=head4 C<$arch-E<gt>parent()>

  Return the parent of the architecture or undef if it is a root.

L<Back to Top|/__index__>

=head4 C<$arch-E<gt>children()>

  Return the children of the architecture.

L<Back to Top|/__index__>

=head4 C<$arch-E<gt>ents([$recursive])>

  Return the entities within the architecture. If recursive is specified
  and is true, the list will also include all the entities from all nested
  architectures.

L<Back to Top|/__index__>

=head4 C<$arch-E<gt>depends([recursive [,group]])>

  Return the dependencies of the class or file as an Understand::Dep
  object. If recursive is true, the architectures children will also
  be considered. If group is true, the keys will be grouped into as
  few keys as possible. By default, recursive is true, and group is
  false. For example, given an architecture structure:

  All
    Bob
      Lots of entitites
    Sue
      Current
        Lots of entities
      Old
        Lots of entities

  calling Sue.depends(0) would result in an undefined Understand::Dep,
  because Sue's children are not considered, and there are no entities
  directly inside Sue. Calling Bob.depends(1,1) would result in an
  Understand::Dep with a single key (Sue) as opposed to two keys
  (Sue/Current and Sue/Old).

L<Back to Top|/__index__>

=head4 C<$arch-E<gt>dependsby([recursive [,group]])>

  Return the dependencies of the class or file as an Understand::Dep
  object. If recursive is true, the architectures children will also
  be considered. If group is true, the keys will be grouped into as
  few keys as possible. By default, recursive is true, and group is
  false. For more information, see the help for $arch-E<gt>depends.

L<Back to Top|/__index__>

=head4 C<$arch-E<gt>contains($entity [,$recursive])>

  Return true if the entity is contained within the architecture. If
  $recursive is specfified and is true, also consider all nested
  architectures as well.

L<Back to Top|/__index__>

=head4 C<$arch-E<gt>metric(@metriclist)>

  Returns a metric value for each specified metric name in @metriclist.

L<Back to Top|/__index__>

=head4 C<$arch-E<gt>metrics()>

  Returns a list of all metric names that are defined for the architecture.

L<Back to Top|/__index__>

=head2 Understand::Dep class

=head4 C<$dep-E<gt>keys()>

  Return all the keys in the dep object. These may be Understand::Ent
  or Understand::Arch depending on whether the object was created from
  $ent->depends() or $arch->depends().

L<Back to Top|/__index__>

=head4 C<$dep-E<gt>value($key)>

  Return the value for the given key. The value is an array of
  references that occur within that key.

L<Back to Top|/__index__>

=head4 C<$dep-E<gt>values()>

  Return all the values in the dep object. This is returned as an
  array of Understand::Ref objects.

L<Back to Top|/__index__>

=head2 Understand::Ent class

=head4 C<$ent-E<gt>annotations()>

  Return ($atns, $err) where $atns is an array of Understand::Atn containing
  all the annotations for the entity and err is a string describing any errors
  that took place. The "Could not find file" error is only given the first time
  annotations are used, and thereafter the missing file is ignored.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>comments( [$style [,$format [,$refkindstring]]] )>

  Returns a formatted string based on comments that are associated with
  an entity.

  The optional parameter $style is used to specify which comments are
  to be used. By default, comments that come after the entity
  declaration are processed. Here is a summary of all values that may be
  specified for $style:

    default - same as 'after'
    after   - process comments after the entity declaration
    before  - process comments before the entity declaration

  The optional parameter $format is used to specify what kind of
  formatting, if any, is applied to the comment text.

    default - removes comment characters and certain repeating
              characters, while retaining the original newlines
    raw     - return an array of comment strings in original format,
              including comment characters

  If the optional parameter $refkindstring is specified, it should be a
  language-specific reference filter string. For C++, the default is
  "definein", which is almost always correct. However, to see comments
  associated with member declarations, "declarein" should be used. For
  Ada there are many declaration kinds that may be used, including
  "declarein body", "declarein spec" and "declarein instance".

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>contents()>

  Return the text contents for the entity. Only certain entities are
  supported, such as files and defined functions. The contents from
  snapshots are properly supported.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>depends()>

  Return the dependencies of the class or file as an Understand::Dep
  object.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>dependsby()>

  Return an Understand::Dep object dependencies on the class or file.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>doc( [$style [, $format [, $refkindstring]]] )>

  Generates an Understand::Doc object based on the entity comments and
  the format strings specified in Understand::Db::docformat().  In
  particular, it performs the searching explained in docformat() on the
  comments selected by the arguments.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>draw( $kind, $filename [,$options] )>

  Generates a graphics file for an entity. The $filename parameter must end with
  the extension .jpg, .png, .dot, .vdx or .svg.  This command is not supported
  when running scripts through the command line tool und.

  A status string will be returned if there is an error.

  The $kind parameter should specify the kind of graph for the entity. This will
  vary by language and entity, but the $kind parameter will be the same as the
  graph name in the Understand GUI. Some examples would be:

    "Base Classes"
    "Butterfly"
    "Called By"
    "Control Flow"
    "Calls"
    "Declaration"
    "Depends On"

  The optional string $options may be used to specify some parameters used
  to generate the graphics. The format of the options string is "name=value".
  Multiple options are separated with a semicolon. Spaces are allowed and
  are significant between multi-word field names, whereas, case is not significant
  The valid names and values are the same as appear in that graphs right click menu
  and vary by view. They may be abbreviated to any unique prefix of their full names.
  Some example options string:
    "Layout=Crossing; name=Fullname;Level=All Levels"
    "Display Preceding Comments=On;Display Entity Name=On"

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>ents( $refkindstring [,$entkindstring] )>

  Returns a list of entities that reference, or are referenced by, the
  entity. $refkindstring should be a language-specific reference filter
  string. If the optional parameter $entkindstring is not passed, then
  all referenced entities are returned. Otherwise, $entkindstring should be
  a language-specific entity filter string that specifies what kind of
  referenced entities are to be returned. Each returned entity is an object
  in the class Understand::Ent.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>filerefs( [$refkindstring [,$entkindstring [, $unique]]] )>

  Returns a list of all references that occur in the specified file entity.
  These references will not necessarily have the file entity for their ->scope
  value. If the optional parameter $refkindstring is not passed, then all
  references are returned. Otherwise, $refkindstring should be a
  language-specific reference filter string. If the optional parameter
  $entkindstring is not passed, then all references to any kind of entity
  are returned. Otherwise, $entkindstring should be a language-specific
  entity filter string that specifies references to what kind of referenced
  entity are to be returned. If the optional parameter $unique is passed with
  value 1, only the first matching reference to each unique entity is returned.

  Each returned reference is an object in the class Understand::Ref.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>ib( [,$options] )>

  Returns a list of lines of text, representing the Info Browser
  information for an entity.

  The optional string $options may be used to specify some parameters used
  to create the text. The format of the options string is "name=value" or
  "{field-name}name=value". Multiple options are separated with a semicolon.
  Spaces are allowed and are significant between multi-word field names,
  whereas, case is not significant. An option that specifies a field name
  is specific to that named field of the Info Browser. The available field
  names are exactly as they appear in the Info Browser. When a field is
  nested within another field, the correct name is the two names combined.
  For example, in C++, the field Macros within the field Local would be
  specified as "Local Macros".

  A field and its subfields may be disabled by specifying levels=0, or
  by specifying the field off, without specifying any option. For example,
  either of the will disable and hide the Metrics field:

     {Metrics}levels=0;
     {Metrics}=off;

  The following option is currently available only without a field name.

    Indent  - this specifies the number of indent spaces to output for
              each level of a line of text. The default is 2.

  Other options are the same as are displayed when right-clicking on the
  field name in the Understand tool. No defaults are given for these
  options, as the defaults are specific for each language and each field
  name

  An example of a properly formatted option string would be:
  "{Metrics}=off;{calls}levels=-1;{callbys}levels=-1;{references}sort=name"

  The Architectures field is not generated by this command and can be
  generated separately using $db->archs($ent)

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>id()>

  Returns a numeric identifier which is unique for each underlying database
  entity. The identifier is not guaranteed to remain consistent after the
  database has been updated. An id can be converted back into an object of
  the class Understand::Ent with $db->ent_from_id($id).

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>kind()>

  Returns a kind object from class Understand::Kind for the entity.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>kindname()>

  Returns a simple name for the kind of the entity. This is equivalent
  to $ent->kind()->name().

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>language()>

  Returns a string indicating the language of the entity. Possible
  return values include "Ada", "C", "C#", "Fortran", "Java", "Jovial", "Pascal",
  "Plm", "VHDL" and "Web". C++ is included as part of "C".

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>lexer( [$lookup_ents [,$tabstop [,$show_inactive [,$expand_macros]]]] )>

  Returns a lexer object for the specified file entity. The original
  source file must be readable and unchanged since the last database parse.
  If called in an array context, returns ($lexer, $status). $status will be
  undef if no error occurs, or will be:

    "FileModified"        - the file must not be modified since the last parse
    "FileUnreadable"      - the file must be readable from the original location
    "UnsupportedLanguage" - the file language is not supported

  The optional parameter, $lookup_ents, is true by default. If it is
  specified false, the lexemes for the constructed lexer will not have
  entity or reference information, but the lexer construction will be
  much faster.

  The optional parameter, $tabstop, is 8 by default. If it is specified it
  must be greater than 0, and is the value to use for tab stops.

  The optional parameter $show_inactive is true by default. If false,
  inactive lexemes will not be returned.

  The optional parameter $expand_macros is false by default. If true,
  and if macro expansion text is stored, lexemes that are macros will
  be replaced with the lexeme stream of the expansion text.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>library()>

  Returns the name of the library that the entity belongs to, or undef
  if it does not belong to a library.

  Predefined Ada entities such as 'text_io' will bin the 'Standard' library.
  Predefined VHDL entities will be in either the 'std' or 'ieee' libraries.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>longname($preserve_named_root=false)>

  Returns the long name of the entity. If there is no long name defined
  the regular name ($ent->name()) is returned. Examples of entities with
  long names include files, c++ members and most ada entities.

  For file entities, if $preserve_named_root is true, if a long filename
  includes a named root, it is preserved; otherwise, the named root is
  expanded to return the regular absolute filename.

  If run from Understand, the named root will be inherited from the GUI,
  otherwise, the named root will need to be specified with an environment
  variable of the form UND_NAMED_ROOT_<named root name without trailing colon>.
  For example to create the named root HOME_DIR:=c:\projects\home run the
  following in your script:
    $ENV{'UND_NAMED_ROOT_HOME_DIR'} = 'c:\\projects\\home';

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>macroexpansion($name,$line,$column))>

  Returns the expansion text for the named macro at the line and column in the
  file entity. If called in an array context it returns the expansion text and
  a boolean value indicating if there was an expansion or not. Thus, a false
  status indicates that an empty expansion string was not the result of an
  expansion.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>metric(@metriclist)>

  Returns a metric value for each specified metric name in @metriclist.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>metrics()>

  Returns a list of all metric names that are defined for the entity.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>name()>

  Returns the short name for the entity. For Java, this may return a name
  with a single dot in it. Use $ent->simplename() to obtain the simplest,
  shortest name possible.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>parameters([$shownames])>

  Returns a string (or array if called from an array context) of parameter
  types and names for an entitry. If the optional parameter $shownames is
  false only the types, not the names, of the parameters are returned. There
  are some language-specific cases where there are no entities in the database
  for certain kinds of parameters. For example, in c++, there are no database
  entities for parameters for functions that are only declared, not defined,
  and there are no database entities for parameters for functional macro
  definitions. This method can be used to get some information about these
  cases.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>parent()>

  Return the parent entity of the entity or undef if not defined.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>parsetime()>

  Returns the last time the file entity was parsed in the database. Returns
  0 if the entity is not a parsed file. The time is in Unix/POSIX Time.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>refs( [$refkindstring [,$entkindstring [, $unique]]] )>

  Returns a list of references. If the optional parameter $refkindstring
  is not passed, then all references for the entity are returned. Otherwise,
  $refkindstring should be a language-specific reference filter string. If
  the optional parameter $entkindstring is not passed, then all references
  to any kind of entity are returned. Otherwise, $entkindstring should be
  a language-specific entity filter string that specifies references to
  what kind of referenced entity are to be returned. If the optional
  parameter $unique is passed with value 1, only the first matching
  reference to each unique entity is returned.

  Each returned reference is an object in the class Understand::Ref.

  In a scalar context, only the first reference is returned.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>ref( [$refkindstring [,$entkindstring]] )>

  Return the first reference for the entity. This is really the same as
  calling $ent->refs() from a scalar context.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>relname()>

  Return the relative name of the file entity. Return the fullname for
  the file, minus any root directories that are common for all project
  files. Return undef for non-file entities.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>simplename()>

  Returns the simple name for the entity. This is the simplest, shortest
  name possible for the entity. It is generally the same as $ent->name()
  except for languages like Java, for which this will not return a name
  with any dots in it.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>type()>

  Returns the type string of the entity. This is defined for entity kinds
  like variables and type, as well as entity kinds that have a return type
  like functions.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>uniquename()>

  Returns the uniquename of the entity. This name is not suitable for use
  by an end user. Rather, it is a means of identifying an entity uniquely
  in multiple databases, perhaps as the source code changes slightly over
  time. The uniquename is composed of things like parameters and parent
  names. So, some code changes will result in new uniquenames for the same
  instrinsic entity. Use $db->lookup_uniquename() to convert a
  uniquename back to an object of Understand::Ent.

L<Back to Top|/__index__>

=head4 C<$ent-E<gt>value()>

  Returns the value associated with enumerators, initialized variables and
  macros (not all languages are supported).

L<Back to Top|/__index__>

=head2 Understand::Doc class

=head4 C<$doc-E<gt>body()>

  Returns the unmatched section of comments from the entity.

L<Back to Top|/__index__>

=head4 C<$doc-E<gt>tag($name [, $sections] )>

  Returns a list of values associated with the tag $name for the given
  documentation object.  If $sections is specified, it should contain
  one or more of the following words:

     header
     body
     footer

  If $sections is specified, $doc->tag($name,$sections) will only
  return tag elements found in the specfied sections.

L<Back to Top|/__index__>

=head4 C<$doc-E<gt>tags( [$sections] )>

  Returns the names of all tags found for this entity.  If $sections is
  specified, it should contain one or more of the following words:

     header
     body
     footer

  If $sections is specified, $doc->tags($sections) will only
  return the names of tags found in the specfied sections.

L<Back to Top|/__index__>

=head2 Understand::Gui class

=head4 C<Understand::Gui::active()>

  Returns true if the script has been called from within the Understand
  application. No other functions in this class are available if this
  is not true.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::analyze($db,[$all])>

  Request the database be reanalyzed. If $all is specified and true, all
  files will be analyzed; otherwise, only changed files will be analyzed.
  It is critical that no database objects (entities, references, lexers,
  etc) be retained and used from before the analyze call.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::column()>

  Returns the column (zero based) of the cursor in the current file being edited, or
  returns 0 if no file is being edited.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::db()>

  Returns the current database. This database must not be closed.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::entity()>

  Returns the current entity at the cursor position, or undef if no file is
  being edited or if the cursor position does not contain an entity.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::file()>

  Returns the entity of the current project file being edited, or undef if no
  project file is being edited.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::filename()>

  Returns the name of the current file being edited, or undef if no file
  is being edited.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::flush()>

  Flush any pending output.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::line()>

  Returns the line of the cursor in the current file being edited, or
  returns 0 if no file is being edited.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::open_file(name,line,column)>

  Open a file at the given line and column (one based index).

L<Back to Top|/__index__>

=head4 C<Understand::Gui::open_files()>

  Returns a list of filenames for currently open files.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::progress_bar(percent)>

  Displays the progress bar, if percent is 0.0 or greater. If it is less
  than 0.0, the progress bar is hidden, if it is currently displayed. If
  it is greater than 1.0, then 1.0 is assumed.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::scope()>

  Returns the current entity in scope at the cursor position, or undef if no
  file is being edited or if the cursor position is not within an entity scope.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::selection()>

  Returns the selected text in the current file being edited, or
  returns 0 if no file is being edited or no text is selected.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::script()>

  Returns the name of the current script being run.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::tab_width()>

  Returns the tab width setting of the current file being edited, or returns 0 if
  no file is being edited.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::word()>

  Returns the word at the cursor position in the current file being edited,
  or returns 0 if no file is being edited.

L<Back to Top|/__index__>

=head4 C<Understand::Gui::yield()>

  Causes a potential yield event in the understand application, if it is
  needed. Normally, the following functions internally cause a yield:

    Understand::Db::Ents()
    Understand::Db::Metric()
    Understand::Ent::Ents()
    Understand::Ent::Lexer()
    Understand::Ent::Metric()
    Understand::Ent::Refs()

  If these functions are not called for long periods of time, it may be
  desirable to call yield() directly, to allow the understand application
  to respond to external events, such as window repaints.

L<Back to Top|/__index__>

=head2 Understand::CommandLine class

=head4 C<Understand::CommandLine::active()>

  Returns true if the script has been called from within und. No other
  functions in this class are available if this is not true.

L<Back to Top|/__index__>

=head4 C<Understand::CommandLine::db()>

  Returns the current database. This database must not be closed.

L<Back to Top|/__index__>

=head2 Understand::Kind class

=head4 C<$kind-E<gt>check($kindstring)>

  Returns true if the kind matches the filter $kindstring.

L<Back to Top|/__index__>

=head4 C<$kind-E<gt>inv()>

  Returns the logical inverse of a reference kind. This is not valid for
  entity kinds.

L<Back to Top|/__index__>

=head4 C<@Understand::Kind::list_entity([entkind])>

  Returns the list of entity kinds that match the filter $entkind.
  For example, the list of all c function entity kinds:
    my @kinds = Understand::Kind::list_entity("c function");

L<Back to Top|/__index__>

=head4 C<@Understand::Kind::list_reference([refkind])>

  Returns the list of reference kinds that match the filter $refkind.
  For example, the list of all ada declare reference kinds:
    my @kinds = Understand::Kind::list_reference("ada declare");

L<Back to Top|/__index__>

=head4 C<$kind-E<gt>longname()>

  Returns the long form of the kind name. This is usually more detailed
  than desired for human reading.

L<Back to Top|/__index__>

=head4 C<$kind-E<gt>name()>

  Returns the name of the kind.

L<Back to Top|/__index__>

=head2 Understand::Lexeme class

=head4 C<$lexeme-E<gt>column_begin()>

  Returns the beginning column number of the lexeme (zero based).

L<Back to Top|/__index__>

=head4 C<$lexeme-E<gt>column_end()>

  Returns the ending column number of the lexeme (zero based).

L<Back to Top|/__index__>

=head4 C<$lexeme-E<gt>ent()>

  Returns the entity associated with the lexeme, or undef if none.

L<Back to Top|/__index__>

=head4 C<$lexeme-E<gt>inactive()>

  Returns true if the lexeme is part of inactive code.

L<Back to Top|/__index__>

=head4 C<$lexeme-E<gt>line_begin()>

  Returns the beginning line number of the lexeme.

L<Back to Top|/__index__>

=head4 C<$lexeme-E<gt>line_end()>

  Returns the ending line number of the lexeme.

L<Back to Top|/__index__>

=head4 C<$lexeme-E<gt>next()>

  Returns the next lexeme, or undef if at end of file.

L<Back to Top|/__index__>

=head4 C<$lexeme-E<gt>nextUseful()>

  Returns the next lexeme that is not whitespace, comment, newline or undef if at end of file.

L<Back to Top|/__index__>

=head4 C<$lexeme-E<gt>previous()>

  Returns the previous lexeme, or undef if at beginning of file.

L<Back to Top|/__index__>

=head4 C<$lexeme-E<gt>prevUseful()>

  Returns the previous lexeme that is not whitespace, comment, newline or undef if at beginning of file.

L<Back to Top|/__index__>

=head4 C<$lexeme-E<gt>ref()>

  Returns the reference associated with the lexeme, or undef if none.

L<Back to Top|/__index__>

=head4 C<$lexeme-E<gt>text()>

  Returns the text for the lexeme.

L<Back to Top|/__index__>

=head4 C<$lexeme-E<gt>token()>

  Returns the token kind of the lexeme. Values include:

    "Comment"
    "Continuation"
    "EndOfStatement"
    "Identifier"
    "Keyword"
    "Label"
    "Literal"
    "Newline"
    "Operator"
    "Preprocessor"
    "Punctuation"
    "String"
    "Whitespace"

L<Back to Top|/__index__>

=head2 Understand::Lexer class

=head4 C<$lexer-E<gt>first()>

  Returns the first lexeme for the lexer.

L<Back to Top|/__index__>

=head4 C<$lexer-E<gt>lexeme($line,$column)>

  Returns the lexeme that occurs at the specified line and column (zero based).

L<Back to Top|/__index__>

=head4 C<$lexer-E<gt>lexemes([$start_line,$end_line])>

  Returns an array of all lexemes. If the optional parameters $start_line
  and $end_line are specified, only the lexemes within these lines are
  returned.

L<Back to Top|/__index__>

=head4 C<$lexer-E<gt>lines()>

  Returns the number of lines in the lexer.

L<Back to Top|/__index__>

=head2 Understand::Metric class

=head4 C<Understand::Metric::description($metric)>

  Returns the short description of a metric.

L<Back to Top|/__index__>

=head4 C<Understand::Metric::list([$kindstring])>

  Returns a list of metric names. If the optional parameter $kindstring is
  not passed, then the names of all possible metrics are returned. Otherwise,
  only the names of metrics defined for entities that match the entity
  filter $kindstring are returned.

L<Back to Top|/__index__>

=head2 Understand::Ref class

=head4 C<$ref-E<gt>column()>

  Returns the column in source where the reference occurred. Zero based.

L<Back to Top|/__index__>

=head4 C<$ref-E<gt>ent()>

  Returns the entity being referenced. The returned entity is an object
  in the class Understand::Ent.

L<Back to Top|/__index__>

=head4 C<$ref-E<gt>file()>

  Returns the file where the reference occurred. The returned file is an
  object in the class Understand::Ent.

L<Back to Top|/__index__>

=head4 C<$ref-E<gt>kind()>

  Returns a kind object from the class Understand::Kind for the reference.

L<Back to Top|/__index__>

=head4 C<$ref-E<gt>kindname()>

  Returns a simple name for the kind of the reference. This is equivalent
  to $ref->kind()->name().

L<Back to Top|/__index__>

=head4 C<$ref-E<gt>lexeme()>

  Returns a lexeme object for the reference. Empty if no lexer or lexeme
  can be created

L<Back to Top|/__index__>


=head4 C<$ref-E<gt>line()>

  Returns the line in source where the reference occurred.

L<Back to Top|/__index__>

=head4 C<$ref-E<gt>scope()>

  Returns the entity performing the reference. The returned entity is an
  object in the class Understand::Ent.

L<Back to Top|/__index__>

=head4 C<$ref-E<gt>macroexpansion()>

  Returns the expanded text if there is a macro at that location and "save macro expansion text"
  is enabled in Project Configuration.

L<Back to Top|/__index__>

=head2 Understand::Snapshot class

=head4 C<$snapshot-E<gt>name()>

  Returns the name of the snapshot.

L<Back to Top|/__index__>

=head4 C<$snapshot-E<gt>open()>

  Opens the snapshot and returns a database object(Understand::Db) that may be used as such.
  For example:

  my $snapshot = $db->lookup_snapshot("yesterday");
  my $snapshot_db = $snapshot->open();

L<Back to Top|/__index__>

=head2 Understand::Util class

=head4 C<Understand::Util::checksum($text[,$len])>

  Returns a checksum of the text. The optional parameter $len specifies
  the length of the checksum, which may be between 1 and 32 characters,
  with 32 being the default.

L<Back to Top|/__index__>

=head2 Understand::Atn class

=head4 C<$atn-E<gt>author()>

  Return the author of the annotation.

L<Back to Top|/__index__>

=head4 C<$atn-E<gt>date()>

  Return the date the annotation was last modified as a string of the form
  YYYY-MM-DDTHH:MM:SS such as 2000-01-01T19:20:30.

L<Back to Top|/__index__>

=head4 C<$atn-E<gt>ent()>

  Return the entity this annotation belongs to. This may be undefined if the
  annotation is orphaned.

L<Back to Top|/__index__>

=head4 C<$atn-E<gt>text()>

  Return the text of the annotation.

L<Back to Top|/__index__>


=cut




=head1 Kind Filters



=head2 Ada Entity Kinds

Below are listed the general categories of Ada entity kinds. When these
categories are used literally, as filters, the full kind names that match
have been listed beneath them.


 Component
    Ada Component
    Ada Component Local
    Ada Variant Component
    Ada Variant Component Local
    Ada Discriminant Component
    Ada Discriminant Component Local

 Entry
    Ada Entry
    Ada Entry Body

 Exception
    Ada Exception
    Ada Exception Others
    Ada Exception Local
    Ada Exception Object Local

 File
    Ada File

 Function
    Ada Abstract Function
    Ada Abstract Function Local
    Ada Abstract Function Operator
    Ada Abstract Function Operator Local
    Ada Function
    Ada Function Secondary
    Ada Function External
    Ada Function External Secondary
    Ada Function Local
    Ada Function Local Secondary
    Ada Function Operator
    Ada Function Operator Secondary
    Ada Function Operator Local
    Ada Function Operator Local Secondary
    Ada Generic Function
    Ada Generic Function Secondary
    Ada Generic Function Local
    Ada Generic Function Local Secondary
    Ada Unresolved External Function

 Gpr Project
    Ada Gpr Project
    Ada Gpr Project Unknown
    Ada Gpr Project Unresolved

 Implicit
    Ada Implicit

 Literal
    Ada Enumeration Literal

 LiteralParam
    Ada LiteralParam Local

 Object
    Ada Constant Object
    Ada Constant Object External
    Ada Constant Object Local
    Ada Constant Object Deferred
    Ada Constant Object Deferred External
    Ada Exception Object Local
    Ada Loop Object Local
    Ada Object
    Ada Object External
    Ada Object Local
    Ada Protected Object
    Ada Protected Object Local
    Ada Task Object
    Ada Task Object Local
    Ada Unresolved External Object

 Package
    Ada Generic Package
    Ada Generic Package Secondary
    Ada Generic Package Local
    Ada Generic Package Local Secondary
    Ada Gpr Package
    Ada Gpr Package Unresolved
    Ada Package
    Ada Package Secondary
    Ada Package Local
    Ada Package Local Secondary

 Parameter
    Ada Parameter

 Procedure
    Ada Abstract Procedure
    Ada Abstract Procedure Local
    Ada Generic Procedure
    Ada Generic Procedure Secondary
    Ada Generic Procedure Local
    Ada Generic Procedure Local Secondary
    Ada Procedure
    Ada Procedure Secondary
    Ada Procedure External
    Ada Procedure External Secondary
    Ada Procedure Local
    Ada Procedure Local Secondary
    Ada Unresolved External Procedure

 Protected
    Ada Protected
    Ada Protected Secondary
    Ada Protected Local
    Ada Protected Local Secondary
    Ada Protected Object
    Ada Protected Object Local
    Ada Protected Type
    Ada Protected Type Secondary
    Ada Protected Type Local
    Ada Protected Type Local Secondary
    Ada Protected Type Private
    Ada Protected Type Limited Private

 Task
    Ada Task
    Ada Task Secondary
    Ada Task Local
    Ada Task Local Secondary
    Ada Task Object
    Ada Task Object Local
    Ada Task Type
    Ada Task Type Secondary
    Ada Task Type Local
    Ada Task Type Local Secondary
    Ada Task Type Private
    Ada Task Type Limited Private

 Type
    Ada Abstract Tagged Type Record
    Ada Abstract Tagged Type Record Local
    Ada Abstract Tagged Type Record Private
    Ada Abstract Tagged Type Record Limited Private
    Ada Gpr Type
    Ada Protected Type
    Ada Protected Type Secondary
    Ada Protected Type Local
    Ada Protected Type Local Secondary
    Ada Protected Type Private
    Ada Protected Type Limited Private
    Ada Tagged Type Record
    Ada Tagged Type Record Local
    Ada Tagged Type Record Private
    Ada Tagged Type Record Limited Private
    Ada Task Type
    Ada Task Type Secondary
    Ada Task Type Local
    Ada Task Type Local Secondary
    Ada Task Type Private
    Ada Task Type Limited Private
    Ada Type
    Ada Type Incomplete
    Ada Type Local
    Ada Type Private
    Ada Type Limited Private
    Ada Type Access
    Ada Type Access Local
    Ada Type Access Private
    Ada Type Access Limited Private
    Ada Type Access Subprogram
    Ada Type Access Subprogram Local
    Ada Type Access Subprogram Private
    Ada Type Access Subprogram Limited Private
    Ada Type Array
    Ada Type Array Local
    Ada Type Array Private
    Ada Type Array Limited Private
    Ada Type Enumeration
    Ada Type Enumeration Local
    Ada Type Enumeration Private
    Ada Type Enumeration Limited Private
    Ada Type Interface
    Ada Type Record
    Ada Type Record Local
    Ada Type Record Private
    Ada Type Record Limited Private

 Unknown
    Ada Gpr Project Unknown
    Ada Unknown

 Unresolved
    Ada Gpr Unresolved
    Ada Gpr Package Unresolved
    Ada Gpr Project Unresolved
    Ada Unresolved
    Ada Unresolved External Function
    Ada Unresolved External Object
    Ada Unresolved External Procedure

 Variable
    Ada Gpr Variable


L<Back to Top|/__index__>


=head2 Ada Reference Kinds

Below are listed the general categories of Ada reference kinds, both forward
and inverse relations. When these categories are used literally, as filters,
the full kind names that match have been listed beneath them.

 AccessAttrTyped (AccessAttrTypedby)
    Ada AccessAttrTyped

 Association (Associationby)
    Ada Association

 Call (Callby)
    Ada Call
    Ada Call Indirect
    Ada Call Access
    Ada Call Dispatch
    Ada Call Dispatch Indirect
    Ada Call Implicit

 CallParamFormal (CallParamFormalfor)
    Ada CallParamFormal

 Declare (Declarein)
    Ada Declare
    Ada Declare Body
    Ada Declare Body File
    Ada Declare Formal
    Ada Declare Incomplete
    Ada Declare Instance
    Ada Declare Instance File
    Ada Declare Private
    Ada Declare Spec
    Ada Declare Spec File
    Ada Declare Stub

 Derive (Derivefrom)
    Ada Derive

 Dot (Dotby)
    Ada Dot

 ElaborateBody (ElaborateBodyby)
    Ada ElaborateBody Implicit
    Ada ElaborateBody Ref

 End (Endby)
    Ada End
    Ada End Unnamed

 Handle (Handleby)
    Ada Handle

 Instance (Instanceof)
    Ada Declare Instance
    Ada Declare Instance File
    Ada Declarein Instance
    Ada Declarein Instance File
    Ada Instance
    Ada Instance Copy

 InstanceActual (InstanceActualfor)
    Ada InstanceActual

 InstanceParamFormal (InstanceParamFormalfor)
    Ada InstanceParamFormal

 Operation (Operationfor)
    Ada Operation
    Ada Operation Classwide

 Override (Overrideby)
    Ada Override

 Raise (Raiseby)
    Ada Raise
    Ada Raise Implicit

 Ref (Refby)
    Ada ElaborateBody Ref
    Ada Import Ref
    Ada Ref
    Ada Representation Ref
    Ada Ref Convert

 Rename (Renameby)
    Ada Rename

 Renamecall (Renamecallby)
    Ada Renamecall

 Root (Rootin)
    Ada Root

 Separate (Separatefrom)
    Ada Separate

 Set (Setby)
    Ada Set
    Ada Set Init
    Ada Set Partial

 Subtype (Subtypefrom)
    Ada Subtype

 Typed (Typedby)
    Ada Typed
    Ada Typed Implicit

 Use (Useby)
    Ada Abort Use
    Ada Gpr Extend Use
    Ada Use
    Ada Use Partial
    Ada Use Access

 UsePackage (UsePackageby)
    Ada UsePackage
    Ada UsePackage Needed

 UsePackageAccess (UsePackageAccessby)
    Ada UsePackageAccess

 UseType (UseTypeby)
    Ada UseType
    Ada UseType Needed

 UseTypeAccess (UseTypeAccessby)
    Ada UseTypeAccess

 Withaccess (Withaccessby)
    Ada Withaccess

 Parent (Child)
    Ada Parent Libunit

 With (Withby)
    Ada Gpr With
    Ada With Body
    Ada With Spec
    Ada With Needed Body
    Ada With Needed Spec
    Ada With Redundant Body
    Ada With Redundant Spec


=head2 Assembly Entity Kinds

Below are listed the general categories of Assembly entity kinds. When these
categories are used literally, as filters, the full kind names that match
have been listed beneath them.


 Class
    Assembly Class

 Common
    Assembly Common

 Data
    Assembly Data Constant Global
    Assembly Data Constant Local
    Assembly Data Constant Block Global
    Assembly Data Constant Block Local
    Assembly Data Variable Global
    Assembly Data Variable Local

 File
    Assembly File
    Assembly Unknown File
    Assembly Unresolved File

 Global Label
    Assembly Label Global

 Global Macro
    Assembly Macro Global

 Global Reserved
    Assembly Reserved Segment Global

 Global Symbol
    Assembly Symbol Global

 Local Label
    Assembly Label Local

 Local Macro
    Assembly Macro Local

 Local Reserved
    Assembly Reserved Segment Local

 Local Symbol
    Assembly Symbol Local

 Predefined Symbol
    Assembly Predefined Symbol

 Section
    Assembly Section

 Unknown Symbol
    Assembly Unknown Symbol

 Unresolved Macro
    Assembly Unresolved Macro

 Unresolved Symbol
    Assembly Unresolved Symbol


L<Back to Top|/__index__>


=head2 Assembly Reference Kinds

Below are listed the general categories of Assembly reference kinds, both forward
and inverse relations. When these categories are used literally, as filters,
the full kind names that match have been listed beneath them.

 Call (Callby)
    Assembly Call

 Declare (Declarein)
    Assembly Declare

 Define (Definein)
    Assembly Define

 Include (Includeby)
    Assembly Include

 Set (Setby)
    Assembly Set

 Use (Useby)
    Assembly Use


=head2 Basic Entity Kinds

Below are listed the general categories of Basic entity kinds. When these
categories are used literally, as filters, the full kind names that match
have been listed beneath them.


 Const
    Basic Const Local
    Basic Friend Const Member Field
    Basic Protected Const Member Field
    Basic Protected Friend Const Member Field
    Basic Private Const Member Field
    Basic Public Const Member Field

 Enumerator
    Basic Enumerator
    Basic Unresolved Enumerator

 Event
    Basic Friend Member Event
    Basic Friend Member Event Shared
    Basic Protected Member Event
    Basic Protected Member Event Shared
    Basic Protected Friend Member Event
    Basic Protected Friend Member Event Shared
    Basic Private Member Event
    Basic Private Member Event Shared
    Basic Public Member Event
    Basic Public Member Event Shared
    Basic Unresolved Friend Member Event
    Basic Unresolved Friend Member Event Shared
    Basic Unresolved Protected Member Event
    Basic Unresolved Protected Member Event Shared
    Basic Unresolved Protected Friend Member Event
    Basic Unresolved Protected Friend Member Event Shared
    Basic Unresolved Private Member Event
    Basic Unresolved Private Member Event Shared
    Basic Unresolved Public Member Event
    Basic Unresolved Public Member Event Shared

 File
    Basic File
    Basic Dll File

 Method
    Basic Constructor Member Method Shared
    Basic Friend Constructor Member Method
    Basic Friend Member Function Method
    Basic Unresolved Friend Member Extern Friend Method
    Basic Friend Member Function Method MustOverride
    Basic Friend Member Function Method NotInheritable
    Basic Friend Member Function Method Overridable
    Basic Friend Member Function Method Shared
    Basic Friend Member Sub Method
    Basic Unresolved Friend Member Extern Sub Method
    Basic Friend Member Sub Method MustOverride
    Basic Friend Member Sub Method NotInheritable
    Basic Friend Member Sub Method Overridable
    Basic Friend Member Sub Method Shared
    Basic Protected Constructor Member Method
    Basic Protected Member Function Method
    Basic Unresolved Protected Member Extern Function Method
    Basic Protected Member Method Function MustOverride
    Basic Protected Member Method Function NotInheritable
    Basic Protected Member Method Function Overridable
    Basic Protected Member Method Function Shared
    Basic Protected Member Sub Method
    Basic Unresolved Protected Member Extern Sub Method
    Basic Protected Member Sub Method MustOverride
    Basic Protected Member Sub Method NotInheritable
    Basic Protected Member Sub Method Overridable
    Basic Protected Member Sub Method Shared
    Basic Protected Friend Constructor Member Method
    Basic Protected Friend Member Function Method
    Basic Unresolved Protected Friend Member Extern Function Method
    Basic Protected Friend Member Function Method MustOverride
    Basic Protected Friend Member Function Method NotInheritable
    Basic Protected Friend Member Function Method Overridable
    Basic Protected Friend Member Function Method Shared
    Basic Protected Friend Member Sub Method
    Basic Unresolved Protected Friend Member Extern Sub Method
    Basic Protected Friend Member Sub Method MustOverride
    Basic Protected Friend Member Sub Method NotInheritable
    Basic Protected Friend Member Sub Method Overridable
    Basic Protected Friend Member Sub Method Shared
    Basic Private Constructor Member Method
    Basic Private Member Function Method
    Basic Unresolved Private Member Extern Function Method
    Basic Private Member Function Method Shared
    Basic Private Member Sub Method
    Basic Unresolved Private Member Extern Sub Method
    Basic Private Member Sub Method Shared
    Basic Public Constructor Member Method
    Basic Public Member Function Method
    Basic Unresolved Public Member Extern Function Method
    Basic Public Member Function Method MustOverride
    Basic Public Member Function Method NotInheritable
    Basic Public Member Function Method Overridable
    Basic Public Member Function Method Shared
    Basic Public Member Sub Method
    Basic Unresolved Public Member Extern Sub Method
    Basic Public Member Sub Method MustOverride
    Basic Public Member Sub Method NotInheritable
    Basic Public Member Sub Method Overridable
    Basic Public Member Sub Method Shared
    Basic Unknown Member Method
    Basic Unresolved Constructor Member Method Shared
    Basic Unresolved Friend Constructor Member Method
    Basic Unresolved Friend Member Method
    Basic Unresolved Friend Extern Member Method
    Basic Unresolved Friend Member Method MustOverride
    Basic Unresolved Friend Member Method NotInheritable
    Basic Unresolved Friend Member Method Overridable
    Basic Unresolved Friend Member Method Shared
    Basic Unresolved Protected Constructor Member Method
    Basic Unresolved Protected Member Method
    Basic Unresolved Protected Extern Member Method
    Basic Unresolved Protected Member Method MustOverride
    Basic Unresolved Protected Member Method NotInheritable
    Basic Unresolved Protected Member Method Overridable
    Basic Unresolved Protected Member Method Shared
    Basic Unresolved Protected Friend Constructor Member Method
    Basic Unresolved Protected Friend Member Method
    Basic Unresolved Protected Friend Extern Member Method
    Basic Unresolved Protected Friend Member Method MustOverride
    Basic Unresolved Protected Friend Member Method NotInheritable
    Basic Unresolved Protected Friend Member Method Overridable
    Basic Unresolved Protected Friend Member Method Shared
    Basic Unresolved Private Constructor Member Method
    Basic Unresolved Private Member Method
    Basic Unresolved Private Extern Member Method
    Basic Unresolved Private Member Method Shared
    Basic Unresolved Public Constructor Member Method
    Basic Unresolved Public Member Method
    Basic Unresolved Public Extern Member Method
    Basic Unresolved Public Member Method MustOverride
    Basic Unresolved Public Member Method NotInheritable
    Basic Unresolved Public Member Method Overridable
    Basic Unresolved Public Member Method Shared

 Module
    Basic Friend Module
    Basic Protected Module
    Basic Protected Friend Module
    Basic Private Module
    Basic Public Module
    Basic Unresolved Module

 Namespace
    Basic Namespace Alias
    Basic Namespace
    Basic Unknown Namespace
    Basic Unresolved Namespace

 Parameter
    Basic Parameter ParamArray
    Basic Parameter Ref
    Basic Parameter Value
    Basic Type Parameter

 Property
    Basic Friend Member Property
    Basic Friend Member Property MustOverride
    Basic Friend Member Property NotInheritable
    Basic Friend Member Property Overridable
    Basic Friend Member Property Shared
    Basic Protected Member Property
    Basic Protected Member Property MustOverride
    Basic Protected Member Property NotInheritable
    Basic Protected Member Property Overridable
    Basic Protected Member Property Shared
    Basic Protected Friend Member Property
    Basic Protected Friend Member Property MustOverride
    Basic Protected Friend Member Property NotInheritable
    Basic Protected Friend Member Property Overridable
    Basic Protected Friend Member Property Shared
    Basic Private Member Property
    Basic Private Member Property Shared
    Basic Public Member Property
    Basic Public Member Property MustOverride
    Basic Public Member Property NotInheritable
    Basic Public Member Property Overridable
    Basic Public Member Property Shared
    Basic Unresolved Friend Member Property
    Basic Unresolved Friend Member Property MustOverride
    Basic Unresolved Friend Member Property NotInheritable
    Basic Unresolved Friend Member Property Overridable
    Basic Unresolved Friend Member Property Shared
    Basic Unresolved Protected Member Property
    Basic Unresolved Protected Member Property NotInheritable
    Basic Unresolved Protected Member Property MustOverride
    Basic Unresolved Protected Member Property Overridable
    Basic Unresolved Protected Member Property Shared
    Basic Unresolved Protected Friend Member Property
    Basic Unresolved Protected Friend Member Property MustOverride
    Basic Unresolved Protected Friend Member Property NotInheritable
    Basic Unresolved Protected Friend Member Property Overridable
    Basic Unresolved Protected Friend Member Property Shared
    Basic Unresolved Private Member Property
    Basic Unresolved Private Member Property Shared
    Basic Unresolved Public Member Property
    Basic Unresolved Public Member Property MustOverride
    Basic Unresolved Public Member Property NotInheritable
    Basic Unresolved Public Member Property Overridable
    Basic Unresolved Public Member Property Shared

 Type
    Basic Type Alias
    Basic Friend Type Class
    Basic Friend Type Class MustInherit
    Basic Friend Type Class NotInheritable
    Basic Friend Type Delegate
    Basic Friend Type Enum
    Basic Friend Type Generic Class
    Basic Friend Type Generic Class MustInherit
    Basic Friend Type Generic Class NotInheritable
    Basic Friend Type Interface
    Basic Friend Type Struct
    Basic Protected Type Class
    Basic Protected Type Class MustInherit
    Basic Protected Type Class NotInheritable
    Basic Protected Type Delegate
    Basic Protected Type Enum
    Basic Protected Type Generic Class
    Basic Protected Type Generic Class MustInherit
    Basic Protected Type Generic Class NotInheritable
    Basic Protected Type Interface
    Basic Protected Type Struct
    Basic Protected Friend Type Class
    Basic Protected Friend Type Class MustInherit
    Basic Protected Friend Type Class NotInheritable
    Basic Protected Friend Type Delegate
    Basic Protected Friend Type Enum
    Basic Protected Friend Type Generic Class
    Basic Protected Friend Type Generic Class MustInherit
    Basic Protected Friend Type Generic Class NotInheritable
    Basic Protected Friend Type Interface
    Basic Protected Friend Type Struct
    Basic Private Type Class
    Basic Private Type Class MustInherit
    Basic Private Type Class NotInheritable
    Basic Private Type Delegate
    Basic Private Type Enum
    Basic Private Type Generic Class
    Basic Private Type Generic Class MustInherit
    Basic Private Type Generic Class NotInheritable
    Basic Private Type Interface
    Basic Private Type Struct
    Basic Public Type Class
    Basic Public Type Class MustInherit
    Basic Public Type Class NotInheritable
    Basic Public Type Delegate
    Basic Public Type Enum
    Basic Public Type Generic Class
    Basic Public Type Generic Class MustInherit
    Basic Public Type Generic Class NotInheritable
    Basic Public Type Interface
    Basic Public Type Struct
    Basic Type Parameter
    Basic Unknown Type Class
    Basic Unknown Type Interface
    Basic Unknown Type
    Basic Unresolved Type

 Unresolved Dynamic Member
    Basic Unresolved Dynamic Member

 Unresolved Finalizer
    Basic Unresolved Finalizer

 Variable
    Basic Friend Member Variable
    Basic Friend Member Variable Shared
    Basic Protected Member Variable
    Basic Protected Member Variable Shared
    Basic Protected Friend Member Variable
    Basic Protected Friend Member Variable Shared
    Basic Private Member Variable
    Basic Private Member Variable Shared
    Basic Public Member Variable
    Basic Public Member Variable Shared
    Basic Unknown Variable
    Basic Unresolved Variable
    Basic Variable Local


L<Back to Top|/__index__>


=head2 Basic Reference Kinds

Below are listed the general categories of Basic reference kinds, both forward
and inverse relations. When these categories are used literally, as filters,
the full kind names that match have been listed beneath them.

 Alias (Aliasfor)
    Basic Alias

 Call (Callby)
    Basic Call
    Basic Call Implicit
    Basic Call Virtual
    Basic Call Virtual Implicit

 Couple (Coupleby)
    Basic Couple

 Declare (Declarein)
    Basic Declare

 Define (Definein)
    Basic Define

 DotRef (DotRefby)
    Basic DotRef

 End (Endby)
    Basic End

 Implement (Implementby)
    Basic Implement

 Import (Importby)
    Basic Import

 Modify (Modifyby)
    Basic Modify

 Set Init (1)
    Basic Set Init

 Setby Init (1)
    Basic Setby Init

 Shadow (Shadowby)
    Basic Shadow

 Typed (Typedby)
    Basic Typed
    Basic Typed Implicit

 Use (Useby)
    Basic Use Alloc
    Basic Cast Use
    Basic Use
    Basic Use Ptr

 Base (Derive)
    Basic Base
    Basic Base Implicit

 Catch (Catchby)
    Basic Catch Exception

 Overrides (Overriddenby)
    Basic Overrides

 Throw (Throwby)
    Basic Throw Exception


=head2 C Entity Kinds

Below are listed the general categories of C entity kinds. When these
categories are used literally, as filters, the full kind names that match
have been listed beneath them.


 Asm
    C Asm File
    C Asm Function Global
    C Asm Function Local
    C Asm Header File
    C Asm Label Global
    C Asm Label Local
    C Asm Macro
    C Asm Macro Functional
    C Asm Parameter
    C Asm Section
    C Asm Symbol Global
    C Asm Symbol Local
    C Asm Unknown
    C Asm Unresolved Function
    C Asm Unresolved Header File
    C Asm Unresolved Macro

 Enumerator
    C Enumerator
    C Private Member Enumerator
    C Protected Member Enumerator
    C Public Member Enumerator
    C Unresolved Enumerator
    C Unresolved Private Member Enumerator
    C Unresolved Protected Member Enumerator
    C Unresolved Public Member Enumerator

 File
    C Code File
    C Header File
    C Unknown Header File
    C Unresolved Header File
    C Asm File
    C Asm Header File
    C Asm Unresolved Header File

 Function
    C Function
    C Function Template
    C Function Interrupt
    C Function Interrupt Template
    C Function Interrupt Static
    C Function Interrupt Static Template
    C Function Static
    C Function Static Template
    C Private Member Const Function
    C Private Member Const Function Template
    C Private Member Const Function Virtual
    C Private Member Const Function Virtual Pure
    C Private Member Const Volatile Function
    C Private Member Const Volatile Function Template
    C Private Member Const Volatile Function Virtual
    C Private Member Const Volatile Function Virtual Pure
    C Private Member Function
    C Private Member Function Template
    C Private Member Function Explicit
    C Private Member Function Explicit Template
    C Private Member Function Static
    C Private Member Function Static Template
    C Private Member Function Virtual
    C Private Member Function Virtual Pure
    C Private Member Volatile Function
    C Private Member Volatile Function Template
    C Private Member Volatile Function Virtual
    C Private Member Volatile Function Virtual Pure
    C Protected Member Const Function
    C Protected Member Const Function Template
    C Protected Member Const Function Virtual
    C Protected Member Const Function Virtual Pure
    C Protected Member Const Volatile Function
    C Protected Member Const Volatile Function Template
    C Protected Member Const Volatile Function Virtual
    C Protected Member Const Volatile Function Virtual Pure
    C Protected Member Function
    C Protected Member Function Template
    C Protected Member Function Explicit
    C Protected Member Function Explicit Template
    C Protected Member Function Static
    C Protected Member Function Static Template
    C Protected Member Function Virtual
    C Protected Member Function Virtual Pure
    C Protected Member Volatile Function
    C Protected Member Volatile Function Template
    C Protected Member Volatile Function Virtual
    C Protected Member Volatile Function Virtual Pure
    C Public Member Const Function
    C Public Member Const Function Template
    C Public Member Const Function Virtual
    C Public Member Const Function Virtual Pure
    C Public Member Const Volatile Function
    C Public Member Const Volatile Function Template
    C Public Member Const Volatile Function Virtual
    C Public Member Const Volatile Function Virtual Pure
    C Public Member Function
    C Public Member Function Template
    C Public Member Function Explicit
    C Public Member Function Explicit Template
    C Public Member Function Static
    C Public Member Function Static Template
    C Public Member Function Virtual
    C Public Member Function Virtual Pure
    C Public Member Volatile Function
    C Public Member Volatile Function Template
    C Public Member Volatile Function Virtual
    C Public Member Volatile Function Virtual Pure
    C Unknown Function
    C Unknown Function Template
    C Unknown Member Function
    C Unknown Member Function Template
    C Unresolved Function
    C Unresolved Function Template
    C Unresolved Function Interrupt
    C Unresolved Function Interrupt Template
    C Unresolved Function Interrupt Static
    C Unresolved Function Interrupt Static Template
    C Unresolved Function Static
    C Unresolved Function Static Template
    C Unresolved Private Member Const Function
    C Unresolved Private Member Const Function Template
    C Unresolved Private Member Const Function Virtual
    C Unresolved Private Member Const Function Virtual Pure
    C Unresolved Private Member Const Volatile Function
    C Unresolved Private Member Const Volatile Function Template
    C Unresolved Private Member Const Volatile Function Virtual
    C Unresolved Private Member Const Volatile Function Virtual Pure
    C Unresolved Private Member Function
    C Unresolved Private Member Function Template
    C Unresolved Private Member Function Explicit
    C Unresolved Private Member Function Explicit Template
    C Unresolved Private Member Function Static
    C Unresolved Private Member Function Static Template
    C Unresolved Private Member Function Virtual
    C Unresolved Private Member Function Virtual Pure
    C Unresolved Private Member Volatile Function
    C Unresolved Private Member Volatile Function Template
    C Unresolved Private Member Volatile Function Virtual
    C Unresolved Private Member Volatile Function Virtual Pure
    C Unresolved Protected Member Const Function
    C Unresolved Protected Member Const Function Template
    C Unresolved Protected Member Const Function Virtual
    C Unresolved Protected Member Const Function Virtual Pure
    C Unresolved Protected Member Const Volatile Function
    C Unresolved Protected Member Const Volatile Function Template
    C Unresolved Protected Member Const Volatile Function Virtual
    C Unresolved Protected Member Const Volatile Function Virtual Pure
    C Unresolved Protected Member Function
    C Unresolved Protected Member Function Template
    C Unresolved Protected Member Function Explicit
    C Unresolved Protected Member Function Explicit Template
    C Unresolved Protected Member Function Static
    C Unresolved Protected Member Function Static Template
    C Unresolved Protected Member Function Virtual
    C Unresolved Protected Member Function Virtual Pure
    C Unresolved Protected Member Volatile Function
    C Unresolved Protected Member Volatile Function Template
    C Unresolved Protected Member Volatile Function Virtual
    C Unresolved Protected Member Volatile Function Virtual Pure
    C Unresolved Public Member Const Function
    C Unresolved Public Member Const Function Template
    C Unresolved Public Member Const Function Virtual
    C Unresolved Public Member Const Function Virtual Pure
    C Unresolved Public Member Const Volatile Function
    C Unresolved Public Member Const Volatile Function Template
    C Unresolved Public Member Const Volatile Function Virtual
    C Unresolved Public Member Const Volatile Function Virtual Pure
    C Unresolved Public Member Function
    C Unresolved Public Member Function Template
    C Unresolved Public Member Function Explicit
    C Unresolved Public Member Function Explicit Template
    C Unresolved Public Member Function Implicit
    C Unresolved Public Member Function Static
    C Unresolved Public Member Function Static Template
    C Unresolved Public Member Function Virtual
    C Unresolved Public Member Function Virtual Pure
    C Unresolved Public Member Volatile Function
    C Unresolved Public Member Volatile Function Template
    C Unresolved Public Member Volatile Function Virtual
    C Unresolved Public Member Volatile Function Virtual Pure
    C Asm Function Global
    C Asm Function Local
    C Asm Unresolved Function
    C ObjC Method Member Function
    C ObjC Instance Method Member Function
    C ObjC Optional Method Member Function
    C ObjC Optional Instance Method Member Function
    C ObjC Unknown Method Member Function
    C ObjC Unknown Instance Method Member Function
    C ObjC Unresolved Method Member Function
    C ObjC Unresolved Instance Method Member Function
    C ObjC Unresolved Optional Method Member Function
    C ObjC Unresolved Optional Instance Method Member Function
    C Lambda Function

 Label
    C Label
    C Unknown Label
    C Asm Label Global
    C Asm Label Local

 Macro
    C Inactive Macro
    C Macro
    C Macro Functional
    C Macro Project
    C Unknown Macro
    C Unresolved Macro
    C Asm Macro
    C Asm Macro Functional
    C Asm Unresolved Macro

 Namespace
    C Namespace
    C Namespace Alias

 Object
    C Object Global
    C Object Global Static
    C Object Local
    C Object Local Static
    C Private Member Object
    C Private Member Object Static
    C Protected Member Object
    C Protected Member Object Static
    C Public Member Object
    C Public Member Object Static
    C TemplateParameter Object
    C Unknown Member Object
    C Unknown Object
    C Unnamed TemplateParameter Object
    C Unresolved Object Global
    C Unresolved Object Global Static
    C Unresolved Private Member Object Static
    C Unresolved Protected Member Object Static
    C Unresolved Public Member Object Static
    C ObjC Private Instance Variable Member Object
    C ObjC Protected Instance Variable Member Object
    C ObjC Public Instance Variable Member Object
    C ObjC Package Instance Variable Member Object
    C ObjC Unknown Instance Variable Member Object
    C ObjC Unresolved Private Instance Variable Member Object
    C ObjC Unresolved Protected Instance Variable Member Object
    C ObjC Unresolved Public Instance Variable Member Object
    C ObjC Unresolved Package Instance Variable Member Object
    C TemplateParameter Object Pack
    C Unnamed TemplateParameter Object Pack

 Parameter
    C Parameter
    C Unnamed Parameter
    C Asm Parameter

 Property
    C ObjC Property
    C ObjC Unknown Property
    C ObjC Unresolved Property

 Type
    C Abstract Class Type
    C Abstract Class Type Template
    C Abstract Struct Type
    C Abstract Struct Type Template
    C Class Type
    C Class Type Template
    C Enum Type
    C Private Member Abstract Class Type
    C Private Member Abstract Class Type Template
    C Private Member Abstract Struct Type
    C Private Member Abstract Struct Type Template
    C Private Member Class Type
    C Private Member Class Type Template
    C Private Member Enum Type
    C Private Member Struct Type
    C Private Member Struct Type Template
    C Private Member Typedef Type
    C Private Member Union Type
    C Private Member Union Type Template
    C Protected Member Abstract Class Type
    C Protected Member Abstract Class Type Template
    C Protected Member Abstract Struct Type
    C Protected Member Abstract Struct Type Template
    C Protected Member Class Type
    C Protected Member Class Type Template
    C Protected Member Enum Type
    C Protected Member Struct Type
    C Protected Member Struct Type Template
    C Protected Member Typedef Type
    C Protected Member Union Type
    C Protected Member Union Type Template
    C Public Member Abstract Class Type
    C Public Member Abstract Class Type Template
    C Public Member Abstract Struct Type
    C Public Member Abstract Struct Type Template
    C Public Member Class Type
    C Public Member Class Type Template
    C Public Member Enum Type
    C Public Member Struct Type
    C Public Member Struct Type Template
    C Public Member Typedef Type
    C Public Member Union Type
    C Public Member Union Type Template
    C Struct Type
    C Struct Type Template
    C TemplateParameter Type
    C Typedef Type
    C Union Type
    C Union Type Template
    C Unknown Class Type
    C Unknown Class Type Template
    C Unknown Enum Type
    C Unknown Member Type
    C Unknown Struct Type
    C Unknown Struct Type Template
    C Unknown Type
    C Unknown Union Type
    C Unknown Union Type Template
    C Unnamed Class Type
    C Unnamed Enum Type
    C Unnamed Private Member Class Type
    C Unnamed Private Member Enum Type
    C Unnamed Private Member Struct Type
    C Unnamed Private Member Union Type
    C Unnamed Protected Member Class Type
    C Unnamed Protected Member Enum Type
    C Unnamed Protected Member Struct Type
    C Unnamed Protected Member Union Type
    C Unnamed Public Member Class Type
    C Unnamed Public Member Enum Type
    C Unnamed Public Member Struct Type
    C Unnamed Public Member Union Type
    C Unnamed Struct Type
    C Unnamed Union Type
    C Unnamed TemplateParameter Type
    C Unresolved Class Type
    C Unresolved Class Type Template
    C Unresolved Enum Type
    C Unresolved Private Member Class Type
    C Unresolved Private Member Class Type Template
    C Unresolved Private Member Enum Type
    C Unresolved Private Member Struct Type
    C Unresolved Private Member Struct Type Template
    C Unresolved Private Member Typedef Type
    C Unresolved Private Member Union Type
    C Unresolved Private Member Union Type Template
    C Unresolved Protected Member Class Type
    C Unresolved Protected Member Class Type Template
    C Unresolved Protected Member Enum Type
    C Unresolved Protected Member Struct Type
    C Unresolved Protected Member Struct Type Template
    C Unresolved Protected Member Typedef Type
    C Unresolved Protected Member Union Type
    C Unresolved Protected Member Union Type Template
    C Unresolved Public Member Class Type
    C Unresolved Public Member Class Type Template
    C Unresolved Public Member Enum Type
    C Unresolved Public Member Struct Type
    C Unresolved Public Member Struct Type Template
    C Unresolved Public Member Typedef Type
    C Unresolved Public Member Union Type
    C Unresolved Public Member Union Type Template
    C Unresolved Struct Type
    C Unresolved Struct Type Template
    C Unresolved Typedef Type
    C Unresolved Union Type
    C Unresolved Union Type Template
    C ObjC Class Type
    C ObjC Protocol Type
    C ObjC Category Type
    C ObjC Unknown Class Type
    C ObjC Unknown Protocol Type
    C ObjC Unknown Category Type
    C ObjC Unresolved Class Type
    C ObjC Unresolved Protocol Type
    C ObjC Unresolved Category Type
    C Private Member Type Alias
    C Private Member Type Alias Template
    C Protected Member Type Alias
    C Protected Member Type Alias Template
    C Public Member Type Alias
    C Public Member Type Alias Template
    C TemplateParameter Type Pack
    C Type Alias
    C Type Alias Template
    C Unnamed TemplateParameter Type Pack
    C Unresolved Private Member Type Alias
    C Unresolved Private Member Type Alias Template
    C Unresolved Protected Member Type Alias
    C Unresolved Protected Member Type Alias Template
    C Unresolved Public Member Type Alias
    C Unresolved Public Member Type Alias Template
    C Unresolved Type Alias
    C Unresolved Type Alias Template


L<Back to Top|/__index__>


=head2 C Reference Kinds

Below are listed the general categories of C reference kinds, both forward
and inverse relations. When these categories are used literally, as filters,
the full kind names that match have been listed beneath them.

 Alias (Aliasby)
    C Alias

 Call (Callby)
    C Asm Call
    C Call
    C Call Virtual
    C Call Implicit
    C Deref Call
    C Inactive Call
    C ObjC Message Call

 Declare (Declarein)
    C Declare
    C Declare Implicit
    C Declare Using
    C Declare Default
    C Declare Delete

 Define (Definein)
    C Define

 End (Endby)
    C End

 Friend (Friendby)
    C Friend

 Include (Includeby)
    C Inactive Include
    C Include
    C Implicit Include

 Modify (Modifyby)
    C Deref Modify
    C Modify

 Name (Nameby)
    C Name

 ObjC Adopt (ObjC Adoptby)
    C ObjC Adopt

 ObjC Extend (ObjC Extendby)
    C ObjC Extend
    C ObjC Implement Extend

 ObjC Implement (ObjC Implementby)
    C ObjC Implement
    C ObjC Implement Extend

 Set (Setby)
    C Deref Set
    C Set
    C Set Init
    C Set Init Implicit

 Specialize (Specializeby)
    C Specialize

 Typed (Typedby)
    C Typed
    C Typed Implicit

 Use (Useby)
    C Addr Use
    C Addr Use Return
    C Asm Use
    C Cast Use
    C Deref Use
    C Deref Use Return
    C Inactive Use
    C Use
    C Use Macrodefine
    C Use Macroexpand
    C Use Ptr
    C Use Return
    C Use Capture
    C Use Expand

 Using (Usingby)
    C Declare Using
    C Declarein Using
    C Using

 Allow (Allowby)
    C Allow Exception

 Base (Derive)
    C Private Base
    C Protected Base
    C Public Base
    C Virtual Private Base
    C Virtual Protected Base
    C Virtual Public Base
    C ObjC Base

 Catch (Catchby)
    C Catch Exception

 Overrides (Overriddenby)
    C Overrides

 Throw (Throwby)
    C Throw Exception


=head2 C# Entity Kinds

Below are listed the general categories of C# entity kinds. When these
categories are used literally, as filters, the full kind names that match
have been listed beneath them.


 Const
    C# csharp Const Local
    C# csharp Internal Const Member Field
    C# csharp Protected Const Member Field
    C# csharp Protected Internal Const Member Field
    C# csharp Private Const Member Field
    C# csharp Public Const Member Field

 Enumerator
    C# csharp Enumerator
    C# csharp Unresolved Enumerator

 Event
    C# csharp Internal Member Event
    C# csharp Internal Member Event Static
    C# csharp Internal Member Event Virtual
    C# csharp Internal Member Event Virtual Abstract
    C# csharp Internal Member Event Virtual Sealed
    C# csharp Protected Member Event
    C# csharp Protected Member Event Static
    C# csharp Protected Member Event Virtual
    C# csharp Protected Member Event Virtual Abstract
    C# csharp Protected Member Event Virtual Sealed
    C# csharp Protected Internal Member Event
    C# csharp Protected Internal Member Event Static
    C# csharp Protected Internal Member Event Virtual
    C# csharp Protected Internal Member Event Virtual Abstract
    C# csharp Protected Internal Member Event Virtual Sealed
    C# csharp Private Member Event
    C# csharp Private Member Event Static
    C# csharp Public Member Event
    C# csharp Public Member Event Static
    C# csharp Public Member Event Virtual
    C# csharp Public Member Event Virtual Abstract
    C# csharp Public Member Event Virtual Sealed
    C# csharp Unresolved Internal Member Event
    C# csharp Unresolved Internal Member Event Static
    C# csharp Unresolved Internal Member Event Virtual
    C# csharp Unresolved Internal Member Event Virtual Sealed
    C# csharp Unresolved Protected Member Event
    C# csharp Unresolved Protected Member Event Static
    C# csharp Unresolved Protected Member Event Virtual
    C# csharp Unresolved Protected Member Event Virtual Sealed
    C# csharp Unresolved Protected Internal Member Event
    C# csharp Unresolved Protected Internal Member Event Static
    C# csharp Unresolved Protected Internal Member Event Virtual
    C# csharp Unresolved Protected Internal Member Event Virtual Sealed
    C# csharp Unresolved Private Member Event
    C# csharp Unresolved Private Member Event Static
    C# csharp Unresolved Public Member Event
    C# csharp Unresolved Public Member Event Static
    C# csharp Unresolved Public Member Event Virtual
    C# csharp Unresolved Public Member Event Virtual Sealed

 Field
    C# csharp Internal Const Member Field
    C# csharp Internal Member Field
    C# csharp Internal Member Field Static
    C# csharp Protected Const Member Field
    C# csharp Protected Member Field
    C# csharp Protected Member Field Static
    C# csharp Protected Internal Const Member Field
    C# csharp Protected Internal Member Field
    C# csharp Protected Internal Member Field Static
    C# csharp Private Const Member Field
    C# csharp Private Member Field
    C# csharp Private Member Field Static
    C# csharp Public Const Member Field
    C# csharp Public Member Field
    C# csharp Public Member Field Static
    C# csharp Unresolved Member Field

 File
    C# csharp File
    C# csharp Dll File

 Indexer
    C# csharp Internal Member Indexer
    C# csharp Internal Member Indexer Virtual
    C# csharp Internal Member Indexer Virtual Abstract
    C# csharp Internal Member Indexer Virtual Sealed
    C# csharp Protected Member Indexer
    C# csharp Protected Member Indexer Virtual
    C# csharp Protected Member Indexer Virtual Abstract
    C# csharp Protected Member Indexer Virtual Sealed
    C# csharp Protected Internal Member Indexer
    C# csharp Protected Internal Member Indexer Virtual
    C# csharp Protected Internal Member Indexer Virtual Abstract
    C# csharp Protected Internal Member Indexer Virtual Sealed
    C# csharp Private Member Indexer
    C# csharp Public Member Indexer
    C# csharp Public Member Indexer Virtual
    C# csharp Public Member Indexer Virtual Abstract
    C# csharp Public Member Indexer Virtual Sealed
    C# csharp Unresolved Internal Member Indexer
    C# csharp Unresolved Internal Member Indexer Virtual
    C# csharp Unresolved Internal Member Indexer Virtual Sealed
    C# csharp Unresolved Protected Member Indexer
    C# csharp Unresolved Protected Member Indexer Virtual
    C# csharp Unresolved Protected Member Indexer Virtual Sealed
    C# csharp Unresolved Protected Internal Member Indexer
    C# csharp Unresolved Protected Internal Member Indexer Virtual
    C# csharp Unresolved Protected Internal Member Indexer Virtual Sealed
    C# csharp Unresolved Private Member Indexer
    C# csharp Unresolved Public Member Indexer
    C# csharp Unresolved Public Member Indexer Virtual
    C# csharp Unresolved Public Member Indexer Virtual Sealed

 Method
    C# csharp Constructor Member Method Static
    C# csharp Finalizer Member Method
    C# csharp Internal Constructor Member Method
    C# csharp Internal Member Method
    C# csharp Internal Member Method Stub
    C# csharp Internal Member Method Static
    C# csharp Internal Member Method Virtual
    C# csharp Internal Member Method Virtual Abstract
    C# csharp Internal Member Method Virtual Sealed
    C# csharp Protected Constructor Member Method
    C# csharp Protected Member Method
    C# csharp Protected Member Method Stub
    C# csharp Protected Member Method Static
    C# csharp Protected Member Method Virtual
    C# csharp Protected Member Method Virtual Abstract
    C# csharp Protected Member Method Virtual Sealed
    C# csharp Protected Internal Constructor Member Method
    C# csharp Protected Internal Member Method
    C# csharp Protected Internal Member Method Stub
    C# csharp Protected Internal Member Method Static
    C# csharp Protected Internal Member Method Virtual
    C# csharp Protected Internal Member Method Virtual Abstract
    C# csharp Protected Internal Member Method Virtual Sealed
    C# csharp Private Constructor Member Method
    C# csharp Private Member Method
    C# csharp Private Member Method Stub
    C# csharp Private Member Method Static
    C# csharp Public Constructor Member Method
    C# csharp Public Member Method
    C# csharp Public Member Method Stub
    C# csharp Public Member Method Static
    C# csharp Public Member Method Virtual
    C# csharp Public Member Method Virtual Abstract
    C# csharp Public Member Method Virtual Sealed
    C# csharp Unknown Member Method
    C# csharp Unresolved Constructor Member Method Static
    C# csharp Unresolved Finalizer Member Method
    C# csharp Unresolved Internal Constructor Member Method
    C# csharp Unresolved Internal Member Method
    C# csharp Unresolved Internal Extern Member Method
    C# csharp Unresolved Internal Member Method Static
    C# csharp Unresolved Internal Extern Member Method Static
    C# csharp Unresolved Internal Member Method Virtual
    C# csharp Unresolved Internal Extern Member Method Virtual
    C# csharp Unresolved Internal Member Method Virtual Sealed
    C# csharp Unresolved Internal Extern Member Method Virtual Sealed
    C# csharp Unresolved Protected Constructor Member Method
    C# csharp Unresolved Protected Member Method
    C# csharp Unresolved Protected Extern Member Method
    C# csharp Unresolved Protected Member Method Static
    C# csharp Unresolved Protected Extern Member Method Static
    C# csharp Unresolved Protected Member Method Virtual
    C# csharp Unresolved Protected Extern Member Method Virtual
    C# csharp Unresolved Protected Member Method Virtual Sealed
    C# csharp Unresolved Protected Extern Member Method Virtual Sealed
    C# csharp Unresolved Protected Internal Constructor Member Method
    C# csharp Unresolved Protected Internal Member Method
    C# csharp Unresolved Protected Internal Extern Member Method
    C# csharp Unresolved Protected Internal Member Method Static
    C# csharp Unresolved Protected Internal Extern Member Method Static
    C# csharp Unresolved Protected Internal Member Method Virtual
    C# csharp Unresolved Protected Internal Extern Member Method Virtual
    C# csharp Unresolved Protected Internal Member Method Virtual Sealed
    C# csharp Unresolved Protected Internal Extern Member Method Virtual Sealed
    C# csharp Unresolved Private Constructor Member Method
    C# csharp Unresolved Private Member Method
    C# csharp Unresolved Private Extern Member Method
    C# csharp Unresolved Private Member Method Static
    C# csharp Unresolved Private Extern Member Method Static
    C# csharp Unresolved Public Constructor Member Method
    C# csharp Unresolved Public Member Method
    C# csharp Unresolved Public Extern Member Method
    C# csharp Unresolved Public Member Method Static
    C# csharp Unresolved Public Extern Member Method Static
    C# csharp Unresolved Public Member Method Virtual
    C# csharp Unresolved Public Extern Member Method Virtual
    C# csharp Unresolved Public Member Method Virtual Sealed
    C# csharp Unresolved Public Extern Member Method Virtual Sealed

 Namespace
    C# csharp Namespace Alias
    C# csharp Extern Alias Namespace
    C# csharp Namespace
    C# csharp Unknown Namespace
    C# csharp Unresolved Namespace

 Parameter
    C# csharp Parameter Out
    C# csharp Parameter Params
    C# csharp Parameter Ref
    C# csharp Parameter Value
    C# csharp Type Parameter

 Property
    C# csharp Internal Member Property
    C# csharp Internal Member Property Extern
    C# csharp Internal Member Property Static
    C# csharp Internal Member Property Static Exter
    C# csharp Internal Member Property Virtual
    C# csharp Internal Member Property Virtual Extern
    C# csharp Internal Member Property Virtual Abstract
    C# csharp Internal Member Property Virtual Sealed
    C# csharp Internal Member Property Virtual Sealed Extern
    C# csharp Protected Member Property
    C# csharp Protected Member Property Extern
    C# csharp Protected Member Property Static
    C# csharp Protected Member Property Static Extern
    C# csharp Protected Member Property Virtual
    C# csharp Protected Member Property Virtual Extern
    C# csharp Protected Member Property Virtual Abstract
    C# csharp Protected Member Property Virtual Sealed
    C# csharp Protected Member Property Virtual Sealed Extern
    C# csharp Protected Internal Member Property
    C# csharp Protected Internal Member Property Extern
    C# csharp Protected Internal Member Property Static
    C# csharp Protected Internal Member Property Static Extern
    C# csharp Protected Internal Member Property Virtual
    C# csharp Protected Internal Member Property Virtual Extern
    C# csharp Protected Internal Member Property Virtual Abstract
    C# csharp Protected Internal Member Property Virtual Sealed
    C# csharp Protected Internal Member Property Virtual Sealed Extern
    C# csharp Private Member Property
    C# csharp Private Member Property Extern
    C# csharp Private Member Property Static
    C# csharp Private Member Property Static Extern
    C# csharp Public Member Property
    C# csharp Public Member Property Extern
    C# csharp Public Member Property Static
    C# csharp Public Member Property Static Extern
    C# csharp Public Member Property Virtual
    C# csharp Public Member Property Virtual Extern
    C# csharp Public Member Property Virtual Abstract
    C# csharp Public Member Property Virtual Sealed
    C# csharp Public Member Property Virtual Sealed Extern
    C# csharp Unresolved Internal Member Property
    C# csharp Unresolved Internal Member Property Static
    C# csharp Unresolved Internal Member Property Virtual
    C# csharp Unresolved Internal Member Property Virtual Sealed
    C# csharp Unresolved Protected Member Property
    C# csharp Unresolved Protected Member Property Static
    C# csharp Unresolved Protected Member Property Virtual
    C# csharp Unresolved Protected Member Property Virtual Sealed
    C# csharp Unresolved Protected Internal Member Property
    C# csharp Unresolved Protected Internal Member Property Static
    C# csharp Unresolved Protected Internal Member Property Virtual
    C# csharp Unresolved Protected Internal Member Property Virtual Sealed
    C# csharp Unresolved Private Member Property
    C# csharp Unresolved Private Member Property Static
    C# csharp Unresolved Public Member Property
    C# csharp Unresolved Public Member Property Static
    C# csharp Unresolved Public Member Property Virtual
    C# csharp Unresolved Public Member Property Virtual Sealed

 Type
    C# csharp Type Alias
    C# csharp Internal Type Class
    C# csharp Internal Type Class Abstract
    C# csharp Internal Type Class Static
    C# csharp Internal Type Class Sealed
    C# csharp Internal Type Delegate
    C# csharp Internal Type Enum
    C# csharp Internal Type Generic Class
    C# csharp Internal Type Generic Class Abstract
    C# csharp Internal Type Generic Class Static
    C# csharp Internal Type Generic Class Sealed
    C# csharp Internal Type Interface
    C# csharp Internal Type Struct
    C# csharp Protected Type Class
    C# csharp Protected Type Class Abstract
    C# csharp Protected Type Class Static
    C# csharp Protected Type Class Sealed
    C# csharp Protected Type Delegate
    C# csharp Protected Type Enum
    C# csharp Protected Type Generic Class
    C# csharp Protected Type Generic Class Abstract
    C# csharp Protected Type Generic Class Static
    C# csharp Protected Type Generic Class Sealed
    C# csharp Protected Type Interface
    C# csharp Protected Type Struct
    C# csharp Protected Internal Type Class
    C# csharp Protected Internal Type Class Abstract
    C# csharp Protected Internal Type Class Static
    C# csharp Protected Internal Type Class Sealed
    C# csharp Protected Internal Type Delegate
    C# csharp Protected Internal Type Enum
    C# csharp Protected Internal Type Generic Class
    C# csharp Protected Internal Type Generic Class Abstract
    C# csharp Protected Internal Type Generic Class Static
    C# csharp Protected Internal Type Generic Class Sealed
    C# csharp Protected Internal Type Interface
    C# csharp Protected Internal Type Struct
    C# csharp Private Type Class
    C# csharp Private Type Class Abstract
    C# csharp Private Type Class Static
    C# csharp Private Type Class Sealed
    C# csharp Private Type Delegate
    C# csharp Private Type Enum
    C# csharp Private Type Generic Class
    C# csharp Private Type Generic Class Abstract
    C# csharp Private Type Generic Class Static
    C# csharp Private Type Generic Class Sealed
    C# csharp Private Type Interface
    C# csharp Private Type Struct
    C# csharp Public Type Class
    C# csharp Public Type Class Abstract
    C# csharp Public Type Class Static
    C# csharp Public Type Class Sealed
    C# csharp Public Type Delegate
    C# csharp Public Type Enum
    C# csharp Public Type Generic Class
    C# csharp Public Type Generic Class Abstract
    C# csharp Public Type Generic Class Static
    C# csharp Public Type Generic Class Sealed
    C# csharp Public Type Interface
    C# csharp Public Type Struct
    C# csharp Type Parameter
    C# csharp Unknown Type Class
    C# csharp Unknown Type Interface
    C# csharp Unknown Type
    C# csharp Unresolved Type

 Unresolved Dynamic Member
    C# csharp Unresolved Dynamic Member

 Variable
    C# csharp Unknown Variable
    C# csharp Variable Local


L<Back to Top|/__index__>


=head2 C# Reference Kinds

Below are listed the general categories of C# reference kinds, both forward
and inverse relations. When these categories are used literally, as filters,
the full kind names that match have been listed beneath them.

 Alias (Aliasfor)
    C# csharp Alias

 Call (Callby)
    C# csharp Call
    C# csharp Call Implicit
    C# csharp Call Virtual
    C# csharp Call Virtual Implicit

 Couple (Coupleby)
    C# csharp Couple

 Declare (Declarein)
    C# csharp Declare

 Define (Definein)
    C# csharp Define

 DotRef (DotRefby)
    C# csharp DotRef

 End (Endby)
    C# csharp End

 Implement (Implementby)
    C# csharp Implement

 Modify (Modifyby)
    C# csharp Modify

 Set (Setby)
    C# csharp Set
    C# csharp Set Init

 Typed (Typedby)
    C# csharp Typed
    C# csharp Typed Implicit

 Use (Useby)
    C# csharp Use Alloc
    C# csharp Cast Use
    C# csharp Use
    C# csharp Use Ptr

 Using (Usingby)
    C# csharp Using

 Base (Derive)
    C# csharp Base
    C# csharp Base Implicit

 Catch (Catchby)
    C# csharp Catch Exception

 Overrides (Overriddenby)
    C# csharp Overrides

 Throw (Throwby)
    C# csharp Throw Exception


=head2 Cobol Entity Kinds

Below are listed the general categories of Cobol entity kinds. When these
categories are used literally, as filters, the full kind names that match
have been listed beneath them.


 File
    Cobol File
    Cobol Copybook File
    Cobol Unknown Copybook File
    Cobol Unresolved Copybook File

 Index
    Cobol Index
    Cobol Unknown Index
    Cobol Unresolved Index

 Paragraph
    Cobol Paragraph
    Cobol Unknown Paragraph
    Cobol Unresolved Paragraph

 Program
    Cobol Program
    Cobol Unknown Program
    Cobol Unresolved Program

 Screen
    Cobol Screen
    Cobol Unknown Screen
    Cobol Unresolved Screen

 Section
    Cobol Section

 Variable
    Cobol Sequential DataFile Variable
    Cobol Sequential Indexed DataFile Variable
    Cobol Random Indexed DataFile Variable
    Cobol Dynamic Indexed DataFile Variable
    Cobol Sequential Relative DataFile Variable
    Cobol Random Relative DataFile Variable
    Cobol Dynamic Relative DataFile Variable
    Cobol Unknown DataFile Variable
    Cobol Unresolved DataFile Variable
    Cobol Variable
    Cobol Record Variable
    Cobol Unknown Variable
    Cobol Unresolved Variable


L<Back to Top|/__index__>


=head2 Cobol Reference Kinds

Below are listed the general categories of Cobol reference kinds, both forward
and inverse relations. When these categories are used literally, as filters,
the full kind names that match have been listed beneath them.

 Call (Callby)
    Cobol Call

 Cancel (Cancelby)
    Cobol Cancel

 Close (Closeby)
    Cobol Close

 Copy (Copyby)
    Cobol Copy

 Define (Definein)
    Cobol Define

 Delete (Deleteby)
    Cobol Delete

 End (Endby)
    Cobol End

 Goto (Gotoby)
    Cobol Goto

 Modify (Modifyby)
    Cobol Modify

 Perform (Performby)
    Cobol Perform
    Cobol Perform Through

 Read (Readby)
    Cobol Read

 Redefine (Redefineby)
    Cobol Redefine

 Rename (Renameby)
    Cobol Rename

 Rewrite (Rewriteby)
    Cobol Rewrite

 Select (Selectby)
    Cobol Select

 Set (Setby)
    Cobol Set

 Start (Startby)
    Cobol Start

 Status (Statusby)
    Cobol Status

 Use (Useby)
    Cobol Use

 Write (Writeby)
    Cobol Write

 Key (Keyby)
    Cobol Record Key
    Cobol Alternate Record Key
    Cobol Relative Key

 Open (Openby)
    Cobol Input Open
    Cobol Output Open
    Cobol Input Output Open
    Cobol Extend Open


=head2 Fortran Entity Kinds

Below are listed the general categories of Fortran entity kinds. When these
categories are used literally, as filters, the full kind names that match
have been listed beneath them.


 Common
    Fortran Common
    Fortran Unresolved External Common

 Data
    Fortran Block Data

 Datapool
    Fortran Datapool

 Dummy Argument
    Fortran Dummy Argument

 Entry
    Fortran Entry

 Enumerator
    Fortran Enumerator

 File
    Fortran File
    Fortran Include File
    Fortran Unknown Include File
    Fortran Unresolved Include File

 Function
    Fortran Function
    Fortran Intrinsic Function
    Fortran Unresolved External Function
    Fortran Unresolved Function

 Interface
    Fortran Interface

 Module
    Fortran Intrinsic Module
    Fortran Module
    Fortran Unknown Module

 Parameter
    Fortran Parameter

 Pointer
    Fortran Pointer
    Fortran Procedure Pointer

 Procedure
    Fortran Procedure
    Fortran Procedure Pointer

 Program
    Fortran Main Program

 Subroutine
    Fortran Intrinsic Subroutine
    Fortran Subroutine
    Fortran Unresolved External Subroutine
    Fortran Unresolved Subroutine

 Type
    Fortran Derived Type
    Fortran Abstract Derived Type
    Fortran Intrinsic Type
    Fortran Unknown Type

 Unresolved
    Fortran Unresolved
    Fortran Unresolved External Common
    Fortran Unresolved External Function
    Fortran Unresolved External Subroutine
    Fortran Unresolved External Variable
    Fortran Unresolved Function
    Fortran Unresolved Include File
    Fortran Unresolved Subroutine

 Variable
    Fortran Block Variable
    Fortran Intrinsic Variable
    Fortran IoUnit Variable
    Fortran Namelist Variable
    Fortran Unknown Variable
    Fortran Unresolved External Variable
    Fortran Variable
    Fortran Variable Component
    Fortran Local Variable


L<Back to Top|/__index__>


=head2 Fortran Reference Kinds

Below are listed the general categories of Fortran reference kinds, both forward
and inverse relations. When these categories are used literally, as filters,
the full kind names that match have been listed beneath them.

 Call (Callby)
    Fortran Call
    Fortran Call Ptr

 Contain (Containin)
    Fortran Contain

 Declare (Declarein)
    Fortran Declare
    Fortran Declare Bind
    Fortran Declare Bind Private
    Fortran Declare Bind Final

 Define (Definein)
    Fortran Define
    Fortran Define Bind
    Fortran Define Bind Private
    Fortran Define Inc
    Fortran Define Implicit
    Fortran Define Private
    Fortran Define Private Inc

 End (Endby)
    Fortran End
    Fortran End Unnamed

 Equivalence (Equivalenceby)
    Fortran Equivalence

 Extend (Extendby)
    Fortran Extend

 Include (Includeby)
    Fortran Include

 ModuleUse (ModuleUseby)
    Fortran ModuleUse
    Fortran ModuleUse Only

 Ref (Refby)
    Fortran Ref

 Rename (Renameby)
    Fortran Rename

 Set (Setby)
    Fortran Set
    Fortran Set Out Argument
    Fortran Set Init

 Typed (Typedby)
    Fortran Typed

 Use (Useby)
    Fortran Use
    Fortran Use Argument
    Fortran Use In Argument
    Fortran Addr Use
    Fortran Use IO

 UseModuleEntity (UseModuleEntityby)
    Fortran UseModuleEntity

 UseRenameEntity (UseRenameEntityby)
    Fortran UseRenameEntity


=head2 Java Entity Kinds

Below are listed the general categories of Java entity kinds. When these
categories are used literally, as filters, the full kind names that match
have been listed beneath them.


 File
    Java File
    Java File Jar

 Method
    Java Abstract Method Default Member
    Java Abstract Method Protected Member
    Java Abstract Method Public Member
    Java Abstract Generic Method Default Member
    Java Abstract Generic Method Protected Member
    Java Abstract Generic Method Public Member
    Java Method Constructor Member Default
    Java Method Constructor Member Protected
    Java Method Constructor Member Private
    Java Method Constructor Member Public
    Java Final Method Default Member
    Java Final Method Private Member
    Java Final Method Protected Member
    Java Final Method Public Member
    Java Generic Final Method Default Member
    Java Generic Final Method Private Member
    Java Final Generic Method Protected Member
    Java Final Generic Method Public Member
    Java Method Default Member
    Java Method Private Member
    Java Method Protected Member
    Java Method Public Member
    Java Generic Method Default Member
    Java Generic Method Private Member
    Java Generic Method Protected Member
    Java Generic Method Public Member
    Java Static Final Method Default Member
    Java Static Final Method Private Member
    Java Static Final Method Protected Member
    Java Static Final Method Public Member
    Java Static Final Generic Method Default Member
    Java Static Final Generic Method Private Member
    Java Static Final Generic Method Protected Member
    Java Static Final Generic Method Public Member
    Java Static Method Default Member
    Java Static Method Private Member
    Java Static Method Protected Member
    Java Static Method Public Member
    Java Static Generic Method Default Member
    Java Static Generic Method Private Member
    Java Static Generic Method Protected Member
    Java Static Generic Method Public Member
    Java Static Method Public Main Member
    Java Unknown Method Member
    Java Unresolved Method
    Java Unresolved External Final Method Default Member
    Java Unresolved External Final Method Private Member
    Java Unresolved External Final Method Protected Member
    Java Unresolved External Final Method Public Member
    Java Unresolved External Method Default Member
    Java Unresolved External Method Private Member
    Java Unresolved External Method Protected Member
    Java Unresolved External Method Public Member
    Java Unresolved External Static Final Method Default Member
    Java Unresolved External Static Final Method Private Member
    Java Unresolved Extermal Static Final Method Protected Member
    Java Unresolved External Static Final Method Public Member
    Java Unresolved External Static Method Default Member
    Java Unresolved External Static Method Private Member
    Java Unresolved External Static Method Protected Member
    Java Unresolved External Static Method Public Member
    Java Unresolved External Static Method Public Main Member

 Package
    Java Package
    Java Package Unnamed
    Java Unknown Package
    Java Unresolved Package

 Parameter
    Java Catch Parameter
    Java Parameter

 Type
    Java Abstract Class Type Default Member
    Java Abstract Class Type Private Member
    Java Abstract Class Type Protected Member
    Java Abstract Class Type Public Member
    Java Abstract Generic Class Type Default Member
    Java Abstract Generic Class Type Private Member
    Java Abstract Generic Class Type Protected Member
    Java Abstract Generic Class Type Public Member
    Java Abstract Enum Type Default Member
    Java Abstract Enum Type Private Member
    Java Abstract Enum Type Protected Member
    Java Abstract Enum Type Public Member
    Java Annotation Interface Type Default
    Java Annotation Interface Type Private
    Java Annotation Interface Type Protected
    Java Annotation Interface Type Public
    Java Class Type Anonymous Member
    Java Class Type Default Member
    Java Class Type Private Member
    Java Class Type Protected Member
    Java Class Type Public Member
    Java Generic Class Type Default Member
    Java Generic Class Type Private Member
    Java Generic Class Type Protected Member
    Java Generic Class Type Public Member
    Java Enum Class Type Default Member
    Java Enum Class Type Private Member
    Java Enum Class Type Protected Member
    Java Enum Class Type Public Member
    Java Final Class Type Default Member
    Java Final Class Type Private Member
    Java Final Class Type Protected Member
    Java Final Class Type Public Member
    Java Final Generic Class Type Default Member
    Java Final Generic Class Type Private Member
    Java Final Generic Class Type Protected Member
    Java Final Generic Class Type Public Member
    Java Interface Type Default
    Java Interface Type Private
    Java Interface Type Protected
    Java Interface Type Public
    Java Generic Interface Type Default
    Java Generic Interface Type Private
    Java Generic Interface Type Protected
    Java Generic Interface Type Public
    Java Static Abstract Class Type Default Member
    Java Static Abstract Class Type Private Member
    Java Static Abstract Class Type Protected Member
    Java Static Abstract Class Type Public Member
    Java Static Abstract Generic Class Type Default Member
    Java Static Abstract Generic Class Type Private Member
    Java Static Abstract Generic Class Type Protected Member
    Java Static Abstract Generic Class Type Public Member
    Java Static Class Type Default Member
    Java Static Class Type Private Member
    Java Static Class Type Protected Member
    Java Static Class Type Public Member
    Java Static Generic Class Type Default Member
    Java Static Class Generic Type Private Member
    Java Static Generic Class Type Protected Member
    Java Static Generic Class Type Public Member
    Java Static Final Class Type Default Member
    Java Static Final Class Type Private Member
    Java Static Final Class Type Protected Member
    Java Static Final Class Type Public Member
    Java Static Final Generic Class Type Default Member
    Java Static Final Generic Class Type Private Member
    Java Static Final Generic Class Type Protected Member
    Java Static Final Generic Class Type Public Member
    Java Class Type TypeVariable
    Java Unknown Class Type Member
    Java Unresolved Type

 Variable
    Java Variable EnumConstant Public Member
    Java Final Variable Default Member
    Java Final Variable Local
    Java Final Variable Private Member
    Java Final Variable Protected Member
    Java Final Variable Public Member
    Java Static Final Variable Default Member
    Java Static Final Variable Private Member
    Java Static Final Variable Protected Member
    Java Static Final Variable Public Member
    Java Static Variable Default Member
    Java Static Variable Private Member
    Java Static Variable Protected Member
    Java Static Variable Public Member
    Java Unknown Variable Member
    Java Unresolved Variable
    Java Variable Default Member
    Java Variable Local
    Java Variable Private Member
    Java Variable Protected Member
    Java Variable Public Member


L<Back to Top|/__index__>


=head2 Java Reference Kinds

Below are listed the general categories of Java reference kinds, both forward
and inverse relations. When these categories are used literally, as filters,
the full kind names that match have been listed beneath them.

 Call (Callby)
    Java Call
    Java Call Nondynamic

 Cast (Castby)
    Java Cast

 Contain (Containin)
    Java Contain

 Couple (Coupleby)
    Java Couple
    Java Extend Couple
    Java Extend Couple External
    Java Extend Couple Implicit External
    Java Extend Couple Implicit
    Java Implement Couple

 Create (Createby)
    Java Create

 Define (Definein)
    Java Define
    Java Define Implicit

 DotRef (DotRefby)
    Java DotRef

 End (Endby)
    Java End

 Import (Importby)
    Java Import
    Java Import Demand

 Modify (Modifyby)
    Java Modify

 Override (Overrideby)
    Java Override

 Set (Setby)
    Java Set
    Java Set Init
    Java Set Partial

 Typed (Typedby)
    Java Typed

 Use (Useby)
    Java Use
    Java Use Partial

 Throw (Throwby)
    Java Throw


=head2 Jovial Entity Kinds

Below are listed the general categories of Jovial entity kinds. When these
categories are used literally, as filters, the full kind names that match
have been listed beneath them.


 Close
    Jovial Close

 CompoolFile
    Jovial CompoolFile

 File
    Jovial Copy File
    Jovial File
    Jovial Unknown Copy File
    Jovial Unresolved Copy File

 Macro
    Jovial External Macro
    Jovial Local Macro
    Jovial Unresolved Macro

 Module
    Jovial Compool Module

 Parameter
    Jovial Parameter In
    Jovial Parameter Out

 Statusname
    Jovial Statusname

 Subroutine
    Jovial Program Procedure Subroutine
    Jovial External Function Subroutine
    Jovial External Procedure Subroutine
    Jovial Local Function Subroutine
    Jovial Local Procedure Subroutine
    Jovial Unresolved Subroutine

 Switch
    Jovial Switch

 Type
    Jovial Status Type
    Jovial External Type Block
    Jovial External Type Item
    Jovial External Type Table
    Jovial External Component Type Block
    Jovial External Component Type Item
    Jovial External Component Type Table
    Jovial Local Type Block
    Jovial Local Type Item
    Jovial Local Type Table
    Jovial Local Component Type Block
    Jovial Local Component Type Item
    Jovial Local Component Type Table
    Jovial Unresolved Type

 Unknown
    Jovial Unknown
    Jovial Unknown Copy File

 Unresolved Compool
    Jovial Unresolved Compool

 Variable
    Jovial External Constant Variable Item
    Jovial External Constant Variable Table
    Jovial External Constant Component Variable Item
    Jovial External Constant Component Variable Table
    Jovial External Variable Array
    Jovial External Variable Block
    Jovial External Variable FileVar
    Jovial External Variable Item
    Jovial External Variable Table
    Jovial External Component Variable Block
    Jovial External Component Variable Item
    Jovial External Component Variable String
    Jovial External Component Variable Table
    Jovial Local Constant Variable Item
    Jovial Local Constant Variable Table
    Jovial Local Constant Component Variable Item
    Jovial Local Constant Component Variable Table
    Jovial Local Variable Array
    Jovial Local Variable Block
    Jovial Local Variable FileVar
    Jovial Local Variable Item
    Jovial Local Variable Table
    Jovial Local Component Variable Block
    Jovial Local Component Variable Item
    Jovial Local Component Variable String
    Jovial Local Component Variable Table
    Jovial Unresolved Variable


L<Back to Top|/__index__>


=head2 Jovial Reference Kinds

Below are listed the general categories of Jovial reference kinds, both forward
and inverse relations. When these categories are used literally, as filters,
the full kind names that match have been listed beneath them.

 Call (Callby)
    Jovial Call
    Jovial Call Ptr

 Cast (Castby)
    Jovial Cast

 CompoolAccess (CompoolAccessby)
    Jovial CompoolAccess All
    Jovial CompoolAccess

 CompoolFileAccess (CompoolFileAccessby)
    Jovial CompoolFileAccess

 Copy (Copyby)
    Jovial Copy

 Declare (Declarein)
    Jovial Declare
    Jovial Declare Inline

 Define (Definein)
    Jovial Define

 End (Endby)
    Jovial End

 ItemAccess (ItemAccessby)
    Jovial ItemAccess
    Jovial ItemAccess All
    Jovial ItemAccess Implicit

 Like (Likeby)
    Jovial Like

 Overlay (Overlayby)
    Jovial Overlay
    Jovial Overlay Implicit

 Set (Setby)
    Jovial Set
    Jovial Set Init

 Typed (Typedby)
    Jovial Typed Ptr
    Jovial Typed

 Use (Useby)
    Jovial Asm Use
    Jovial Use

 Value (Valueof)
    Jovial Value


=head2 Pascal Entity Kinds

Below are listed the general categories of Pascal entity kinds. When these
categories are used literally, as filters, the full kind names that match
have been listed beneath them.


 Const
    Pascal Const Local
    Pascal Const Global
    Pascal Const Resourcestring Local
    Pascal Const Resourcestring Global

 Entity
    Pascal Unresolved Global Entity

 Enumerator
    Pascal Enumerator Local
    Pascal Enumerator Global

 Environment
    Pascal Environment
    Pascal Unknown Environment
    Pascal Unresolved Environment

 Field
    Pascal Field Private
    Pascal Field Protected
    Pascal Field Public
    Pascal Field Published
    Pascal Field Strict Private
    Pascal Field Strict Protected
    Pascal Field Private Classvar
    Pascal Field Protected Classvar
    Pascal Field Public Classvar
    Pascal Field Published Classvar
    Pascal Field Strict Private Classvar
    Pascal Field Strict Protected Classvar
    Pascal Field Discrim Local
    Pascal Field Discrim Global

 File
    Pascal File
    Pascal File Include
    Pascal Unresolved Include File
    Pascal Sql File

 Function
    Pascal Method Function Private ClassMethod
    Pascal Method Function Private Virtual ClassMethod
    Pascal Method Function Private Virtual Abstract ClassMethod
    Pascal Method Function Protected ClassMethod
    Pascal Method Function Protected Virtual ClassMethod
    Pascal Method Function Protected Virtual Abstract ClassMethod
    Pascal Method Function Public ClassMethod
    Pascal Method Function Public Virtual ClassMethod
    Pascal Method Function Public Virtual Abstract ClassMethod
    Pascal Method Function Published ClassMethod
    Pascal Method Function Published Virtual ClassMethod
    Pascal Method Function Published Virtual Abstract ClassMethod
    Pascal Method Function Strict Private ClassMethod
    Pascal Method Function Strict Private Virtual ClassMethod
    Pascal Method Function Strict Private Virtual Abstract ClassMethod
    Pascal Method Function Strict Protected ClassMethod
    Pascal Method Function Strict Protected Virtual ClassMethod
    Pascal Method Function Strict Protected Virtual Abstract ClassMethod
    Pascal Routine Function Local
    Pascal Routine Function Local Asynchronous
    Pascal Routine Function Global
    Pascal Routine Function Global Asynchronous
    Pascal Method Function Private
    Pascal Method Function Private Virtual
    Pascal Method Function Private Virtual Abstract
    Pascal Method Function Protected
    Pascal Method Function Protected Virtual
    Pascal Method Function Protected Virtual Abstract
    Pascal Method Function Public
    Pascal Method Function Public Virtual
    Pascal Method Function Public Virtual Abstract
    Pascal Method Function Published
    Pascal Method Function Published Virtual
    Pascal Method Function Published Virtual Abstract
    Pascal Method Function Strict Private
    Pascal Method Function Strict Private Virtual
    Pascal Method Function Strict Private Virtual Abstract
    Pascal Method Function Strict Protected
    Pascal Method Function Strict Protected Virtual
    Pascal Method Function Strict Protected Virtual Abstract
    Pascal Parameter Function Local
    Pascal Parameter Function Global
    Pascal Unknown Function
    Pascal Unresolved Global External Function
    Pascal Unresolved Global Function

 Method
    Pascal Method Function Private ClassMethod
    Pascal Method Function Private Virtual ClassMethod
    Pascal Method Function Private Virtual Abstract ClassMethod
    Pascal Method Function Protected ClassMethod
    Pascal Method Function Protected Virtual ClassMethod
    Pascal Method Function Protected Virtual Abstract ClassMethod
    Pascal Method Function Public ClassMethod
    Pascal Method Function Public Virtual ClassMethod
    Pascal Method Function Public Virtual Abstract ClassMethod
    Pascal Method Function Published ClassMethod
    Pascal Method Function Published Virtual ClassMethod
    Pascal Method Function Published Virtual Abstract ClassMethod
    Pascal Method Function Strict Private ClassMethod
    Pascal Method Function Strict Private Virtual ClassMethod
    Pascal Method Function Strict Private Virtual Abstract ClassMethod
    Pascal Method Function Strict Protected ClassMethod
    Pascal Method Function Strict Protected Virtual ClassMethod
    Pascal Method Function Strict Protected Virtual Abstract ClassMethod
    Pascal Method Procedure Private ClassMethod
    Pascal Method Procedure Private Virtual ClassMethod
    Pascal Method Procedure Private Virtual Abstract ClassMethod
    Pascal Method Procedure Protected ClassMethod
    Pascal Method Procedure Protected Virtual ClassMethod
    Pascal Method Procedure Protected Virtual Abstract ClassMethod
    Pascal Method Procedure Public ClassMethod
    Pascal Method Procedure Public Virtual ClassMethod
    Pascal Method Procedure Public Virtual Abstract ClassMethod
    Pascal Method Procedure Published ClassMethod
    Pascal Method Procedure Published Virtual ClassMethod
    Pascal Method Procedure Published Virtual Abstract ClassMethod
    Pascal Method Procedure Strict Private ClassMethod
    Pascal Method Procedure Strict Private Virtual ClassMethod
    Pascal Method Procedure Strict Private Virtual Abstract ClassMethod
    Pascal Method Procedure Strict Protected ClassMethod
    Pascal Method Procedure Strict Protected Virtual ClassMethod
    Pascal Method Procedure Strict Protected Virtual Abstract ClassMethod
    Pascal Method Procedure Constructor Private
    Pascal Method Procedure Contructor Private Virtual
    Pascal Method Procedure Contructor Private Virtual Abstract
    Pascal Method Procedure Contructor Protected
    Pascal Method Procedure Contructor Protected Virtual
    Pascal Method Procedure Contructor Protected Virtual Abstract
    Pascal Method Procedure Contructor Public
    Pascal Method Procedure Contructor Public Virtual
    Pascal Method Procedure Contructor Public Virtual Abstract
    Pascal Method Procedure Contructor Published
    Pascal Method Procedure Contructor Published Virtual
    Pascal Method Procedure Contructor Published Virtual Abstract
    Pascal Method Procedure Constructor Strict Private
    Pascal Method Procedure Contructor Strict Private Virtual
    Pascal Method Procedure Contructor Strict Private Virtual Abstract
    Pascal Method Procedure Contructor Strict Protected
    Pascal Method Procedure Contructor Strict Protected Virtual
    Pascal Method Procedure Contructor Strict Protected Virtual Abstract
    Pascal Method Procedure Destructor Private
    Pascal Method Procedure Destructor Private Virtual
    Pascal Method Procedure Destructor Private Virtual Abstract
    Pascal Method Procedure Destructor Protected
    Pascal Method Procedure Destructor Protected Virtual
    Pascal Method Procedure Destructor Protected Virtual Abstract
    Pascal Method Procedure Destructor Public
    Pascal Method Procedure Destructor Public Virtual
    Pascal Method Procedure Destructor Public Virtual Abstract
    Pascal Method Procedure Destructor Published
    Pascal Method Procedure Destructor Published Virtual
    Pascal Method Procedure Destructor Published Virtual Abstract
    Pascal Method Procedure Destructor Strict Private
    Pascal Method Procedure Destructor Strict Private Virtual
    Pascal Method Procedure Destructor Strict Private Virtual Abstract
    Pascal Method Procedure Destructor Strict Protected
    Pascal Method Procedure Destructor Strict Protected Virtual
    Pascal Method Procedure Destructor Strict Protected Virtual Abstract
    Pascal Method Function Private
    Pascal Method Function Private Virtual
    Pascal Method Function Private Virtual Abstract
    Pascal Method Function Protected
    Pascal Method Function Protected Virtual
    Pascal Method Function Protected Virtual Abstract
    Pascal Method Function Public
    Pascal Method Function Public Virtual
    Pascal Method Function Public Virtual Abstract
    Pascal Method Function Published
    Pascal Method Function Published Virtual
    Pascal Method Function Published Virtual Abstract
    Pascal Method Function Strict Private
    Pascal Method Function Strict Private Virtual
    Pascal Method Function Strict Private Virtual Abstract
    Pascal Method Function Strict Protected
    Pascal Method Function Strict Protected Virtual
    Pascal Method Function Strict Protected Virtual Abstract
    Pascal Method Procedure Private
    Pascal Method Procedure Private Virtual
    Pascal Method Procedure Private Virtual Abstract
    Pascal Method Procedure Protected
    Pascal Method Procedure Protected Virtual
    Pascal Method Procedure Protected Virtual Abstract
    Pascal Method Procedure Public
    Pascal Method Procedure Public Virtual
    Pascal Method Procedure Public Virtual Abstract
    Pascal Method Procedure Published
    Pascal Method Procedure Published Virtual
    Pascal Method Procedure Published Virtual Abstract
    Pascal Method Procedure Strict Private
    Pascal Method Procedure Strict Private Virtual
    Pascal Method Procedure Strict Private Virtual Abstract
    Pascal Method Procedure Strict Protected
    Pascal Method Procedure Strict Protected Virtual
    Pascal Method Procedure Strict Protected Virtual Abstract

 Module
    Pascal CompUnit Module

 Namespace
    Pascal Namespace

 Parameter
    Pascal Parameter Function Local
    Pascal Parameter Function Global
    Pascal Parameter Out Local
    Pascal Parameter Out Global
    Pascal Parameter Procedure Local
    Pascal Parameter Procedure Global
    Pascal Parameter Value Local
    Pascal Parameter Value Global
    Pascal Parameter Var Local
    Pascal Parameter Var Global
    Pascal Type Parameter
    Pascal Sql Parameter

 Procedure
    Pascal Method Procedure Private ClassMethod
    Pascal Method Procedure Private Virtual ClassMethod
    Pascal Method Procedure Private Virtual Abstract ClassMethod
    Pascal Method Procedure Protected ClassMethod
    Pascal Method Procedure Protected Virtual ClassMethod
    Pascal Method Procedure Protected Virtual Abstract ClassMethod
    Pascal Method Procedure Public ClassMethod
    Pascal Method Procedure Public Virtual ClassMethod
    Pascal Method Procedure Public Virtual Abstract ClassMethod
    Pascal Method Procedure Published ClassMethod
    Pascal Method Procedure Published Virtual ClassMethod
    Pascal Method Procedure Published Virtual Abstract ClassMethod
    Pascal Method Procedure Strict Private ClassMethod
    Pascal Method Procedure Strict Private Virtual ClassMethod
    Pascal Method Procedure Strict Private Virtual Abstract ClassMethod
    Pascal Method Procedure Strict Protected ClassMethod
    Pascal Method Procedure Strict Protected Virtual ClassMethod
    Pascal Method Procedure Strict Protected Virtual Abstract ClassMethod
    Pascal Method Procedure Constructor Private
    Pascal Method Procedure Contructor Private Virtual
    Pascal Method Procedure Contructor Private Virtual Abstract
    Pascal Method Procedure Contructor Protected
    Pascal Method Procedure Contructor Protected Virtual
    Pascal Method Procedure Contructor Protected Virtual Abstract
    Pascal Method Procedure Contructor Public
    Pascal Method Procedure Contructor Public Virtual
    Pascal Method Procedure Contructor Public Virtual Abstract
    Pascal Method Procedure Contructor Published
    Pascal Method Procedure Contructor Published Virtual
    Pascal Method Procedure Contructor Published Virtual Abstract
    Pascal Method Procedure Constructor Strict Private
    Pascal Method Procedure Contructor Strict Private Virtual
    Pascal Method Procedure Contructor Strict Private Virtual Abstract
    Pascal Method Procedure Contructor Strict Protected
    Pascal Method Procedure Contructor Strict Protected Virtual
    Pascal Method Procedure Contructor Strict Protected Virtual Abstract
    Pascal Method Procedure Destructor Private
    Pascal Method Procedure Destructor Private Virtual
    Pascal Method Procedure Destructor Private Virtual Abstract
    Pascal Method Procedure Destructor Protected
    Pascal Method Procedure Destructor Protected Virtual
    Pascal Method Procedure Destructor Protected Virtual Abstract
    Pascal Method Procedure Destructor Public
    Pascal Method Procedure Destructor Public Virtual
    Pascal Method Procedure Destructor Public Virtual Abstract
    Pascal Method Procedure Destructor Published
    Pascal Method Procedure Destructor Published Virtual
    Pascal Method Procedure Destructor Published Virtual Abstract
    Pascal Method Procedure Destructor Strict Private
    Pascal Method Procedure Destructor Strict Private Virtual
    Pascal Method Procedure Destructor Strict Private Virtual Abstract
    Pascal Method Procedure Destructor Strict Protected
    Pascal Method Procedure Destructor Strict Protected Virtual
    Pascal Method Procedure Destructor Strict Protected Virtual Abstract
    Pascal Method Procedure Private
    Pascal Method Procedure Private Virtual
    Pascal Method Procedure Private Virtual Abstract
    Pascal Method Procedure Protected
    Pascal Method Procedure Protected Virtual
    Pascal Method Procedure Protected Virtual Abstract
    Pascal Method Procedure Public
    Pascal Method Procedure Public Virtual
    Pascal Method Procedure Public Virtual Abstract
    Pascal Method Procedure Published
    Pascal Method Procedure Published Virtual
    Pascal Method Procedure Published Virtual Abstract
    Pascal Method Procedure Strict Private
    Pascal Method Procedure Strict Private Virtual
    Pascal Method Procedure Strict Private Virtual Abstract
    Pascal Method Procedure Strict Protected
    Pascal Method Procedure Strict Protected Virtual
    Pascal Method Procedure Strict Protected Virtual Abstract
    Pascal Parameter Procedure Local
    Pascal Parameter Procedure Global
    Pascal Routine Procedure Local
    Pascal Routine Procedure Local Asynchronous
    Pascal Routine Procedure Local Initialize
    Pascal Routine Procedure Global
    Pascal Routine Procedure Global Asynchronous
    Pascal Routine Procedure Global Initialize
    Pascal Unresolved Global External Procedure
    Pascal Unresolved Global Procedure
    Pascal Sql Procedure

 Program
    Pascal CompUnit Program

 Property
    Pascal Property Private
    Pascal Property Protected
    Pascal Property Public
    Pascal Property Published
    Pascal Property Strict Private
    Pascal Property Strict Protected

 Routine
    Pascal Routine Function Local
    Pascal Routine Function Local Asynchronous
    Pascal Routine Function Global
    Pascal Routine Function Global Asynchronous
    Pascal Predeclared Routine
    Pascal Routine Procedure Local
    Pascal Routine Procedure Local Asynchronous
    Pascal Routine Procedure Local Initialize
    Pascal Routine Procedure Global
    Pascal Routine Procedure Global Asynchronous
    Pascal Routine Procedure Global Initialize

 Sql
    Pascal Sql Alias
    Pascal Sql Column
    Pascal Sql Cursor
    Pascal Sql Dbevent
    Pascal Sql File
    Pascal Sql Group
    Pascal Sql Index
    Pascal Sql IncludeFile
    Pascal Sql Location
    Pascal Sql Parameter
    Pascal Sql Procedure
    Pascal Sql Profile
    Pascal Sql Role
    Pascal Sql Rule
    Pascal Sql Schema
    Pascal Sql SecurityAlarm
    Pascal Sql Statement
    Pascal Sql StatementPrepared
    Pascal Sql Synonym
    Pascal Sql Table
    Pascal Sql Table GlobalTemp
    Pascal Sql User
    Pascal Sql Unresolved
    Pascal Sql Unresolved Table
    Pascal Sql Variable

 Type
    Pascal Predeclared Type
    Pascal Type Unnamed Local
    Pascal Type Unnamed Local Enum
    Pascal Type Unnamed Local Record
    Pascal Type Class Local
    Pascal Type Class Local Sealed
    Pascal Type Class Global
    Pascal Type Class Global Sealed
    Pascal Type Class Nested Private
    Pascal Type Class Nested Private Sealed
    Pascal Type Class Nested Protected
    Pascal Type Class Nested Protected Sealed
    Pascal Type Class Nested Public
    Pascal Type Class Nested Public Sealed
    Pascal Type Class Nested Published
    Pascal Type Class Nested Published Sealed
    Pascal Type Class Nested Strict Private
    Pascal Type Class Nested Strict Private Sealed
    Pascal Type Class Nested Strict Protected
    Pascal Type Class Nested Strict Protected Sealed
    Pascal Type ClassReference Local
    Pascal Type ClassReference Global
    Pascal Type ClassReference Nested Private
    Pascal Type ClassReference Nested Protected
    Pascal Type ClassReference Nested Public
    Pascal Type ClassReference Nested Published
    Pascal Type ClassReference Nested Strict Private
    Pascal Type ClassReference Nested Strict Protected
    Pascal Type Interface Local
    Pascal Type Interface Global
    Pascal Type Interface Nested Private
    Pascal Type Interface Nested Protected
    Pascal Type Interface Nested Public
    Pascal Type Interface Nested Published
    Pascal Type Interface Nested Strict Private
    Pascal Type Interface Nested Strict Protected
    Pascal Type Object Local
    Pascal Type Object Global
    Pascal Type Local
    Pascal Type Local Record
    Pascal Type Local Enum
    Pascal Type Global
    Pascal Type Global Record
    Pascal Type Global Enum
    Pascal Type Nested Private
    Pascal Type Nested Private Enum
    Pascal Type Nested Private Record
    Pascal Type Nested Protected
    Pascal Type Nested Protected Enum
    Pascal Type Nested Protected Record
    Pascal Type Nested Public
    Pascal Type Nested Public Enum
    Pascal Type Nested Public Record
    Pascal Type Nested Published
    Pascal Type Nested Published Enum
    Pascal Type Nested Published Record
    Pascal Type Nested Strict Private
    Pascal Type Nested Strict Private Enum
    Pascal Type Nested Strict Private Record
    Pascal Type Nested Strict Protected
    Pascal Type Nested Strict Protected Enum
    Pascal Type Nested Strict Protected Record
    Pascal Type Parameter
    Pascal Unknown Type Class
    Pascal Unknown Type Interface
    Pascal Unknown Type
    Pascal Unresolved Global Type

 Unit
    Pascal CompUnit Unit

 Variable
    Pascal Predeclared Variable
    Pascal Variable Local
    Pascal Variable Global
    Pascal Variable Threadvar Local
    Pascal Variable Threadvar Global
    Pascal Unknown Variable
    Pascal Unresolved Global Variable
    Pascal Sql Variable


L<Back to Top|/__index__>


=head2 Pascal Reference Kinds

Below are listed the general categories of Pascal reference kinds, both forward
and inverse relations. When these categories are used literally, as filters,
the full kind names that match have been listed beneath them.

 Call (Callby)
    Pascal Call
    Pascal Call Virtual
    Pascal Call Ptr
    Pascal Sql Call
    Pascal Sql Call Statement

 Cast (Castby)
    Pascal Cast

 Classof (Classofby)
    Pascal Classof

 Contain (Containin)
    Pascal Contain

 Declare (Declarein)
    Pascal Declare

 Define (Definein)
    Pascal Define
    Pascal Sql Define

 Derive (Derivefrom)
    Pascal Derive

 DotRef (DotRefby)
    Pascal DotRef

 End (Endby)
    Pascal End

 Hasenvironment (Hasenvironmentby)
    Pascal Hasenvironment

 HelperFor (HelperForby)
    Pascal HelperFor

 Implement (Implementby)
    Pascal Implement

 Include (Includeby)
    Pascal Include

 Inherit (Inheritby)
    Pascal Inherit
    Pascal Inherit Useunit
    Pascal Inherit Useunit Implicit

 Inheritenv (Inheritenvby)
    Pascal Inheritenv

 Overload (Overloadby)
    Pascal Overload

 Override (Overrideby)
    Pascal Override

 Set (Setby)
    Pascal Set
    Pascal Set Init
    Pascal Sql Set

 Typed (Typedby)
    Pascal Typed
    Pascal Sql Typed

 Use (Useby)
    Pascal Handle Use
    Pascal Raise Use
    Pascal Use
    Pascal Use Read
    Pascal Use Write
    Pascal Sql Use


=head2 Plm Entity Kinds

Below are listed the general categories of Plm entity kinds. When these
categories are used literally, as filters, the full kind names that match
have been listed beneath them.


 File
    Plm File
    Plm Unknown File
    Plm Unresolved File

 Label
    Plm Label
    Plm Public Label
    Plm Unknown Label
    Plm Unresolved Label

 Macro
    Plm Macro
    Plm Unresolved Macro

 Module
    Plm Main Module
    Plm Module

 Parameter
    Plm Parameter
    Plm Public Parameter
    Plm Unresolved Parameter

 Procedure
    Plm Predeclared Typed Procedure
    Plm Predeclared Untyped Procedure
    Plm Typed Procedure
    Plm Typed Procedure Reentrant
    Plm Typed Public Procedure
    Plm Typed Public Procedure Reentrant
    Plm Untyped Interrupt Procedure
    Plm Untyped Interrupt Procedure Reentrant
    Plm Untyped Procedure
    Plm Untyped Procedure Reentrant
    Plm Untyped Public Interrupt Procedure
    Plm Untyped Public Interrupt Procedure Reentrant
    Plm Untyped Public Procedure
    Plm Untyped Public Procedure Reentrant
    Plm Unknown Typed Procedure
    Plm Unknown Untyped Procedure
    Plm Unresolved Typed Procedure
    Plm Unresolved Typed Procedure Reentrant
    Plm Unresolved Untyped Interrupt Procedure
    Plm Unresolved Untyped Interrupt Procedure Reentrant
    Plm Unresolved Untyped Procedure
    Plm Unresolved Untyped Procedure Reentrant

 Variable
    Plm Based Variable
    Plm Member Variable
    Plm Predeclared Variable
    Plm Public Variable
    Plm Unknown Member Variable
    Plm Unknown Variable
    Plm Unresolved Member Variable
    Plm Unresolved Variable
    Plm Variable


L<Back to Top|/__index__>


=head2 Plm Reference Kinds

Below are listed the general categories of Plm reference kinds, both forward
and inverse relations. When these categories are used literally, as filters,
the full kind names that match have been listed beneath them.

 Call (Callby)
    Plm Call
    Plm Call Address

 Declare (Declarein)
    Plm Declare
    Plm Declare External
    Plm Declare Formal
    Plm Declare Implicit
    Plm Declare Label
    Plm Declare Public

 End (Endby)
    Plm End

 Include (Includeby)
    Plm Include

 LocationRef (LocationRefby)
    Plm LocationRef

 Overlay (Overlayby)
    Plm Overlay

 Set (Setby)
    Plm Set
    Plm Set Init

 Use (Useby)
    Plm Use

 Base (Basefor)
    Plm Base


=head2 Python Entity Kinds

Below are listed the general categories of Python entity kinds. When these
categories are used literally, as filters, the full kind names that match
have been listed beneath them.


 Attribute
    Python Function Attribute
    Python Function Attribute Static
    Python Function Attribute Special
    Python Function Attribute Special Static
    Python Unresolved Attribute
    Python Unresolved Function Attribute
    Python Unresolved Function Attribute Special
    Python Variable Attribute
    Python Variable Attribute Instance
    Python Variable Attribute Property

 Class
    Python Class
    Python Unknown Class
    Python Unresolved Class

 File
    Python File
    Python Unresolved File

 Function
    Python Function
    Python Function Attribute
    Python Function Attribute Static
    Python Function Attribute Special
    Python Function Attribute Special Static
    Python Unresolved Function
    Python Unresolved Function Attribute
    Python Unresolved Function Attribute Special

 LambdaParameter
    Python LambdaParameter

 Module
    Python Unknown Module

 Package
    Python Package
    Python Unknown Package

 Parameter
    Python Parameter
    Python Unresolved Parameter

 Variable
    Python Unknown Variable
    Python Unresolved Variable
    Python Variable Attribute
    Python Variable Attribute Instance
    Python Variable Attribute Property
    Python Variable Global
    Python Variable Local


L<Back to Top|/__index__>


=head2 Python Reference Kinds

Below are listed the general categories of Python reference kinds, both forward
and inverse relations. When these categories are used literally, as filters,
the full kind names that match have been listed beneath them.

 Alias (Aliasfor)
    Python Alias

 Call (Callby)
    Python Call

 Contain (Containin)
    Python Contain

 Declare (Declarein)
    Python Declare

 Define (Definein)
    Python Define

 DotRef (DotRefby)
    Python DotRef

 End (Endby)
    Python End

 Getter (Getterfor)
    Python Getter

 Import (Importby)
    Python Import
    Python Import From
    Python Import Implicit

 Inherit (Inheritby)
    Python Inherit

 Modify (Modifyby)
    Python Modify

 Raise (Raiseby)
    Python Raise

 Set (Setby)
    Python Set
    Python Set Init

 Setter (Setterfor)
    Python Setter

 Use (Useby)
    Python Use Alloc
    Python Use


=head2 Unparsed Entity Kinds

Below are listed the general categories of Unparsed entity kinds. When these
categories are used literally, as filters, the full kind names that match
have been listed beneath them.


 File
    Unparsed File


L<Back to Top|/__index__>


=head2 Unparsed Reference Kinds

Below are listed the general categories of Unparsed reference kinds, both forward
and inverse relations. When these categories are used literally, as filters,
the full kind names that match have been listed beneath them.


=head2 Vhdl Entity Kinds

Below are listed the general categories of Vhdl entity kinds. When these
categories are used literally, as filters, the full kind names that match
have been listed beneath them.


 Alias
    Vhdl Alias

 Architecture
    Vhdl Architecture
    Vhdl Unknown Architecture
    Vhdl Unresolved Architecture

 Attribute
    Vhdl Attribute
    Vhdl Predefined Attribute
    Vhdl Unknown Attribute
    Vhdl Unresolved Attribute

 Component
    Vhdl Component
    Vhdl Unknown Component
    Vhdl Unresolved Component

 Configuration
    Vhdl Configuration
    Vhdl Unknown Configuration
    Vhdl Unresolved Configuration

 Constant
    Vhdl Constant
    Vhdl Unknown Constant
    Vhdl Unresolved Constant

 Entity
    Vhdl Entity
    Vhdl Unknown Entity
    Vhdl Unresolved Entity

 File
    Vhdl File
    Vhdl Unknown File
    Vhdl Unresolved File

 Function
    Vhdl Impure Function
    Vhdl Pure Function
    Vhdl Unknown Function
    Vhdl Unresolved Function

 Generic
    Vhdl Generic

 Group
    Vhdl Group
    Vhdl Group Template
    Vhdl Unknown Group
    Vhdl Unresolved Group

 Label
    Vhdl Block Label
    Vhdl Generate Label
    Vhdl Instantiation Label
    Vhdl Label
    Vhdl Unknown Label
    Vhdl Unresolved Label

 Library
    Vhdl Library
    Vhdl Working Library

 Literal
    Vhdl Literal
    Vhdl Unknown Literal
    Vhdl Unresolved Literal

 Member
    Vhdl Member

 Object
    Vhdl FileObject Object

 Package
    Vhdl Package
    Vhdl Unknown Package
    Vhdl Unresolved Package

 Parameter
    Vhdl FileParameter Parameter
    Vhdl Generate Parameter
    Vhdl Inout Parameter
    Vhdl Inout SignalParameter Parameter
    Vhdl In Parameter
    Vhdl In SignalParameter Parameter
    Vhdl Out Parameter
    Vhdl Out SignalParameter Parameter

 Port
    Vhdl Buffer Port
    Vhdl Inout Port
    Vhdl In Port
    Vhdl Out Port

 Procedure
    Vhdl Procedure
    Vhdl Unknown Procedure
    Vhdl Unresolved Procedure

 Process
    Vhdl Postponed Process
    Vhdl Process

 Signal
    Vhdl Signal
    Vhdl Unknown Signal
    Vhdl Unresolved Signal

 Subtype
    Vhdl Subtype
    Vhdl Unknown Subtype
    Vhdl Unresolved Subtype

 Type
    Vhdl Enumeration Type
    Vhdl FileType Type
    Vhdl Record Type
    Vhdl Type
    Vhdl Unknown Type
    Vhdl Unresolved Type

 Unit
    Vhdl Unit
    Vhdl Unknown Unit
    Vhdl Unresolved Unit

 Unknown
    Vhdl Unknown
    Vhdl Unknown Architecture
    Vhdl Unknown Attribute
    Vhdl Unknown Component
    Vhdl Unknown Configuration
    Vhdl Unknown Constant
    Vhdl Unknown Entity
    Vhdl Unknown File
    Vhdl Unknown Function
    Vhdl Unknown Group
    Vhdl Unknown Label
    Vhdl Unknown Literal
    Vhdl Unknown Package
    Vhdl Unknown Procedure
    Vhdl Unknown Signal
    Vhdl Unknown Subtype
    Vhdl Unknown Type
    Vhdl Unknown Unit
    Vhdl Unknown Variable

 Unresolved
    Vhdl Unresolved
    Vhdl Unresolved Architecture
    Vhdl Unresolved Attribute
    Vhdl Unresolved Component
    Vhdl Unresolved Configuration
    Vhdl Unresolved Constant
    Vhdl Unresolved Entity
    Vhdl Unresolved File
    Vhdl Unresolved Function
    Vhdl Unresolved Group
    Vhdl Unresolved Label
    Vhdl Unresolved Literal
    Vhdl Unresolved Package
    Vhdl Unresolved Procedure
    Vhdl Unresolved Signal
    Vhdl Unresolved Subtype
    Vhdl Unresolved Type
    Vhdl Unresolved Unit
    Vhdl Unresolved Variable

 Variable
    Vhdl Shared Variable
    Vhdl Unknown Variable
    Vhdl Unresolved Variable
    Vhdl Variable


L<Back to Top|/__index__>


=head2 Vhdl Reference Kinds

Below are listed the general categories of Vhdl reference kinds, both forward
and inverse relations. When these categories are used literally, as filters,
the full kind names that match have been listed beneath them.

 AliasRef (AliasReffor)
    Vhdl AliasRef

 Bind (Bindby)
    Vhdl Bind
    Vhdl Implicit Bind

 Call (Callby)
    Vhdl Call

 Configure (Configureby)
    Vhdl Configure

 Declare (Declarein)
    Vhdl Body Declare
    Vhdl Declare
    Vhdl Incomplete Declare

 Decorate (Decorateby)
    Vhdl Decorate

 End (Endby)
    Vhdl End

 Implement (Implementby)
    Vhdl Implement

 Instantiate (Instantiateby)
    Vhdl Instantiate

 Map (Mapby)
    Vhdl Map
    Vhdl Map Formal

 Return (Returnby)
    Vhdl Return

 Set (Setby)
    Vhdl Set
    Vhdl Set Init

 Typed (Typedby)
    Vhdl Typed

 Use (Useby)
    Vhdl Use
    Vhdl Use Name

 Wait (Waitby)
    Vhdl Wait


=head2 Web Entity Kinds

Below are listed the general categories of Web entity kinds. When these
categories are used literally, as filters, the full kind names that match
have been listed beneath them.


 Alias
    Web Php Import Alias

 Anchor Target
    Web Html Anchor Target

 Applet
    Web Applet

 Attribute
    Web Xml Attribute
    Web Xml Attribute Value

 Class
    Web Css Class
    Web Css Pseudo Class
    Web Javascript Function Class
    Web Javascript Unresolved Function Class
    Web Php Abstract Class
    Web Php Class
    Web Php Final Class
    Web Php Unresolved Class

 Constant
    Web Php Constant
    Web Php Public Property Constant
    Web Php Unresolved Constant
    Web Php Unresolved Property Constant

 Data
    Web Xml Data

 Element
    Web Xml Element

 File
    Web File
    Web Javascript Unresolved File
    Web Unknown File
    Web Unresolved File

 FontFamily
    Web Css FontFamily

 Frame Name
    Web Html Frame Name

 Function
    Web Javascript Function
    Web Javascript Function Class
    Web Javascript Method Function
    Web Javascript Method Function Instance
    Web Javascript Method Function Static
    Web Javascript Unnamed Function
    Web Javascript Unresolved Function
    Web Javascript Unresolved Function Class
    Web Javascript Unresolved Function Method
    Web Php Function
    Web Php Function Anonymous
    Web Php Function Reference
    Web Php Private Method Abstract Function
    Web Php Private Method Abstract Reference Function
    Web Php Private Method Final Function
    Web Php Private Method Final Reference Function
    Web Php Private Method Function
    Web Php Private Method Reference Function
    Web Php Protected Method Abstract Function
    Web Php Protected Method Abstract Reference Function
    Web Php Protected Method Final Function
    Web Php Protected Method Final Reference Function
    Web Php Protected Method Function
    Web Php Protected Method Reference Function
    Web Php Public Method Abstract Function
    Web Php Public Method Abstract Reference Function
    Web Php Public Method Final Function
    Web Php Public Method Final Reference Function
    Web Php Public Method Function
    Web Php Public Method Reference Function
    Web Php Unresolved Function
    Web Php Unresolved Method Function

 Id
    Web Css Id
    Web Css Unresolved Id
    Web Html Tag Id

 Interface
    Web Php Interface

 JQuery Selector
    Web Javascript JQuery Selector

 Keyframe
    Web Css Keyframe

 Media
    Web Css Media

 Module
    Web Javascript Predefined Module

 Namespace
    Web Php Namespace
    Web Php Unresolved Namespace

 Object
    Web Javascript Predefined Object

 Page
    Web Css Page

 Parameter
    Web Javascript Parameter
    Web Php Parameter

 Property
    Web Css Property
    Web Javascript Property
    Web Javascript Property Instance
    Web Javascript Property Static
    Web Javascript Unresolved Property
    Web Php Private Property Variable
    Web Php Private Static Property Variable
    Web Php Protected Property Variable
    Web Php Protected Static Property Variable
    Web Php Public Property Constant
    Web Php Public Property Variable
    Web Php Public Static Property Variable
    Web Php Unresolved Property Constant
    Web Php Unresolved Property Variable

 Tag Name
    Web Html Tag Name

 Tag Value
    Web Html Tag Value

 TypeSelector
    Web Css TypeSelector

 Unknown Fragment
    Web Html Unknown Fragment

 Unresolved
    Web Css Unresolved Id
    Web Html Unresolved
    Web Javascript Unresolved File
    Web Javascript Unresolved Function
    Web Javascript Unresolved Function Class
    Web Javascript Unresolved Function Method
    Web Javascript Unresolved Property
    Web Javascript Unresolved Variable Global
    Web Php Unresolved Class
    Web Php Unresolved Constant
    Web Php Unresolved Function
    Web Php Unresolved Method Function
    Web Php Unresolved Namespace
    Web Php Unresolved Property Constant
    Web Php Unresolved Property Variable
    Web Php Unresolved Variable
    Web Unresolved File

 Variable
    Web Javascript Variable Global
    Web Javascript Variable Local
    Web Javascript Unresolved Variable Global
    Web Php Private Property Variable
    Web Php Private Static Property Variable
    Web Php Protected Property Variable
    Web Php Protected Static Property Variable
    Web Php Public Property Variable
    Web Php Public Static Property Variable
    Web Php Unresolved Property Variable
    Web Php Unresolved Variable
    Web Php Variable Global
    Web Php Variable Local


L<Back to Top|/__index__>


=head2 Web Reference Kinds

Below are listed the general categories of Web reference kinds, both forward
and inverse relations. When these categories are used literally, as filters,
the full kind names that match have been listed beneath them.

 Alias (Aliasfor)
    Web Php Alias

 Call (Callby)
    Web Html Call
    Web Javascript Call
    Web Javascript Call Ptr
    Web Javascript Call New
    Web Php Call
    Web Php Call Ptr

 Contain (Containin)
    Web Xml Contain

 Declare (Declarein)
    Web Html Declare
    Web Php Declare

 Define (Definein)
    Web Css Define
    Web Html Define
    Web Javascript Define
    Web Javascript Define Implicit
    Web Javascript Prototype Define Implicit
    Web Javascript This Define Implicit
    Web Php Define
    Web Php Define Implicit
    Web Xml Define

 End (Endby)
    Web Javascript End
    Web Php End
    Web Xml End

 Extend (Extendby)
    Web Javascript Extend
    Web Php Extend

 Getter (Getterfor)
    Web Javascript Getter

 Implement (Implementby)
    Web Php Implement

 Import (Importby)
    Web Css Import
    Web Php Import

 Include (Includeby)
    Web Php Include

 Link (Linkby)
    Web Html Link

 Modify (Modifyby)
    Web Javascript Modify
    Web Php Modify

 Require (Requireby)
    Web Javascript Require
    Web Php Require

 Set (Setby)
    Web Css Set
    Web Css Set Important
    Web Javascript Set
    Web Javascript Set Init
    Web Php Set
    Web Xml Set

 Setter (Setterfor)
    Web Javascript Setter

 Setto (Settoby)
    Web Javascript Setto
    Web Xml Setto

 Src (Srcby)
    Web Html Src

 Typed (Typedby)
    Web Php Typed
    Web Php Typed Implicit

 Use (Useby)
    Web Css Use
    Web Html Style Use
    Web Html Use
    Web Javascript Use
    Web Javascript String Use
    Web Php Use
    Web Php Use Implicit


=cut

