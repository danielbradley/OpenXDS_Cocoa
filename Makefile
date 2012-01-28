all: clean quasi build

clean:
	cd libopenxds_cocoa; make clean

quasi:
	cd libopenxds_cocoa; make quasi

build:
	cd libopenxds_cocoa; make build
