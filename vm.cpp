#include <iostream>
#include <string>
#include "vm.h"

using namespace std;

void vm::Run()
{
		cout << "vm.Run() : filename -> " << filename << endl;
		twoPassAssembler.start();
}