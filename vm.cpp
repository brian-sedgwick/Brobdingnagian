#include <iostream>
#include <string>
#include "vm.h"

using namespace std;

void vm::Run()
{
	codeBlockLocation = twoPassAssembler.start();
	setupEnvironment();
	while(!EndOfProgram)
	{
		fetch();
		decodeAndExecute();
	}
}

void vm::setupEnvironment()
{
	if(codeBlockLocation == -1)
	{
		throw runtime_error("There was apparently no executable code in the assembly file!");
	}
	reg[Register::PC] = codeBlockLocation;
}

void vm::fetch()
{
	#ifdef DEBUG
		cout << "Fetching Instruction from location: " 
			<< reg[Register::PC] << "," 
			<< reg[Register::PC] + assembler::OPERAND_SIZE << ","
			<< reg[Register::PC] + (assembler::OPERAND_SIZE * 2) << endl;
	#endif

	IR.opCode = memory.readInt(reg[Register::PC]);
	IR.op1 = memory.readInt(reg[Register::PC] + assembler::OPERAND_SIZE);
	IR.op2 = memory.readInt(reg[Register::PC] + (assembler::OPERAND_SIZE * 2));
	reg[Register::PC] += assembler::INSTRUCTION_SIZE;
}

void vm::decodeAndExecute()
{
	#ifdef DEBUG
		cout << "Decode and execute: " 
			<< IR.opCode << " " 
			<< IR.op1 << " " 
			<< IR.op2 << endl;
	#endif

	switch( IR.opCode )
	{
		case opCode::TRP :
		{
			switch( IR.op1 )
			{
				case 0:
				{
					EndOfProgram = true;
					return;
				}
				case 1:
				{
					cout << reg[Register::R3];
					break;
				}
				case 2:
				{
					// Implement later.
					break;
				}
				case 3:
				{
					cout << char(reg[Register::R3]);
					break;
				}
				case 4:
				{
					// Implement later.
					break;
				}
				case 10:
				{
					// Implement later.
					break;
				}
				case 11:
				{
					// Implement later.
					break;
				}
			#ifdef DEBUG
				case 99:
				{
					cout << "DEBUG: Registers->{ " 
						 << reg[Register::R0] << "," 
						 << reg[Register::R1] << "," 
						 << reg[Register::R2] << "," 
						 << reg[Register::R3] << "," 
						 << reg[Register::R4] << "," 
						 << reg[Register::R5] << "," 
						 << reg[Register::R6] << "," 
						 << reg[Register::R7] << " } "
						 << "PC->{ " << reg[Register::PC] << " }" << endl; 
					break;
				}
			#endif
				default:
				{
					throw runtime_error("Unknown TRP signal: " + to_string(IR.op1));
				}
			}
			break;
		}

		case opCode::JMP :
		{
			reg[Register::PC] = IR.op1;
			break;
		}

		case opCode::JMR :
		{
			reg[Register::PC] = reg[IR.op1];
			break;
		}

		case opCode::BNZ :
		{
			if(reg[IR.op1] != 0)
			{
				reg[Register::PC] = IR.op2;
			}
			break;
		}

		case opCode::BGT :
		{
			if(reg[IR.op1] > 0)
			{
				reg[Register::PC] = IR.op2;
			}
			break;
		}

		case opCode::BLT :
		{
			if(reg[IR.op1] < 0)
			{
				reg[Register::PC] = IR.op2;
			}
			break;
		}

		case opCode::BRZ :
		{
			if(reg[IR.op1] == 0)
			{
				reg[Register::PC] = IR.op2;
			}
			break;
		}

		case opCode::MOV :
		{
			reg[IR.op1] = reg[IR.op2];
			break;
		}

		case opCode::LDA :
		{
			if(IR.op2 >= codeBlockLocation)
			{
				throw runtime_error("Cannot load the address of code using LDA!");
			}
			reg[IR.op1] = IR.op2;
			break;
		}

		case opCode::STR :
		{
			if( twoPassAssembler.symbolTypeTable[IR.op2] == ".INT" )
			{
				memory.writeInt(IR.op2, reg[IR.op1]);
			}
			else if( twoPassAssembler.symbolTypeTable[IR.op2] == ".BYT" )
			{
				memory.writeChar(IR.op2, reg[IR.op1]);
			}
			else
			{
				throw runtime_error("Unexpected directive on decode: " + twoPassAssembler.symbolTypeTable[IR.op2] );
			}
			break;
		}

		case opCode::LDR :
		{
			if( twoPassAssembler.symbolTypeTable[IR.op2] == ".INT" )
			{
				reg[IR.op1] = memory.readInt(IR.op2);
			}
			else if( twoPassAssembler.symbolTypeTable[IR.op2] == ".BYT" )
			{
				reg[IR.op1] = memory.readChar(IR.op2);
			}
			else
			{
				throw runtime_error("Unexpected directive on decode: " + twoPassAssembler.symbolTypeTable[IR.op2] );
			}
			break;
		}

		case opCode::STB :
		{
			memory.writeChar(IR.op2, reg[IR.op1]);
			break;
		}

		case opCode::LDB :
		{
			reg[IR.op1] = memory.readChar(IR.op2);
			break;
		}

		case opCode::ADD :
		{
			reg[IR.op1] += reg[IR.op2];
			break;
		}

		case opCode::ADI :
		{
			reg[IR.op1] += IR.op2;
			break;
		}

		case opCode::SUB :
		{
			reg[IR.op1] -= reg[IR.op2];
			break;
		}

		case opCode::MUL :
		{
			reg[IR.op1] *= reg[IR.op2];
			break;
		}

		case opCode::DIV :
		{
			reg[IR.op1] /= reg[IR.op2];
			break;
		}

		case opCode::AND :
		{
			reg[IR.op1] = reg[IR.op1] && reg[IR.op2];
			break;
		}

		case opCode::OR :
		{
			reg[IR.op1] = reg[IR.op1] || reg[IR.op2];
			break;
		}

		case opCode::CMP :
		{
			if(reg[IR.op1] == reg[IR.op2]){ reg[IR.op1] = 0; }
			if(reg[IR.op1] > reg[IR.op2]){ reg[IR.op1] = 1; }
			if(reg[IR.op1] < reg[IR.op2]){ reg[IR.op1] = -1; }
			break;
		}

		default:
		{
			throw runtime_error("Unexpected opCode: " + to_string(IR.opCode));
		}
	}
}
