#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <exception>
#include <climits>

#include "vm.h"

#ifdef BRIAN_DEBUG
	#include "easylogging++.h"
	INITIALIZE_EASYLOGGINGPP
	using namespace el;
#endif

int main(int argc, char** argv)
{
	#ifdef BRIAN_DEBUG
		Configurations conf("logging.conf");
		Loggers::reconfigureAllLoggers(conf);
		Loggers::addFlag(LoggingFlag::ImmediateFlush);
		Loggers::addFlag(LoggingFlag::ColoredTerminalOutput);
		LOG(DEBUG) << "===================================================";
		LOG(DEBUG) << "                    Starting VM                    ";
		LOG(DEBUG) << "===================================================";
		
	#endif
	if(argc != 2)
	{ 
		throw runtime_error("You must specify an assembly file to execute when invoking this program."); 
	}

	vm virtualMachine{string(argv[1])};
	virtualMachine.Run();
	#ifdef __linux__
		cout << endl;
	#endif
}