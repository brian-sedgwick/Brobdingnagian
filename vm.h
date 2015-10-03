#ifndef VM_H
#define VM_H

#include <string>
#include <iostream>
#include "assembler.h"

class vm
{
public:
	vm(std::string filename) : filename(filename), twoPassAssembler(filename) {}

	void Run();
	
private:
	std::string filename;
	assembler twoPassAssembler;
};

#endif