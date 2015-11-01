#ifndef VM_H
#define VM_H

#include <string>
#include <iostream>
#include "assembler.h"
#include "memoryArray.h"


enum AddressingMode { DIRECT=0, INDIRECT=1 };
struct Instruction
{
	int opCode;
	int op1;
	int op2;
	AddressingMode mode;

	Instruction()
	{
		opCode = 0;
		op1 = 0;
		op2 = 0;
	}
};

class vm
{
public:
	enum Register { R0=0, R1=1, R2=2, R3=3, R4=4, R5=5, R6=6, R7=7, PC=8 };
	enum opCode { 
		TRP=0,
		JMP=1,
		JMR=2,
		BNZ=3,
		BGT=4,
		BLT=5,
		BRZ=6,
		MOV=7,
		LDA=8,
		STR=9,
		LDR=10,
		STB=11,
		LDB=12,
		ADD=13,
		ADI=14,
		SUB=15,
		MUL=16,
		DIV=17,
		AND=18,
		OR=19,
		CMP=20,
		STRI=21,
		LDRI=22,
		STBI=23,
		LDBI=24
	};

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
	int reg[9]{0};
	std::string filename;
	memoryArray memory;
	assembler twoPassAssembler;

	void setupEnvironment();
	void fetch();
	void decodeAndExecute();
};

#endif