all:
	cd src; make
	cd lectures; make

clean:
	cd src; make clean
	cd lectures; make clean
	cd build; rm -rf *




