#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <exception>
#include <climits>

#include "vm.h"


int main(int argc, char** argv)
{
	if(argc != 2)
	{ 
		throw runtime_error("You must specify an assembly file to execute when invoking this program."); 
	}

	vm virtualMachine{string(argv[1])};
	virtualMachine.Run();

	return 0;
}