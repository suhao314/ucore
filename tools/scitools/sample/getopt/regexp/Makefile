#
# Makefile for gnu.regexp for use with GNU make
# Copyright (C) 1998-2001 Wes Biggs
#
# This library is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation; either version 2.1 of the License, or
# (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#

# It's not strictly necessary to use this file -- most of what it does
# you can do by running 'javac gnu/regexp/*.java'.  However, it does allow
# convenient building of the following targets:
#
# make (no args): builds all the gnu.regexp.* classes, and the JAR file
# make install: copies the JAR to your designated INSTALLDIR (see below)
# make applet: builds the demo applet and its JAR
# make utils: builds the gnu.regexp.util.* classes (requires gnu.getopt)
# make javadocs: build the source documentation
# make dist: build the distribution tar.gz file (requires GNU tar)
# make clean: deletes all class files and JARs
#
# You may need to edit some of the paths or compiler defaults below.

# This is the directory where .class files will be placed
LIBDIR = ../lib
LIBDIR32 = ..\lib

# Note that these conditional makefile statements require GNU make
# The special treatment for cygwin32 relies on the OSTYPE environment
# variable. Because the Cygwin tools are still in beta, it's been
# changing. This needs to be "cygwin32" for Beta 19 and higher beta versions,
# "win32" for earlier versions, and just "cygwin" for recent releases.
ifeq ($(OSTYPE),cygwin)
FSEP = \\
PSEP = ;
LIBPATH = $(LIBDIR32)
else
FSEP = /
PSEP = :
LIBPATH = $(LIBDIR)
endif

JAVAFLAGSCLASSPATH = -classpath ".$(PSEP)$(LIBPATH)$(PSEP)${CLASSPATH}"
GNUREGEXPPATH = gnu${FSEP}regexp${FSEP}
GNUREGEXPUTILPATH = ${GNUREGEXPPATH}util${FSEP}

# Change JAVAC variable to your java compiler.
# Change JAVAFLAGS variable to any java flags you want to compile with.

JAVAC = jikes
JAVAFLAGS = -O

#JAVAC = javac
#JAVAFLAGS = -O

JAVACOMPILE = $(JAVAC) -d "$(LIBPATH)" $(JAVAFLAGSCLASSPATH) $(JAVAFLAGS)

# This is the directory the gnu.regexp JAR file will be installed in when
# you do a 'make install'
INSTALLDIR = /usr/local/java/lib

# This is where the applet JAR goes
DOCSDIR = ../docs
# This is where the generated javadocs will go when you do a 'make javadocs'
APIDOCSDIR = ../docs/api

GNUREGEXPVERSION = 1.1.4

GNUREGEXPCORECLASSES = \
	$(LIBDIR)/gnu/regexp/RESyntax.class \
	$(LIBDIR)/gnu/regexp/CharIndexed.class \
	$(LIBDIR)/gnu/regexp/REMatch.class \
	$(LIBDIR)/gnu/regexp/REToken.class \
	$(LIBDIR)/gnu/regexp/REException.class \
	$(LIBDIR)/gnu/regexp/RETokenChar.class \
	$(LIBDIR)/gnu/regexp/RETokenRange.class \
	$(LIBDIR)/gnu/regexp/RETokenPOSIX.class \
	$(LIBDIR)/gnu/regexp/RETokenOneOf.class \
	$(LIBDIR)/gnu/regexp/RETokenAny.class \
	$(LIBDIR)/gnu/regexp/RETokenEndSub.class \
	$(LIBDIR)/gnu/regexp/RETokenWordBoundary.class \
	$(LIBDIR)/gnu/regexp/RETokenRepeated.class \
	$(LIBDIR)/gnu/regexp/RETokenBackRef.class \
	$(LIBDIR)/gnu/regexp/RETokenLookAhead.class \
	$(LIBDIR)/gnu/regexp/CharIndexedString.class \
	$(LIBDIR)/gnu/regexp/CharIndexedCharArray.class \
	$(LIBDIR)/gnu/regexp/CharIndexedStringBuffer.class \
	$(LIBDIR)/gnu/regexp/CharIndexedInputStream.class \
	$(LIBDIR)/gnu/regexp/CharIndexedReader.class \
	$(LIBDIR)/gnu/regexp/IntPair.class \
	$(LIBDIR)/gnu/regexp/CharUnit.class \
	$(LIBDIR)/gnu/regexp/RE.class \
	$(LIBDIR)/gnu/regexp/UncheckedRE.class \
	$(LIBDIR)/gnu/regexp/RETokenStart.class \
	$(LIBDIR)/gnu/regexp/RETokenEnd.class \
	$(LIBDIR)/gnu/regexp/REMatchEnumeration.class \
	$(LIBDIR)/gnu/regexp/MessagesBundle.properties

GNUREGEXPCLASSES = ${GNUREGEXPCORECLASSES} \
	$(LIBDIR)/gnu/regexp/REFilterInputStream.class \
	$(LIBDIR)/gnu/regexp/REFilterReader.class

GNUREGEXPUTILCLASSES = \
	$(LIBDIR)/gnu/regexp/util/Grep.class \
	$(LIBDIR)/gnu/regexp/util/Egrep.class \
	$(LIBDIR)/gnu/regexp/util/Tests.class \
	$(LIBDIR)/gnu/regexp/util/RETest.class

GNUREGEXPAPPLETCLASSES = ${GNUREGEXPCORECLASSES} \
	$(LIBDIR)/gnu/regexp/util/REApplet.class

gnu.regexp: $(GNUREGEXPCLASSES) $(LIBDIR)/gnu-regexp-${GNUREGEXPVERSION}.jar

all: gnu.regexp applet utils

applet: $(DOCSDIR)/gnu-regexp-applet.jar


install: $(LIBDIR)/gnu-regexp-${GNUREGEXPVERSION}.jar
	cp -f $(LIBDIR)/gnu-regexp-${GNUREGEXPVERSION}.jar ${INSTALLDIR}

utils: ${GNUREGEXPUTILCLASSES}

clean:
	rm -f ${GNUREGEXPCLASSES} ${GNUREGEXPUTILCLASSES} ${GNUREGEXPAPPLETCLASSES}
	rm -f $(LIBDIR)/gnu-regexp-${GNUREGEXPVERSION}.jar
	rm -f $(DOCSDIR)/gnu-regexp-applet.jar

GNUREGEXPDIR = gnu.regexp-${GNUREGEXPVERSION}

# This constitutes the official distribution
dist: $(LIBDIR)/gnu-regexp-${GNUREGEXPVERSION}.jar
	rm -f ../.CONTENTS
	sed 's/^/$(GNUREGEXPDIR)\//' < ../CONTENTS > ../.CONTENTS
	cd ../..; tar cvzf $(GNUREGEXPDIR).tar.gz -T $(GNUREGEXPDIR)/.CONTENTS

javadocs:
	mkdir -p ${APIDOCSDIR}
	javadoc -d ${APIDOCSDIR} -author -version -public gnu.regexp gnu.regexp.util

$(LIBDIR)/gnu-regexp-${GNUREGEXPVERSION}.jar: ${GNUREGEXPCLASSES}
	cd $(LIBDIR); jar cvf gnu-regexp-${GNUREGEXPVERSION}.jar gnu/regexp/*.class gnu/regexp/*.properties

$(DOCSDIR)/gnu-regexp-applet.jar: ${GNUREGEXPCLASSES} $(LIBDIR)/gnu/regexp/util/REApplet.class
	cd $(LIBDIR); jar cvf gnu-regexp-applet.jar gnu/regexp/*.class gnu/regexp/*.properties gnu/regexp/util/REApplet.class; mv gnu-regexp-applet.jar $(DOCSDIR)

# Special rules for gnu.regexp.IntPair and gnu.regexp.CharUnit inner classes
#
$(LIBDIR)/gnu/regexp/IntPair.class $(LIBDIR)/gnu/regexp/CharUnit.class $(LIBDIR)/gnu/regexp/RE.class : gnu/regexp/RE.java

# Common rule for compiling a java file
$(LIBDIR)/gnu/regexp/%.class: gnu/regexp/%.java
	$(JAVACOMPILE) $<

# Properties files just get copied
$(LIBDIR)/gnu/regexp/%.properties: gnu/regexp/%.properties
	cp $< $@
