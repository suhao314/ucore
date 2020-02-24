{
  Delphi Yacc & Lex
  Copyright (c) 2003,2004 by Michiel Rook
  Based on Turbo Pascal Lex and Yacc Version 4.1

  Copyright (c) 1990-92  Albert Graef <ag@muwiinfa.geschichte.uni-mainz.de>
  Copyright (C) 1996     Berend de Boer <berend@pobox.com>
  Copyright (c) 1998     Michael Van Canneyt <Michael.VanCanneyt@fys.kuleuven.ac.be>
  
  ## $Id: dyacc.dpr 11962 2005-10-27 14:47:09Z dpollard $

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}

{$I-}

unit lexlib;

interface

(* The Lex library unit supplies a collection of variables and routines
   needed by the lexical analyzer routine yylex and application programs
   using Lex-generated lexical analyzers. It also provides access to the
   input/output streams used by the lexical analyzer and the text of the
   matched string, and provides some utility functions which may be used
   in actions.

   This `standard' version of the LexLib unit is used to implement lexical
   analyzers which read from and write to MS-DOS files (using standard input
   and output, by default). It is suitable for many standard applications
   for lexical analyzers, such as text conversion tools or compilers.

   However, you may create your own version of the LexLib unit, tailored to
   your target applications. In particular, you may wish to provide another
   set of I/O functions, e.g., if you want to read from or write to memory
   instead to files, or want to use different file types. *)

(* Variables:

   The variable yytext contains the current match, length(yytext) its length.
   The variable yyline contains the current input line, and yylineno and
   yycolno denote the current input position (line, column). These values
   are often used in giving error diagnostics (however, they will only be
   meaningful if there is no rescanning across line ends).

   The variables yyinput and yyoutput are the text files which are used
   by the lexical analyzer. By default, they are assigned to standard
   input and output, but you may change these assignments to fit your
   target application (use the Turbo Pascal standard routines assign,
   reset, and rewrite for this purpose). *)

var
  yyinput, yyoutput: Text;        (* input and output file *)
  yyline: string;      (* current input line *)
  yylineno, yycolno: integer;     (* current input position *)
  yytext: string;      (* matched text (should be considered r/o) *)

(* I/O routines:

   The following routines get_char, unget_char and put_char are used to
   implement access to the input and output files. Since \n (newline) for
   Lex means line end, the I/O routines have to translate MS-DOS line ends
   (carriage-return/line-feed) into newline characters and vice versa. Input
   is buffered to allow rescanning text (via unput_char).

   The input buffer holds the text of the line to be scanned. When the input
   buffer empties, a new line is obtained from the input stream. Characters
   can be returned to the input buffer by calls to unget_char. At end-of-
   file a null character is returned.

   The input routines also keep track of the input position and set the
   yyline, yylineno, yycolno variables accordingly.

   Since the rest of the Lex library only depends on these three routines
   (there are no direct references to the yyinput and yyoutput files or
   to the input buffer), you can easily replace get_char, unget_char and
   put_char by another suitable set of routines, e.g. if you want to read
   from/write to memory, etc. *)

function get_char: char;
  (* obtain one character from the input file (null character at end-of-
     file) *)

procedure unget_char(c: char);
  (* return one character to the input file to be reread in subsequent calls
     to get_char *)

procedure put_char(c: char);
(* write one character to the output file *)

(* Utility routines: *)

procedure echo;
(* echoes the current match to the output stream *)

procedure yymore;
(* append the next match to the current one *)

procedure yyless(n: integer);
  (* truncate yytext to size n and return the remaining characters to the
     input stream *)

procedure reject;
(* reject the current match and execute the next one *)

  (* reject does not actually cause the input to be rescanned; instead,
     internal state information is used to find the next match. Hence
     you should not try to modify the input stream or the yytext variable
     when rejecting a match. *)

procedure return(n: integer);
procedure returnc(c: char);
(* sets the return value of yylex *)

procedure start(state: integer);
  (* puts the lexical analyzer in the given start state; state=0 denotes
     the default start state, other values are user-defined *)

(* yywrap:

   The yywrap function is called by yylex at end-of-file (unless you have
   specified a rule matching end-of-file). You may redefine this routine
   in your Lex program to do application-dependent processing at end of
   file. In particular, yywrap may arrange for more input and return false
   in which case the yylex routine resumes lexical analysis. *)

function yywrap: boolean;
  (* The default yywrap routine supplied here closes input and output files
     and returns true (causing yylex to terminate). *)

(* The following are the internal data structures and routines used by the
   lexical analyzer routine yylex; they should not be used directly. *)

var

  yystate:    integer; (* current state of lexical analyzer *)
  yyactchar:  char;    (* current character *)
  yylastchar: char;    (* last matched character (#0 if none) *)
  yyrule:     integer; (* matched rule *)
  yyreject:   boolean; (* current match rejected? *)
  yydone:     boolean; (* yylex return value set? *)
  yyretval:   integer; (* yylex return value *)

procedure yynew;
  (* starts next match; initializes state information of the lexical
     analyzer *)

procedure yyscan;
  (* gets next character from the input stream and updates yytext and
     yyactchar accordingly *)

procedure yymark(n: integer);
(* marks position for rule no. n *)

procedure yymatch(n: integer);
(* declares a match for rule number n *)

function yyfind(var n: integer): boolean;
  (* finds the last match and the corresponding marked position and adjusts
     the matched string accordingly; returns:
     - true if a rule has been matched, false otherwise
     - n: the number of the matched rule *)

function yydefault: boolean;
  (* executes the default action (copy character); returns true unless
     at end-of-file *)

procedure yyclear;
  (* reinitializes state information after lexical analysis has been
     finished *)

implementation

procedure fatal(msg: string);
(* writes a fatal error message and halts program *)
begin
  writeln('LexLib: ', msg);
  halt(1);
end(*fatal*);

(* I/O routines: *)

const
  nl = #10;  (* newline character *)

const
  max_chars = 2048;

var

  bufptr: integer;
  buf:    array [1..max_chars] of char;

function get_char: char;
var
  i: integer;
begin
  if (bufptr = 0) and not EOF(yyinput) then
  begin
    readln(yyinput, yyline);
    Inc(yylineno);
    yycolno := 1;
    buf[1]  := nl;
    for i := 1 to length(yyline) do
      buf[i + 1] := yyline[length(yyline) - i + 1];
    Inc(bufptr, length(yyline) + 1);
  end;
  if bufptr > 0 then
  begin
    Result := buf[bufptr];
    Dec(bufptr);
    Inc(yycolno);
  end
  else
    Result := #0;
end(*get_char*);

procedure unget_char(c: char);
begin
  if bufptr = max_chars then
    fatal('input buffer overflow');
  Inc(bufptr);
  Dec(yycolno);
  buf[bufptr] := c;
end(*unget_char*);

procedure put_char(c: char);
begin
  if c = #0 then
  { ignore }
  else if c = nl then
    writeln(yyoutput)
  else
    Write(yyoutput, c)
end(*put_char*);

(* Variables:

   Some state information is maintained to keep track with calls to yymore,
   yyless, reject, start and yymatch/yymark, and to initialize state
   information used by the lexical analyzer.
   - yystext: contains the initial contents of the yytext variable; this
     will be the empty string, unless yymore is called which sets yystext
     to the current yytext
   - yysstate: start state of lexical analyzer (set to 0 during
     initialization, and modified in calls to the start routine)
   - yylstate: line state information (1 if at beginning of line, 0
     otherwise)
   - yystack: stack containing matched rules; yymatches contains the number of
     matches
   - yypos: for each rule the last marked position (yymark); zeroed when rule
     has already been considered
   - yysleng: copy of the original length(yytext) used to restore state information
     when reject is used *)

const

  max_matches = 1024;
  max_rules   = 256;

var

  yystext:   string;
  yysstate, yylstate: integer;
  yymatches: integer;
  yystack:   array [1..max_matches] of integer;
  yypos:     array [1..max_rules] of integer;
  yysleng:   byte;

(* Utilities: *)

procedure echo;
var
  i: integer;
begin
  for i := 1 to length(yytext) do
    put_char(yytext[i])
end(*echo*);

procedure yymore;
begin
  yystext := yytext;
end(*yymore*);

procedure yyless(n: integer);
var
  i: integer;
begin
  for i := length(yytext) downto n + 1 do
    unget_char(yytext[i]);
  setlength(yytext, n);
end(*yyless*);

procedure reject;
var
  i: integer;
begin
  yyreject := True;
  for i := length(yytext) + 1 to yysleng do
    yytext := yytext + get_char;
  Dec(yymatches);
end(*reject*);

procedure return(n: integer);
begin
  yyretval := n;
  yydone   := True;
end(*return*);

procedure returnc(c: char);
begin
  yyretval := Ord(c);
  yydone   := True;
end(*returnc*);

procedure start(state: integer);
begin
  yysstate := state;
end(*start*);

(* yywrap: *)

function yywrap: boolean;
begin
  Close(yyinput);
  Close(yyoutput);
  Result := True;
end(*yywrap*);

(* Internal routines: *)

procedure yynew;
begin
  if yylastchar <> #0 then
    if yylastchar = nl then
      yylstate := 1
    else
      yylstate := 0;
  yystate := yysstate + yylstate;
  yytext    := yystext;
  yystext   := '';
  yymatches := 0;
  yydone    := False;
end(*yynew*);

procedure yyscan;
begin
  if length(yytext) = 255 then
    fatal('yytext overflow');
  yyactchar := get_char;
  yytext    := yytext + yyactchar;
end(*yyscan*);

procedure yymark(n: integer);
begin
  if n > max_rules then
    fatal('too many rules');
  yypos[n] := length(yytext);
end(*yymark*);

procedure yymatch(n: integer);
begin
  Inc(yymatches);
  if yymatches > max_matches then
    fatal('match stack overflow');
  yystack[yymatches] := n;
end(*yymatch*);

function yyfind(var n: integer): boolean;
begin
  yyreject := False;
  while (yymatches > 0) and (yypos[yystack[yymatches]] = 0) do
    Dec(yymatches);
  if yymatches > 0 then
  begin
    yysleng := length(yytext);
    n := yystack[yymatches];
    yyless(yypos[n]);
    yypos[n] := 0;
    if length(yytext) > 0 then
      yylastchar := yytext[length(yytext)]
    else
      yylastchar := #0;
    Result := True;
  end
  else begin
    yyless(0);
    yylastchar := #0;
    Result     := False;
  end
end(*yyfind*);

function yydefault: boolean;
begin
  yyreject  := False;
  yyactchar := get_char;
  if yyactchar <> #0 then
  begin
    put_char(yyactchar);
    Result := True;
  end
  else begin
    yylstate := 1;
    Result   := False;
  end;
  yylastchar := yyactchar;
end(*yydefault*);

procedure yyclear;
begin
  bufptr     := 0;
  yysstate   := 0;
  yylstate   := 1;
  yylastchar := #0;
  yytext     := '';
  yystext    := '';
end(*yyclear*);

begin
  Assign(yyinput, '');
  Assign(yyoutput, '');
  reset(yyinput);
  rewrite(yyoutput);
  yylineno := 0;
  yyclear;
end(*LexLib*).
