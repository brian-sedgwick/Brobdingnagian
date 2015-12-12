all: vm vm.exe vm-debug tests proj3

vm: Makefile Brobdingnagian/vm.cpp Brobdingnagian/vm.h Brobdingnagian/vm.cpp Brobdingnagian/memoryArray.h Brobdingnagian/assembler.h Brobdingnagian/assembler.cpp
	clang++ -g -fstandalone-debug -std=c++1y -Wall -o /home/brian/src/cs4380/bin/vm Brobdingnagian/main.cpp Brobdingnagian/vm.cpp Brobdingnagian/assembler.cpp

vm.exe: Makefile Brobdingnagian/vm.cpp Brobdingnagian/vm.h Brobdingnagian/vm.cpp Brobdingnagian/memoryArray.h Brobdingnagian/assembler.h Brobdingnagian/assembler.cpp
	x86_64-w64-mingw32-g++ -static -std=c++1y -Wall -o /home/brian/src/cs4380/bin/vm.exe Brobdingnagian/main.cpp Brobdingnagian/vm.cpp Brobdingnagian/assembler.cpp

vm-debug: Makefile Brobdingnagian/vm.cpp Brobdingnagian/vm.h Brobdingnagian/vm.cpp Brobdingnagian/memoryArray.h Brobdingnagian/assembler.h Brobdingnagian/assembler.cpp
	clang++ -DBRIAN_DEBUG -g -fstandalone-debug -std=c++1y -Wall -o /home/brian/src/cs4380/bin/vm-debug Brobdingnagian/main.cpp Brobdingnagian/vm.cpp Brobdingnagian/assembler.cpp

tests: Makefile tests.cpp
	clang++ -g -fstandalone-debug -std=c++1y -Wall -o /home/brian/src/cs4380/bin/tests tests.cpp

proj3: Makefile proj3.cpp 
	clang++ -o /home/brian/src/cs4380/bin/proj3 proj3.cpp