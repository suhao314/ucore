LIBS = -Pcommon

build:
	ghdl -m $(LIBS) $(TARGET)

scan: common/scan work/scan

%/scan:
	ghdl -i --work=$* --workdir=$* $(LIBS) $*/*.vhdl

work/scan:
	ghdl -i --mb-comments $(LIBS) *.vhdl

%/clean:
	ghdl --clean --work=$* --workdir=$*

work/clean:
	ghdl --clean

clean: common/clean work/clean
	rm -f *~ #*#
