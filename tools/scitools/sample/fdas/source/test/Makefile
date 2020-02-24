# Makefile for fdas test directory.
# Version for NAG f90 compiler.
# Richard Maine, 21 Aug 92
#

LIBDIR = ../../lib
MODDIR = ../../mod

FFLAGS = -O

.SUFFIXES:
.SUFFIXES: .f90 $(SUFFIXES)

.f90.o:
	f90 $(FFLAGS) -I$(MODDIR) -c $<

.PHONY: all clean

all: gdTest

gdTest: gdTest.o
	f90 -L${LIBDIR} \
	  gdTest.o -lthWrite -lgdRead -lthRead -lmisc \
	  -o  $@

clean:; rm -f *.o *.mod

###
