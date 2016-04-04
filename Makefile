all: vm.exe vm-debug.exe

vm.exe: Makefile vm.cpp vm.h vm.cpp memoryArray.h assembler.h assembler.cpp
	mingw32-g++ -static -std=c++1y -Wall -o vm.exe main.cpp vm.cpp assembler.cpp

vm-debug.exe: Makefile vm.cpp vm.h vm.cpp memoryArray.h assembler.h assembler.cpp
	mingw32-g++ -static -DBRIAN_DEBUG -std=c++1y -Wall -o vm-debug.exe main.cpp vm.cpp assembler.cpp