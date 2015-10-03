#include <iostream>
#include <string>
#include "vm.h"

using namespace std;

void vm::Run()
{
		std::cout << "vm.Run()" << endl;
		twoPassAssembler.start();
}