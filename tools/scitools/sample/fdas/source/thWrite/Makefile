# Makefile for getData f90 thWrite directory.
# Version for NAG f90 compiler.
# Richard Maine.  12 Jul 92.
#

LIBRARY = libthWrite.a
LIBDIR = ../../lib
MODDIR = ../../mod

FFLAGS = -O

OBJS = thWAsc12.o thWLis1.o thWUnc2.o thWUnc3.o thWCmp3.o \
       thWrite.o

MODS = th_write.mod

SRCS = thWAsc12.f90 thWLis1.f90 thWUnc2.f90 thWUnc3.f90 thWCmp3.f90 \
       thWrite.f90

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

###
