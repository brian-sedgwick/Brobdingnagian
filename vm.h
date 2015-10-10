#ifndef VM_H
#define VM_H

#include <string>
#include <iostream>
#include "assembler.h"
#include "memoryArray.h"

class vm
{
public:
	vm(std::string filename) : filename(filename), twoPassAssembler(filename, &memory) {}
	void Run();
private:
	std::string filename;
	memoryArray memory;
	assembler twoPassAssembler;
};

#endif