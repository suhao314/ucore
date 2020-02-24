#
# Delphi Yacc & Lex
# Copyright (c) 2003,2004 by Michiel Rook
# Based on Turbo Pascal Lex and Yacc Version 4.1
# Compiler generator toolset for Turbo/Borland/Free Pascal and Delphi
#
# Copyright (c) 1990-2000 by Albert Graef
#                       <ag@muwiinfa.geschichte.uni-mainz.de>
# Copyright (c) 1996 by Berend de Boer
#                       <berend@pobox.com>
# Copyright (c) 1998 by Michael Van Canneyt
#                       <Michael.VanCanneyt@fys.kuleuven.ac.be>
#
# Lex Makefile - Use GNU make!
#
# $Id: Makefile 11962 2005-10-27 14:47:09Z dpollard $
#


ifeq ($(OSTYPE),linux-gnu)
	LINUX=1
else
	WIN32=1
endif


ifdef WIN32
DCC=dcc32

LEX=dlex.exe

MAKE=$(CURDIR)/../make

ifeq ($(OS), Windows_NT)
	RM=cmd /c del
else
	RM=del
endif
endif


ifdef LINUX
DCC=/usr/local/bin/dcc

LEX=dlex
RM=rm -f
endif

DCC_FLAGS=-D- -Q -GD

LEX_SOURCES=dlex.dpr
LEX_UNITS=lexbase.pas lexdfa.pas lexlist.pas lexmsgs.pas lexopt.pas lexpos.pas lexrules.pas lextable.pas
UNITDIRS=..


all:	$(LEX)
      
clean:
	$(RM) $(LEX) 
	$(RM) *.map
	$(RM) *.dcu
	$(RM) *.dpu
	$(RM) *.drc
	$(RM) *.dcp

$(LEX):	$(LEX_SOURCES) $(LEX_UNITS)
	$(DCC) $(LEX_SOURCES) $(DCC_FLAGS) -U$(UNITDIRS)
