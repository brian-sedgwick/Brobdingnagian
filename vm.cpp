#include <iostream>
#include <string>
#include <cassert>
#include "vm.h"

#ifdef BRIAN_DEBUG
	#include "easylogging++.h"
#endif

using namespace std;

void vm::Run()
{
	twoPassAssembler.start(codeBlockLocation, codeBlockEndLocation, symbolTable, symbolLocationTable);
	setupEnvironment();
	while(!EndOfProgram)
	{
		fetch();
		decodeAndExecute();
		contextSwitch();
	}
	cout << endl;
}

void vm::setupEnvironment()
{
	if(codeBlockLocation == -1)
	{
		throw runtime_error("There was apparently no executable code in the assembly file!");
	}
	
	threadStackSize = (MEMORY_SIZE - codeBlockEndLocation) / AVAILABLE_THREADS;

	// Use integer division to ensure that the calculated size of the thread stack
	// is multiple of 4 since each block is 4 bytes and we don't want a partial block.
	threadStackSize /= 4;
	threadStackSize *= 4;

	size_t stackBase = MEMORY_SIZE - 4;
	reg[Register::SP] = stackBase + THREAD_STACK_OFFSET_FIRST_AVAILABLE_MEM; // SP
	reg[Register::FP] = stackBase + THREAD_STACK_OFFSET_FIRST_AVAILABLE_MEM; // FP
	reg[Register::SB] = stackBase + THREAD_STACK_OFFSET_FIRST_AVAILABLE_MEM; // SB
	reg[Register::SL] = stackBase - threadStackSize + 4; // SL
	activeThreads[0] = true; // Main thread is always active until program completion.
	currentThreadId = 0; // The Main thread is always the first to run.
	reg[Register::PC] = codeBlockLocation;
}

void vm::fetch()
{
	IR.opCode = memory.readInt(reg[Register::PC]);
	IR.op1 = memory.readInt(reg[Register::PC] + assembler::OPERAND_SIZE);
	IR.op2 = memory.readInt(reg[Register::PC] + (assembler::OPERAND_SIZE * 2));
	#ifdef BRIAN_DEBUG
		LOG(DEBUG) << "[TID: " << currentThreadId << "] "<< "IF[PC=" << reg[Register::PC] << "]: " << IR.opCode << " " << IR.op1 << " " << IR.op2;
	#endif
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
					cout.flush();
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
					cout.flush();
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
			#ifdef BRIAN_DEBUG
				case 98:
				{
					 LOG(INFO) << "=============== DATA SEGMENT ===============";

					int previousMemLoc = 0;
					for(int i = 1; i <= codeBlockLocation; i++)
					{
						if(symbolLocationTable.find(i) != symbolLocationTable.end())
						{
							if(i - previousMemLoc == 4)// INT
							{
								LOG(INFO) << "[ " << symbolLocationTable[previousMemLoc] << " ](INT): " << memory.readInt(previousMemLoc);
							}
							else // BYT
							{
								LOG(INFO) << "[ " << symbolLocationTable[previousMemLoc] << " ](BYT): " << memory.readChar(previousMemLoc); 
							}
							previousMemLoc = i;
						}
					}
					LOG(INFO) << "============= END DATA SEGMENT =============";
					break;
				}
				case 99:
				{
					LOG(DEBUG) << "[TID: " << currentThreadId << "] " 
						 << "Registers->{ " 
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
						 << "SB->{ " << reg[Register::SB] << " } ";
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

		case opCode::STRI:
		{
			#ifdef BRIAN_DEBUG
				LOG(DEBUG) << "STRI: MEM[" << reg[IR.op2] << "] = " << reg[IR.op1];
			#endif
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
			#ifdef BRIAN_DEBUG
				LOG(DEBUG) << "LDRI: R" << IR.op1 << " <= MEM[" << reg[IR.op2] << "] == " << memory.readInt(reg[IR.op2]);
			#endif
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

		case opCode::RUN :
		{
			int newThreadID = -1;
			for(size_t i = 1; i < AVAILABLE_THREADS; i++)
			{
				if(!activeThreads[i])
				{
					newThreadID = i;
					activeThreads[i] = true;
					break;
				}
			}

			if(newThreadID == -1)
			{
				throw runtime_error("Too many threads running! No new threads available for execution!");
			}

			reg[IR.op1] = newThreadID;
			size_t threadBase = MEMORY_SIZE - (newThreadID * threadStackSize) - 4;
			
			#ifdef BRIAN_DEBUG
				LOG(DEBUG) << "NEW THREAD: [TID: " << newThreadID << "] " << endl
							<< "\t[PC: " << threadBase << "] -> " << IR.op2 << endl
							<< "\t[R0: " << threadBase + THREAD_STACK_OFFSET_R0 << "] -> " << reg[Register::R0] << endl
							<< "\t[R1: " << threadBase + THREAD_STACK_OFFSET_R1 << "] -> " << reg[Register::R1] << endl
							<< "\t[R2: " << threadBase + THREAD_STACK_OFFSET_R2 << "] -> " << reg[Register::R2] << endl
							<< "\t[R3: " << threadBase + THREAD_STACK_OFFSET_R3 << "] -> " << reg[Register::R3] << endl
							<< "\t[R4: " << threadBase + THREAD_STACK_OFFSET_R4 << "] -> " << reg[Register::R4] << endl
							<< "\t[R5: " << threadBase + THREAD_STACK_OFFSET_R5 << "] -> " << reg[Register::R5] << endl
							<< "\t[R6: " << threadBase + THREAD_STACK_OFFSET_R6 << "] -> " << reg[Register::R6] << endl
							<< "\t[R7: " << threadBase + THREAD_STACK_OFFSET_R7 << "] -> " << reg[Register::R7] << endl
							<< "\t[SP: " << threadBase + THREAD_STACK_OFFSET_SP << "] -> " << threadBase + THREAD_STACK_OFFSET_FIRST_AVAILABLE_MEM << endl
							<< "\t[FP: " << threadBase + THREAD_STACK_OFFSET_FP << "] -> " << threadBase + THREAD_STACK_OFFSET_FIRST_AVAILABLE_MEM << endl
							<< "\t[SB: " << threadBase + THREAD_STACK_OFFSET_SB << "] -> " << threadBase + THREAD_STACK_OFFSET_FIRST_AVAILABLE_MEM << endl
							<< "\t[SL: " << threadBase + THREAD_STACK_OFFSET_SL << "] -> " << threadBase - threadStackSize + 4 << endl;
			#endif
			
			memory.writeInt(threadBase, IR.op2); // PC
			memory.writeInt(threadBase + THREAD_STACK_OFFSET_R0, reg[Register::R0]); // P0
			memory.writeInt(threadBase + THREAD_STACK_OFFSET_R1, reg[Register::R1]); // P1
			memory.writeInt(threadBase + THREAD_STACK_OFFSET_R2, reg[Register::R2]); // P2
			memory.writeInt(threadBase + THREAD_STACK_OFFSET_R3, reg[Register::R3]); // P3
			memory.writeInt(threadBase + THREAD_STACK_OFFSET_R4, reg[Register::R4]); // P4
			memory.writeInt(threadBase + THREAD_STACK_OFFSET_R5, reg[Register::R5]); // P5
			memory.writeInt(threadBase + THREAD_STACK_OFFSET_R6, reg[Register::R6]); // P6
			memory.writeInt(threadBase + THREAD_STACK_OFFSET_R7, reg[Register::R7]); // P7
			memory.writeInt(threadBase + THREAD_STACK_OFFSET_SP, threadBase + THREAD_STACK_OFFSET_FIRST_AVAILABLE_MEM); // SP
			memory.writeInt(threadBase + THREAD_STACK_OFFSET_FP, threadBase + THREAD_STACK_OFFSET_FIRST_AVAILABLE_MEM); // FP
			memory.writeInt(threadBase + THREAD_STACK_OFFSET_SB, threadBase + THREAD_STACK_OFFSET_FIRST_AVAILABLE_MEM); // SB
			memory.writeInt(threadBase + THREAD_STACK_OFFSET_SL, threadBase - threadStackSize + 4); // SL
			
			break;
		}

		case opCode::END :
		{
			if(currentThreadId == 0){ break; }
			assert(activeThreads[currentThreadId]);
			activeThreads[currentThreadId] = false;
			break;
		}

		case opCode::BLK :
		{
			if(currentThreadId != 0){ break; }
			bool continueBlock = false;
			for(size_t i = 1; i < AVAILABLE_THREADS; i++)
			{
				// Child thread is still active.  Continue blocking.
				if(activeThreads[i])
				{
					continueBlock = true;
				}
			}
			if(continueBlock)
			{
				reg[Register::PC] -= assembler::INSTRUCTION_SIZE;
			}
			break;
		}

		case opCode::LCK :
		{
			#ifdef BRIAN_DEBUG
				LOG(DEBUG) << "ATTEMPT TO LOCK FROM THREAD: " << currentThreadId;
			#endif

			int currentVal = memory.readInt(IR.op1);
			if(currentVal != -1) // The mutex is locked.  Block the thread.
			{
				if(currentVal == int(currentThreadId))
				{
					throw runtime_error("Attempt to lock same thread multiple times!");
				}
				reg[Register::PC] -= assembler::INSTRUCTION_SIZE;
			}
			else
			{
				memory.writeInt(IR.op1, currentThreadId);
			}
			break;
		}

		case opCode::ULK :
		{
			int currentVal = memory.readInt(IR.op1);

			// Only unlock if the current thread was the one that locked it.
			if(currentVal == (int)currentThreadId)
			{
				memory.writeInt(IR.op1, -1); 
			}
			break;
		}

		default:
		{
			throw runtime_error("Unexpected opCode: " + to_string(IR.opCode));
		}
	}
}

void vm::contextSwitch()
{
	size_t nextThreadId = (currentThreadId + 1) % AVAILABLE_THREADS;
	
	// look through the list of active threads and break when the next active one is found.
	while(true)
	{
		if(activeThreads[nextThreadId])
		{
			break;
		}
		nextThreadId = (nextThreadId + 1) % AVAILABLE_THREADS;
	}
	contextSwitchHelper(currentThreadId, nextThreadId);
	currentThreadId = nextThreadId;
}

void vm::contextSwitchHelper(size_t thread1Id, size_t thread2Id)
{
	size_t baseAddress = MEMORY_SIZE - (thread1Id * threadStackSize) - 4;

	memory.writeInt(baseAddress + THREAD_STACK_OFFSET_PC, reg[Register::PC]);
	memory.writeInt(baseAddress + THREAD_STACK_OFFSET_R0, reg[Register::R0]);
	memory.writeInt(baseAddress + THREAD_STACK_OFFSET_R1, reg[Register::R1]);
	memory.writeInt(baseAddress + THREAD_STACK_OFFSET_R2, reg[Register::R2]);
	memory.writeInt(baseAddress + THREAD_STACK_OFFSET_R3, reg[Register::R3]);
	memory.writeInt(baseAddress + THREAD_STACK_OFFSET_R4, reg[Register::R4]);
	memory.writeInt(baseAddress + THREAD_STACK_OFFSET_R5, reg[Register::R5]);
	memory.writeInt(baseAddress + THREAD_STACK_OFFSET_R6, reg[Register::R6]);
	memory.writeInt(baseAddress + THREAD_STACK_OFFSET_R7, reg[Register::R7]);
	memory.writeInt(baseAddress + THREAD_STACK_OFFSET_SP, reg[Register::SP]);
	memory.writeInt(baseAddress + THREAD_STACK_OFFSET_FP, reg[Register::FP]);
	memory.writeInt(baseAddress + THREAD_STACK_OFFSET_SB, reg[Register::SB]);
	memory.writeInt(baseAddress + THREAD_STACK_OFFSET_SL, reg[Register::SL]);

	baseAddress = MEMORY_SIZE - (thread2Id * threadStackSize) - 4;
	
	reg[Register::PC] = memory.readInt(baseAddress + THREAD_STACK_OFFSET_PC);
	reg[Register::R0] = memory.readInt(baseAddress + THREAD_STACK_OFFSET_R0);
	reg[Register::R1] = memory.readInt(baseAddress + THREAD_STACK_OFFSET_R1);
	reg[Register::R2] = memory.readInt(baseAddress + THREAD_STACK_OFFSET_R2);
	reg[Register::R3] = memory.readInt(baseAddress + THREAD_STACK_OFFSET_R3);
	reg[Register::R4] = memory.readInt(baseAddress + THREAD_STACK_OFFSET_R4);
	reg[Register::R5] = memory.readInt(baseAddress + THREAD_STACK_OFFSET_R5);
	reg[Register::R6] = memory.readInt(baseAddress + THREAD_STACK_OFFSET_R6);
	reg[Register::R7] = memory.readInt(baseAddress + THREAD_STACK_OFFSET_R7);
	reg[Register::SP] = memory.readInt(baseAddress + THREAD_STACK_OFFSET_SP);
	reg[Register::FP] = memory.readInt(baseAddress + THREAD_STACK_OFFSET_FP);
	reg[Register::SB] = memory.readInt(baseAddress + THREAD_STACK_OFFSET_SB);
	reg[Register::SL] = memory.readInt(baseAddress + THREAD_STACK_OFFSET_SL);
}
