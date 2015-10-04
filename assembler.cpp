#include <iostream>
#include <exception>
#include <fstream>
#include "assembler.h"
using namespace std;


void assembler::start()
{
	cout << "assembler.start()" << endl;
	processAssemblyFile();
	isFirstPass = false;
	processAssemblyFile();

}

void assembler::processAssemblyFile()
{
	ifstream f(assemblyFileName, ios::in);
	string input;

	while(getline(f, input))
	{
		if(input == ""){ continue; } // Skip blank lines.
		input = stripComments(input); // Remove comments.
		if(input == ""){ continue; } // Skip lines that only had comments.
		input = trim(input); // Remove leading and trailing white space.
		if(input == ""){ continue; } // Skip blank lines.

		stringstream ss(input);
		string token;
		while(ss >> token)
		{
			// First Pass Assembler
			if(isFirstPass)
			{
				if(directivesTable.find(token) != directives.end())
				{
					// START HERE NEXT TIME
				}
			}

			// Second Pass Assembler
			else
			{
			}
		}
	}
}

string assembler::stripComments(string input)
{
	return input.substr(0, input.find_first_of(';'));
}

string assembler::trim(string input)
{
	return input.substr(input.find_first_not_of(" \t\n"), input.find_last_not_of(" \t\n") + 1);
}