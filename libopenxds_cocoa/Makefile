
all: clean quasi build

clean:
	rm -rf bin
	rm -rf dep
	rm -rf lib
	rm -rf obj
	rm -rf documentation
	rm -rf include
	rm -rf source/include
	rm -rf source/objective-c++

quasi:
	quasi -f . source/mtx/*mtx*

build:
	CFLAGS="" LDFLAGS="-framework Cocoa" build --force

maxtext:
#	mkdir -p documentation/html/images
#	max2html --out documentation/html/codeflow source/mtx/*.txt
#	cp source/figures/ClassElement.png documentation/html/images
#	cp source/figures/3rddimension.png documentation/html/images
#	cp source/figures/model.png documentation/html/images
#	cp source/figures/main.png documentation/html/images
