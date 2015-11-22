#ifndef MEMORYARRAY_H
#define MEMORYARRAY_H

#include <stdexcept>
#include <string>

using namespace std;

class memoryArray
{
private:
	size_t mem_size;
	char* memory;

	bool indexOutOfBounds(size_t memoryLocation)
	{
		if(memoryLocation >= mem_size){ return true; }
		return false;
	}

public:
	memoryArray(size_t size)
	{
		mem_size = size;
		memory = new char[mem_size]{0};
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