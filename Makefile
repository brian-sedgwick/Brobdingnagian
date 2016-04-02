all: vm.exe

vm.exe: Makefile vm.cpp vm.h vm.cpp memoryArray.h assembler.h assembler.cpp
	mingw32-g++ -static -std=c++1y -Wall -o vm.exe main.cpp vm.cpp assembler.cpp