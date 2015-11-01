#ifndef MEMORYARRAY_H
#define MEMORYARRAY_H

#include <stdexcept>
#include <string>

using namespace std;

class memoryArray
{
private:
	static const size_t MEM_SIZE = 1000000;
	char* memory;

	bool indexOutOfBounds(size_t memoryLocation)
	{
		if(memoryLocation >= MEM_SIZE){ return true; }
		return false;
	}

public:
	memoryArray()
	{
		memory = new char[MEM_SIZE]{0};
	}
	
	~memoryArray()
	{
		delete memory;
	}
	
	int readInt(size_t location)
	{
		if(indexOutOfBounds(location) || indexOutOfBounds(location + sizeof(int) - 1))
		{
			throw out_of_range("Invalid index to read an int: " + to_string(location));
		}
		return *(reinterpret_cast<int*>(memory + location));
	}

	char readChar(size_t location)
	{
		if(indexOutOfBounds(location))
		{
			throw out_of_range("Invalid index to read a char: " + to_string(location));
		}
		return memory[location];
	}

	void writeInt(size_t location, int data)
	{
		if(indexOutOfBounds(location) || indexOutOfBounds(location + sizeof(int) - 1))
		{
			throw out_of_range("Invalid index to write an int: " + to_string(location));
		}
		reinterpret_cast<int*>(memory + location)[0] = data;
	}

	void writeChar(size_t location, char data)
	{
		if(indexOutOfBounds(location))
		{
			throw out_of_range("Invalid index to write a char: " + to_string(location));
		}
		memory[location] = data;
	}
};
#endif