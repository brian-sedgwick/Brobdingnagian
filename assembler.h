#ifndef ASSEMBLER_H
#define ASSEMBLER_H

#include <string>
#include <unordered_map>
#include "memoryArray.h"

class assembler
{
public:
	assembler(std::string filename, memoryArray* mem): assemblyFileName(filename)
	{
		memory = mem;
		// Name -> Size
		directivesTable = 
		{
			{ ".INT", 4 },
			{ ".BYT", 1 }
		};

		// Name -> Value
		opCodeTable = 
		{
			{ "TRP", 0 },
			{ "MOV", 7 },
			{ "LDR", 10 },
			{ "ADD", 13 },
			{ "SUB", 15 },
			{ "MUL", 16 },
			{ "DIV", 17 },
		};

		// Register Name -> Register index
		registerTable =
		{
			{ "R0", 0 },
			{ "R1", 1 },
			{ "R2", 2 },
			{ "R3", 3 },
			{ "R4", 4 },
			{ "R5", 5 },
			{ "R6", 6 },
			{ "R7", 7 }
		};
	}
	
	void start();

private:
	int memSize;
	memoryArray* memory;

	std::string assemblyFileName;
	std::unordered_map<std::string, int> symbolTable;
	std::unordered_map<std::string, int> opCodeTable;
	std::unordered_map<std::string, int> directivesTable;	
	std::unordered_map<std::string, int> registerTable;	

	void firstPassAssembler();
	void secondPassAssembler();
	void writeDirectiveToMemory(string token, int value, int memoryLocation);
	void writeOpCodeToMemory(int opCodeValue, int op1Value, int op2Value, int startingLocation);
	int parseOperand(string operand);
	std::string stripComments(std::string);
	std::string trim(std::string);
	bool addSymbolToTable();
};

#endif