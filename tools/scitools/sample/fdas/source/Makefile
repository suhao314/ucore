# Makefile for getData f90 source directory.
# Version for NAG f90 compiler.
# This version makes only the libraries used in the
# self-contained, generic compiler test
# Richard Maine.  22 Dec 92.
#

LIBDIR = ../../lib
MODDIR = ../../mod

.PHONY: all clean

all:
	cd misc; $(MAKE) install
	cd thRead; $(MAKE) install
	cd gdRead; $(MAKE) install
	cd thWrite; $(MAKE) install
	cd test; $(MAKE) gdTest

clean:
	cd misc; $(MAKE) clean
	cd thRead; $(MAKE) clean
	cd gdRead; $(MAKE) clean
	cd thWrite; $(MAKE) clean
	cd test; $(MAKE) clean
