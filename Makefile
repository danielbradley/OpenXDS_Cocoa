all: clean quasi build

clean:
	cd libopenxds_cocoa; make clean

quasi:
	cd liboepnxds_cocoa; make quasi

build:
	cd liboepnxds_cocoa; make build
