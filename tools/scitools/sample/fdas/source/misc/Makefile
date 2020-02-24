# Makefile for getData f90 misc directory.
# Version for NAG f90 compiler.
# Richard Maine.  12 Jul 92.
#

LIBRARY = libmisc.a
LIBDIR = ../../lib
MODDIR = ../../mod

FFLAGS = -O

OBJS = precision.o sysdepIo.o error.o binary.o string.o time.o \
       gdTree.o gdList.o readCmd.o client.o

LIBOBJS = sysdepIo.o error.o binary.o string.o time.o \
       gdTree.o gdList.o readCmd.o client.o

SRCS = precision.f90 sysdepIo.f90 error.f90 binary.f90 string.f90 time.f90 \
       gdTree.f90 gdList.f90 readCmd.f90 client.f90

.SUFFIXES:
.SUFFIXES: .f90 $(SUFFIXES)

.f90.o:
	f90 $(FFLAGS) -c $<

.PHONY: all clean

all:    $(OBJS) $(LIBRARY)

install: all $(LIBDIR)/$(LIBRARY)

$(LIBDIR)/$(LIBRARY): $(LIBRARY)
	cp *.mod $(MODDIR)
	cp $(LIBRARY) $(LIBDIR)
	-ranlib $(LIBDIR)/$(LIBRARY)

$(LIBRARY): $(LIBOBJS)
	ar rv $@ $?
	-ranlib $(LIBRARY)

clean:; rm -f $(LIBRARY) $(OBJS) *.mod

# Dependencies.
# We don't yet have a tool to make these automatically for f90.
# The use statements really imply dependencies on .o instead of .mod files,
# but maintaining that distinction would add complications.
binary.o: precision.o
error.o: sysdepIo.o
string.o: precision.o sysdepIo.o
time.o: precision.o
client.o: binary.o sysdepIo.o
gdTree.o: string.o
readCmd.o: sysdepIo.o
###
