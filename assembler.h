#ifndef ASSEMBLER_H
#define ASSEMBLER_H

#include <string>
#include <unordered_map>

class assembler
{
public:
	assembler(std::string filename): isFirstPass(true), assemblyFileName(filename)
	{
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
	}
	
	void start();

private:
	bool isFirstPass;
	std::string assemblyFileName;
	std::unordered_map<std::string, int> symbolTable;
	std::unordered_map<std::string, int> opCodeTable;
	std::unordered_map<std::string, int> directivesTable;	

	void processAssemblyFile();

	std::string stripComments(std::string);

	std::string trim(std::string);
	
	// Return: True if the new label was added.  False if the new label is a duplicate.
	bool addSymbolToTable();
};

#endif