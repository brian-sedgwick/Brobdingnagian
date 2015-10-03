#ifndef ASSEMBLER_H
#define ASSEMBLER_H

#include <string>
#include <unordered_map>

class assembler
{
public:
	assembler(std::string){}
	void start();
private:
	std::unordered_map<std::string, int> symbolTable;	
};

#endif