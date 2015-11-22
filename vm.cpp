#include <iostream>
#include <string>
#include "vm.h"

using namespace std;

void vm::Run()
{
	twoPassAssembler.start(codeBlockLocation, codeBlockEndLocation);
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
	reg[Register::SL] = codeBlockEndLocation;
	reg[Register::SB] = reg[Register::SP] = reg[Register::FP] = MEMORY_SIZE - 4;

}

void vm::fetch()
{
	IR.opCode = memory.readInt(reg[Register::PC]);
	IR.op1 = memory.readInt(reg[Register::PC] + assembler::OPERAND_SIZE);
	IR.op2 = memory.readInt(reg[Register::PC] + (assembler::OPERAND_SIZE * 2));
	reg[Register::PC] += assembler::INSTRUCTION_SIZE;
}

void vm::decodeAndExecute()
{
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
					int input;
					cin >> input;
					reg[Register::R3] = input;
					break;
				}
				case 3:
				{
					cout << char(reg[Register::R3]);
					break;
				}
				case 4:
				{
					reg[Register::R3] = getchar();
					break;
				}
				case 10:
				{
					if(char(reg[Register::R3]) < '0' || char(reg[Register::R3]) > '9')
					{
						reg[Register::R3] = -1;
					}
					else
					{
						reg[Register::R3] = int(char(reg[Register::R3]));
					}
					break;
				}
				case 11:
				{
					if(reg[Register::R3] < 0 || reg[Register::R3] > 9)
					{
						reg[Register::R3] = -1;
					}
					else
					{
						reg[Register::R3] = char(reg[Register::R3]);
					}
					
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
						 << "PC->{ " << reg[Register::PC] << " } "
						 << "SL->{ " << reg[Register::SL] << " } "
						 << "SP->{ " << reg[Register::SP] << " } "
						 << "FP->{ " << reg[Register::FP] << " } "
						 << "SB->{ " << reg[Register::SB] << " } " << endl;
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
			if(reg[Register::R3] != 0)
			{
				reg[Register::PC] = IR.op1;
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

		case opCode::STRI:
		{
			memory.writeInt(reg[IR.op2], reg[IR.op1]);
			break;
		}

		case opCode::STR :
		{
			memory.writeInt(IR.op2, reg[IR.op1]);
			break;
		}

		case opCode::LDRI:
		{
			reg[IR.op1] = memory.readInt(reg[IR.op2]);
			break;
		}

		case opCode::LDR :
		{
			reg[IR.op1] = memory.readInt(IR.op2);
			break;
		}

		case opCode::STBI:
		{
			memory.writeChar(reg[IR.op2], reg[IR.op1]);
			break;
		}

		case opCode::STB :
		{
			memory.writeChar(IR.op2, reg[IR.op1]);
			break;
		}

		case opCode::LDBI:
		{
			reg[IR.op1] = memory.readChar(reg[IR.op2]);
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
			else if(reg[IR.op1] > reg[IR.op2]){ reg[IR.op1] = 1; }
			else if(reg[IR.op1] < reg[IR.op2]){ reg[IR.op1] = -1; }
			break;
		}

		default:
		{
			throw runtime_error("Unexpected opCode: " + to_string(IR.opCode));
		}
	}
}
