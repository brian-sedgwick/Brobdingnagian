#ifndef VM_H
#define VM_H

#include <string>
#include <iostream>
#include "assembler.h"
#include "memoryArray.h"


struct Instruction
{
	int opCode;
	int op1;
	int op2;
};

class vm
{
public:
	enum Register { R0=0, R1=1, R2=2, R3=3, R4=4, R5=5, R6=6, R7=7, PC=8 };
	enum opCode { TRP=0, MOV=7, LDR=10, ADD=13, SUB=15, MUL=16, DIV=17 };

	vm(std::string filename) :
		EndOfProgram(false), 
		filename(filename), 
		twoPassAssembler(filename, &memory)		
	{}
	void Run();
private:

	bool EndOfProgram;
	Instruction IR;
	int codeBlockLocation;
	int reg[9];
	std::string filename;
	memoryArray memory;
	assembler twoPassAssembler;

	void setupEnvironment();
	void fetch();
	void decodeAndExecute();
};

#endif