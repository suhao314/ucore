# Makefile for getData f90 gdRead directory.
# Version for NAG f90 compiler.
# Richard Maine.  12 Jul 92.
#

LIBRARY = libgdRead.a
LIBDIR = ../../lib
MODDIR = ../../mod

FFLAGS = -O

OBJS = gdCommon.o linkCalc.o gdCalc.o \
       sampleFilt.o sampleCalc.o dumCalc.o \
       linkFilt.o gdFilt.o gdFile.o gdRead.o

MODS = gd_read.mod gd_common.mod

SRCS = gdCommon.f90 linkFilt.f90 gdFilt.f90 \
       sampleFilt.f90 sampleCalc.o dumCalc.o \
       linkCalc.f90 gdCalc.f90 gdFile.o gdRead.f90

.SUFFIXES:
.SUFFIXES: .f90 $(SUFFIXES)

.f90.o:
	f90 $(FFLAGS) -I$(MODDIR) -c $<

.PHONY: all clean

all:    $(LIBRARY)

install: all $(LIBDIR)/$(LIBRARY)

$(LIBDIR)/$(LIBRARY): $(LIBRARY)
	cp *.mod $(MODDIR)
	cp $(LIBRARY) $(LIBDIR)
	-ranlib $(LIBDIR)/$(LIBRARY)

$(LIBRARY): $(OBJS)
	ar rv $@ $?
	-ranlib $(LIBRARY)

clean:; rm -f $(LIBRARY) $(OBJS) *.mod

# Dependencies.
# We don't yet have a tool to make these automatically for f90.
# The use statements really imply dependencies on .o instead of .mod files,
# but maintaining that distinction would add complications.
linkFilt.o: sampleFilt.o
gdFilt.o: gdCommon.o linkFilt.o
linkCalc.o: sampleCalc.o dumCalc.o
gdCalc.o: gdCommon.o linkCalc.o
gdFile.o: gdCommon.o
gdRead.o: gdCommon.o gdFilt.o gdCalc.o gdFile.o
###
