#include <iostream>
#include <exception>
#include <fstream>
#include <sstream>
#include <regex>
#include <vector>
#include "assembler.h"

#ifdef BRIAN_DEBUG
	#include "easylogging++.h"
#endif

using namespace std;

void assembler::start(int& codeStart, int& codeEnd, std::unordered_map<std::string, int>& symbolT,std::unordered_map<int, std::string>& symbolLT)
{
	firstPassAssembler();
	secondPassAssembler();
	codeStart = codeBlockBeginning;
	codeEnd = codeBlockEnding;
	symbolT = symbolTable;
	symbolLT = symbolLocationTable;
}

void assembler::firstPassAssembler()
{
	ifstream f(assemblyFileName, ios::in);
	string input;

	lineNumber = 0;
	int memoryLocation = 0;
	while(getline(f, input))
	{
		++lineNumber;
		if(input == ""){ continue; } // Skip blank lines.
		input = stripComments(input); // Remove comments.
		if(input == ""){ continue; } // Skip lines that only had comments.
		input = trim(input); // Remove leading and trailing white space.
		if(input == ""){ continue; } // Skip blank lines.

		stringstream ss(input);
		string token;
		ss >> token;
		
		// The line is an instruction that starts with an op code.
		if(opCodeTable.find(token) != opCodeTable.end())
		{
			memoryLocation += INSTRUCTION_SIZE;
		}
		// The line is a directive with no label.  (Probably an array member)
		else if(directivesTable.find(token) != directivesTable.end())
		{
			memoryLocation += directivesTable[token];
		}
		// The line starts with a label.
		else
		{
			string token2;
			ss >> token2;
			
			// There is a duplicate label.
			if(symbolTable.find(token) != symbolTable.end())
			{
				throw runtime_error("Duplicate label encountered!: " + to_string(lineNumber));
			}
			
			// Add the symbol and then determine how much space it takes in memory.
			symbolTable.insert({token, memoryLocation});
			symbolLocationTable.insert({memoryLocation, token});

			// The line was a labeled instruction.
			if(opCodeTable.find(token2) != opCodeTable.end())
			{
				memoryLocation += INSTRUCTION_SIZE;
			}
			// The line was a labeled directive.
			else if(directivesTable.find(token2) != directivesTable.end())
			{
				memoryLocation += directivesTable[token2];
			}
			// The line was a labeled opCode with a label as the second argument.
			else
			{
				memoryLocation += INSTRUCTION_SIZE;
			}
		}
	}

	#ifdef BRIAN_DEBUG
		LOG(DEBUG)  << "Symbol Table Contents:";
		for( auto entry : symbolTable)
		{
			LOG(DEBUG)  << entry.first << " " << entry.second;
		}
		LOG(DEBUG) << "END Symbol Table Contents";
	#endif
}

void assembler::secondPassAssembler()
{
	fstream f(assemblyFileName, ios::in);
	string input;

	lineNumber = 0;
	int memoryLocation = 0;

	while(getline(f, input))
	{
		++lineNumber;

		if(input == ""){ continue; } // Skip blank lines.
		input = stripComments(input); // Remove comments.
		if(input == ""){ continue; } // Skip lines that only had comments.
		input = trim(input); // Remove leading and trailing white space.
		if(input == ""){ continue; } // Skip blank lines.

		stringstream ss(input);
		string token;
		ss >> token;

		
		if(symbolTable.find(token) != symbolTable.end())// The token is a label. Discard.
		{ 
			if(!(ss >> token)) { throw runtime_error("Labels must accompany a valid line of code: " + to_string(lineNumber)); }
		}

		if(hasIndirectSyntax(input)) // There were parens found indicating indirect addressing.
		{
			token += "I";
		}

		if(directivesTable.find(token) != directivesTable.end())// The token is a directive.
		{
			#ifdef BRIAN_DEBUG
				LOG(DEBUG) << "Loading line(Mem:" << memoryLocation << "): " << input;
			#endif
		
			string value;
			ss >> value;

			int asciiVal = convertToASCII(value);
			writeDirectiveToMemory(token, asciiVal, memoryLocation);
			memoryLocation += directivesTable[token];
		}
		else if(opCodeTable.find(token) != opCodeTable.end()) // The token is an opCode.
		{
			// Set the location of the Code Block.
			if(codeBlockBeginning == -1)
			{ 
				codeBlockBeginning = memoryLocation;
				#ifdef BRIAN_DEBUG
					LOG(DEBUG) << "Beginning of Code Block: " << codeBlockBeginning;
				#endif
			}
			
			#ifdef BRIAN_DEBUG
				LOG(DEBUG) << "Loading line(Mem:" << memoryLocation << "): " << input;
			#endif
		
			string operand1;
			string operand2;
			int operand1_value;
			int operand2_value;

			if(!(ss >> operand1))
			{
				if(token == "END" || token == "BLK")
				{
					operand1_value = 0;
				}
				else
				{
					throw runtime_error("Insufficient number of operands on line " + to_string(lineNumber));
				}
			}
			else
			{
				operand1_value = parseOperand(operand1, token, false, memoryLocation);
			}

			if(!(ss >> operand2))
			{
				operand2_value = 0;
			}
			else
			{
				operand2_value = parseOperand(operand2, token, true, memoryLocation);
			}
			writeOpCodeToMemory(opCodeTable[token], operand1_value, operand2_value, memoryLocation);
			memoryLocation += INSTRUCTION_SIZE;
		}
		else 
		{ 
			#ifdef BRIAN_DEBUG
				LOG(DEBUG) << "Loading line(Mem:" << memoryLocation << "): " << input;
			#endif
			throw runtime_error("Unexpected token: " + token + " " + to_string(lineNumber)); 
		}
	}
	codeBlockEnding = memoryLocation;
	#ifdef BRIAN_DEBUG
		LOG(DEBUG) << "Ending of Code Block: " << codeBlockEnding;
	#endif
}

void assembler::writeDirectiveToMemory(string directive, int value, int location)
{
	if(directive == ".INT")
	{
		memory->writeInt(location, value);
	}
	else if(directive == ".BYT")
	{
		memory->writeChar(location, char(value));
	}
}

void assembler::writeOpCodeToMemory(int opCodeVal, int op1Val, int op2Val, int startingLocation)
{
	memory->writeInt(startingLocation, opCodeVal);
	startingLocation += OPERAND_SIZE;
	memory->writeInt(startingLocation, op1Val);
	startingLocation += OPERAND_SIZE;
	memory->writeInt(startingLocation, op2Val);
}

int assembler::parseOperand(string operand, string opcode, bool isSecondOperand, int startingLocation)
{
	string pattern("[:space:]*\\(([:space:]*(R[0-7]|SP|FP|SL|SB)[:space:]*)\\)[:space:]*");
	regex r(pattern);
	smatch results;
	if(regex_search(operand, results, r))
	{
		if(!isSecondOperand)
		{
			throw runtime_error("Register Indirect Addressing is not allowed on the first operand!: " + to_string(lineNumber));
		}
		return registerTable[results[1]];
	}
	if(registerTable.find(operand) != registerTable.end())
	{
		return registerTable[operand];
	}
	if(symbolTable.find(operand) != symbolTable.end())
	{
		return symbolTable[operand];
	}
	return stoi(operand);
}

string assembler::stripComments(string input)
{	
	return input.substr(0, input.find_first_of(';'));
}

string assembler::trim(string input)
{
	string pattern("^\\s*(.*)\\s*$");
	regex r(pattern);
	smatch results;
	if(regex_search(input, results, r))
	{
		return results[1];
	}
	return "";
}

int assembler::convertToASCII(string value)
{
	string pattern = "^'(.*)'$";
	regex r(pattern);
	smatch results;

	int resultValue = -1;
	if(value == "'\\n'")
	{
		resultValue = 10;
	}
	else if(value == "'\\s'"){
		resultValue = 32;
	}
	else if(value == "'")
	{
		resultValue = 32;
	}
	else if(regex_search(value, results, r)) // The value is a single-quoted ascii character.
	{
		resultValue = static_cast<int>(results[1].str()[0]);
	}
	else // Assume the value is simply an ascii code.
	{
		stringstream ss(value);
		ss >> resultValue;
	}

	return resultValue;
}

bool assembler::hasIndirectSyntax(std::string line)
{
	string pattern("^[^()]*\\([^()]+\\)[^()]*$"); // Matches exactly one '(' and one ')' in a line.
	regex r(pattern);
	smatch result;
	if(regex_search(line, result, r))
	{
		return true;
	}
	return false;
}