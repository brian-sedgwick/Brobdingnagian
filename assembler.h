#ifndef ASSEMBLER_H
#define ASSEMBLER_H

#include <string>
#include <unordered_map>
#include <vector>
#include "memoryArray.h"

class assembler
{
public:
	const static int INSTRUCTION_SIZE = 3 * sizeof(int);
	const static int OPERAND_SIZE = sizeof(int);

	std::unordered_map<std::string, int> opCodeTable;
	std::unordered_map<std::string, int> directivesTable;	
	std::unordered_map<std::string, int> registerTable;
	
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
			{ "STRI", 21 },
			{ "LDRI", 22 },
			{ "STBI", 23 },
			{ "LDBI", 24 },
			{ "RUN", 25 },
			{ "END", 26 },
			{ "BLK", 27 },
			{ "LCK", 28 },
			{ "ULK", 29 },
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
			{ "R7", 7 },
			{ "PC", 8 },
			{ "SL", 9 },
			{ "SP", 10 },
			{ "FP", 11 },
			{ "SB", 12 },
		};
	}
	
	void start(int& codeStart, int& codeEnd, std::unordered_map<std::string, int>& symbolTable, std::unordered_map<int, std::string>& symbolLocationTable);
private:
	int codeBlockBeginning = -1;
	int codeBlockEnding = -1;
	int lineNumber = 0;
	memoryArray* memory;
	std::string assemblyFileName;
	std::unordered_map<std::string, int> symbolTable;
	std::unordered_map<int, std::string> symbolLocationTable;
	std::vector<std::string> opCodesForIndirectAddr;

	void firstPassAssembler();
	void secondPassAssembler();
	void writeDirectiveToMemory(std::string token, int value, int memoryLocation);
	void writeOpCodeToMemory(int opCodeValue, int op1Value, int op2Value, int startingLocation);
	int parseOperand(std::string operand, std::string opcode, bool isSecondOperand, int memoryLocation);
	int convertToASCII(std::string value);
	bool hasIndirectSyntax(std::string line);
	std::string stripComments(std::string);
	std::string trim(std::string);
};

#endif