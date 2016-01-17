all:
	cd src; make
	mkdir -p build
	cd lectures; make

clean:
	cd src; make clean
	cd lectures; make clean
	rm -rf build





