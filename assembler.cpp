#include <iostream>
#include <exception>
#include <fstream>
#include <sstream>
#include "assembler.h"
using namespace std;


int assembler::start()
{
	firstPassAssembler();
	secondPassAssembler();
	return codeBlockBeginning;
}

void assembler::firstPassAssembler()
{
	ifstream f(assemblyFileName, ios::in);
	string input;

	int lineNumber = 0;
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
			// The line was a syntax error.
			else
			{
				throw runtime_error("Expected a directive or op code after label on line " + to_string(lineNumber));
			}
		}
	}

	#ifdef DEBUG
		cout << "Symbol Table Contents:" << endl;
		for( auto entry : symbolTable)
		{
			cout << entry.first << " " << entry.second << "\n";
		}
		cout << "END Symbol Table Contents" << endl;
	#endif
}

void assembler::secondPassAssembler()
{
	fstream f(assemblyFileName, ios::in);
	string input;

	int lineNumber = 0;
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

		#ifdef DEBUG
			cout << "Loading line: " << input << endl;
		#endif
		
		if(symbolTable.find(token) != symbolTable.end())// The token is a label. Discard.
		{ 
			if(!(ss >> token)) { throw runtime_error(""); }
		} 
		if(directivesTable.find(token) != directivesTable.end())// The token is a directive.
		{
			int value;
			ss >> value;
			writeDirectiveToMemory(token, value, memoryLocation);
			memoryLocation += directivesTable[token];
		}
		else if(opCodeTable.find(token) != opCodeTable.end()) // The token is a directive.
		{
			// Set the location of the Code Block.
			if(codeBlockBeginning == -1)
			{ 
				codeBlockBeginning = memoryLocation;
				#ifdef DEBUG
					cout << "Beginning of Code Block: " << codeBlockBeginning << endl;
				#endif
			}
			string operand1;
			string operand2;
			int operand1_value;
			int operand2_value;

			if(!(ss >> operand1))
			{ 
				throw runtime_error("Insufficient number of operands on line " + to_string(lineNumber));
			}
			else
			{
				operand1_value = parseOperand(operand1);
			}

			if(!(ss >> operand2))
			{
				operand2_value = 0;
			}
			else
			{
				operand2_value = parseOperand(operand2);
			}
			writeOpCodeToMemory(opCodeTable[token], operand1_value, operand2_value, memoryLocation);
			memoryLocation += INSTRUCTION_SIZE;
		}
		else { throw runtime_error("Unexpected token: " + token); }
	}
}

void assembler::writeDirectiveToMemory(string directive, int value, int location)
{
	symbolTypeTable.insert({location, directive});
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

int assembler::parseOperand(string operand)
{
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
	return input.substr(input.find_first_not_of(" \t\n"), input.find_last_not_of(" \t\n") + 1);
}