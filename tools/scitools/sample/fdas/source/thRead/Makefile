# Makefile for getData f90 thRead directory.
# Version for NAG f90 compiler.
# Richard Maine.  12 Jul 92.
#

LIBRARY = libthRead.a
LIBDIR = ../../lib
MODDIR = ../../mod

FFLAGS = -O

OBJS = thRGen.o thRAsc12.o thRUnc2.o thRUnc3.o thRCmp3.o thRNet1.o thRead.o

MODS = th_read.mod

SRCS = thRGen.f90 thRAsc12.f90 thRUnc2.f90 thRUnc3.f90 thRCmp3.f90 \
       thRNet1.f90 thRead.f90

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
