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
	enum Register { 
		R0=0, 
		R1=1, 
		R2=2, 
		R3=3, 
		R4=4, 
		R5=5, 
		R6=6, 
		R7=7, 
		PC=8, 
		SL=9,
		SP=10,
		FP=11,
		SB=12 
	};

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
		LDBI=24,
		RUN=25,
		END=26,
		BLK=27,
		LCK=28,
		ULK=29
	};

	vm(std::string filename) :
		EndOfProgram(false), 
		filename(filename), 
		twoPassAssembler(filename, &memory)		
	{}

	void Run();

private:
	const size_t MEMORY_SIZE = 10000000;
	const static size_t AVAILABLE_THREADS = 1; // 1 main thread + 4 secondary threads.
	const int THREAD_STACK_OFFSET_PC = 0;
	const int THREAD_STACK_OFFSET_R0 = -4;
	const int THREAD_STACK_OFFSET_R1 = -8;
	const int THREAD_STACK_OFFSET_R2 = -12;
	const int THREAD_STACK_OFFSET_R3 = -16;
	const int THREAD_STACK_OFFSET_R4 = -20;
	const int THREAD_STACK_OFFSET_R5 = -24;
	const int THREAD_STACK_OFFSET_R6 = -28;
	const int THREAD_STACK_OFFSET_R7 = -32;
	const int THREAD_STACK_OFFSET_SP = -36;
	const int THREAD_STACK_OFFSET_FP = -40;
	const int THREAD_STACK_OFFSET_SB = -44;
	const int THREAD_STACK_OFFSET_SL = -48;
	const int THREAD_STACK_OFFSET_FIRST_AVAILABLE_MEM = -52;

	bool activeThreads[AVAILABLE_THREADS]{false};
	size_t threadStackSize;
	size_t currentThreadId;

	bool EndOfProgram;
	Instruction IR;
	int codeBlockLocation;
	int codeBlockEndLocation;
	std::string filename;
	
	memoryArray memory{ MEMORY_SIZE };
	int reg[13]{0};
	
	assembler twoPassAssembler;
	std::unordered_map<std::string, int> symbolTable;
	std::unordered_map<int, std::string> symbolLocationTable;

	void setupEnvironment();
	void fetch();
	void decodeAndExecute();
	void contextSwitch();
	void contextSwitchHelper(size_t thread1Id, size_t thread2Id);
};

#endif