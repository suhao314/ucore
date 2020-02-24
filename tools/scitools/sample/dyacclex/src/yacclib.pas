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

unit yacclib;

interface

const
  yymaxdepth = 1024;
(* default stack size of parser *)

type
  YYSType = integer;
(* default value type, may be redefined in Yacc output file *)

var

  yychar:  integer; (* current lookahead character *)
  yynerrs: integer;

(* current number of syntax errors reported by the
                       parser *)
procedure yyerror(msg: string);
(* error message printing routine used by the parser *)

procedure yyclearin;
(* delete the current lookahead token *)

procedure yyaccept;
  (* trigger accept action of the parser; yyparse accepts returning 0, as if
     it reached end of input *)

procedure yyabort;
  (* like yyaccept, but causes parser to return with value 1, as if an
     unrecoverable syntax error had been encountered *)

procedure yyerrlab;
  (* causes error recovery to be started, as if a syntax error had been
     encountered *)

procedure yyerrok;
  (* when in error mode, resets the parser to its normal mode of
     operation *)

(* Flags used internally by the parser routine: *)

var

  yyflag:    (yyfnone, yyfaccept, yyfabort, yyferror);
  yyerrflag: integer;

implementation

procedure yyerror(msg: string);
begin
  writeln(msg);
end(*yyerrmsg*);

procedure yyclearin;
begin
  yychar := -1;
end(*yyclearin*);

procedure yyaccept;
begin
  yyflag := yyfaccept;
end(*yyaccept*);

procedure yyabort;
begin
  yyflag := yyfabort;
end(*yyabort*);

procedure yyerrlab;
begin
  yyflag := yyferror;
end(*yyerrlab*);

procedure yyerrok;
begin
  yyerrflag := 0;
end(*yyerrork*);

end(*YaccLib*).
