#ifndef ASSEMBLER_H
#define ASSEMBLER_H

#include <string>
#include <unordered_map>
#include "memoryArray.h"

class assembler
{
public:
	const static int INSTRUCTION_SIZE = 3 * sizeof(int);
	const static int OPERAND_SIZE = sizeof(int);

	std::unordered_map<std::string, int> opCodeTable;
	std::unordered_map<std::string, int> directivesTable;	
	std::unordered_map<std::string, int> registerTable;	
	std::unordered_map<int, std::string> symbolTypeTable;
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
			{ "JMP", 1 },
			{ "JMR", 2 },
			{ "BNZ", 3 },
			{ "BGT", 4 },
			{ "BLT", 5 },
			{ "BRZ", 6 },
			{ "MOV", 7 },
			{ "LDA", 8 },
			{ "STR", 9 },
			{ "LDR", 10 },
			{ "STB", 11 },
			{ "LDB", 12 },
			{ "ADD", 13 },
			{ "ADI", 14 },
			{ "SUB", 15 },
			{ "MUL", 16 },
			{ "DIV", 17 },
			{ "AND", 18 },
			{ "OR",  19 },
			{ "CMP", 20 },
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
	
	int start();

private:
	int codeBlockBeginning = -1;
	memoryArray* memory;

	std::string assemblyFileName;
	std::unordered_map<std::string, int> symbolTable;
	
	void firstPassAssembler();
	void secondPassAssembler();
	void writeDirectiveToMemory(string token, int value, int memoryLocation);
	void writeOpCodeToMemory(int opCodeValue, int op1Value, int op2Value, int startingLocation);
	int parseOperand(string operand);
	std::string stripComments(std::string);
	std::string trim(std::string);
};

#endif