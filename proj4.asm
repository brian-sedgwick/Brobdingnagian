;Project 4
;Written by Brian Sedgwick
;December 2, 2015

THREAD_LOCK 	.INT -1
CNT_LOCK		.INT -1
PROMPT	.BYT 	'>'
SPACE_FOR_FACTORIAL	.INT	12 ; Return, PVP, INT parameter.
INT_SIZE 	.INT 	4
CNT		.INT 	0

ARRAY 	.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0
		.INT	0

AR_SIZE	.INT	30

Char_F 	.BYT	'F'
Char_a 	.BYT 	'a'
Char_c 	.BYT 	'c'
Char_t 	.BYT 	't'
Char_o	.BYT	'o'
Char_r	.BYT	'r'
Char_i	.BYT	'i'
Char_l	.BYT	'l'
Char_f 	.BYT 	'f'
Char_s 	.BYT 	's'
NEWLINE	.BYT 	'\n'
SPACE 	.BYT 	' '
COMMA 	.BYT 	','

;======================== BEGIN CODE ========================
START_PART_1 LDB R3 PROMPT
	TRP 3
	TRP 2

	BRZ R3 END_PART_1

	LDR R0 CNT 			;Index into the array to place X.
	LDR R6 INT_SIZE
	MUL R6 R0
	LDA R1 ARRAY
	ADD R1 R6
	STR R3 (R1)
	ADI R0 1			;CNT++
	STR R0 CNT

	MOV R4 R3
	LDB R3 Char_F
	TRP 3
	LDB R3 Char_a
	TRP 3
	LDB R3 Char_c
	TRP 3
	LDB R3 Char_t
	TRP 3
	LDB R3 Char_o
	TRP 3
	LDB R3 Char_r
	TRP 3
	LDB R3 Char_i
	TRP 3
	LDB R3 Char_a
	TRP 3
	LDB R3 Char_l
	TRP 3
	LDB R3 SPACE
	TRP 3
	LDB R3 Char_o
	TRP 3
	LDB R3 Char_f
	TRP 3
	LDB R3 SPACE
	TRP 3
	MOV R3 R4
	TRP 1
	LDB R3 SPACE
	TRP 3
	LDB R3 Char_i
	TRP 3
	LDB R3 Char_s
	TRP 3
	LDB R3 SPACE
	TRP 3

	LDR R7 SPACE_FOR_FACTORIAL
	; Check for overflow
	MOV R6 SP
	SUB R6 R7			;Adjust for needed space.
	CMP R6 SL			;0(SP = SL), POS(SP > SL), NEG(SP < SL)
	BLT R6 OVERFLOW 	;R6 < 0 indicates SP is less than SL after the allocation (STACK OVERFLOW)

	; Allocate stack frame
	MOV R7 FP 			;Save current FP. This will be the PFP.
	MOV FP SP 			;Set the FP to the current SP.
	ADI SP -4			;Move the SP to the PFP position.
	STR R7 (SP)			;Save the PFP.
	ADI SP -4			;Move the SP up past the PFP.

	;Push function parameter 1.
	STR R4 (SP)
	ADI SP -4	

	MOV R7 PC			;PC increment by 1 instruction.
	ADI R7 36			;Compute return address.  Always fixed amount.
	STR R7 (FP) 		;Write the return address to the activation record.
	JMP FACTORIAL		;Jump to the beginning of the function.

	LDR R3 (SP)			;Get return value and display and store it.
	TRP 1
	MOV R4 R3
	LDR R3 CNT
	LDR R6 INT_SIZE
	MUL R6 R3
	LDA R2 ARRAY
	ADD R2 R6
	STR R4 (R2)
	ADI R3 1			;CNT++
	STR R3 CNT

	LDB R3 NEWLINE
	TRP 3

	JMP START_PART_1

END_PART_1 JMP START_PART_2
START_PART_2 SUB R0 R0 			;Initialize the indexes into the array.
	LDR R1 CNT
	ADI R1 -1
	LDR R6 INT_SIZE
	MUL R6 R1

	LDA R7 ARRAY 				;Index into the two ends of the array.
	ADD R0 R7
	ADD R6 R7

	MOV R4 R0 	;Walk the array from both ends in to the center.
	MOV R5 R6
	CMP R4 R5
	BGT R4 END_PART_2

	;Print the elements
	LDR R3 (R0)
	TRP 1
	LDR R3 COMMA
	TRP 3
	LDR R3 SPACE
	TRP 3
	LDR R3 (R6)
	TRP 1

	PRINT_ELEMENTS ADI R0 4
		ADI R6 -4
		MOV R4 R0 	;Walk the array from both ends in to the center.
		MOV R5 R6
		CMP R4 R5
		BGT R4 END_PART_2

		;Print the elements
		LDR R3 COMMA
		TRP 3
		LDR R3 SPACE
		TRP 3
		LDR R3 (R0)
		TRP 1
		LDR R3 COMMA
		TRP 3
		LDR R3 SPACE
		TRP 3
		LDR R3 (R6)
		TRP 1

		JMP PRINT_ELEMENTS

END_PART_2 LDB R3 NEWLINE
	TRP 3
START_PART_3 SUB R0 R0 			;Reset Count to 0
	STR R0 CNT
	
	LCK THREAD_LOCK				;Lock the threads so that nothing starts immediately.
	START_INPUT LDB R3 PROMPT
		TRP 3
		TRP 2

		BRZ R3 END_PART_3			;Finish loop if 0 is entered.
		MOV R2 R3					;Move the input from R3 to R2 so it doesn't get clobbered.

		RUN R3 CREATE_THREAD		;Create a new thread.
		JMP START_INPUT
	
END_PART_3 ULK THREAD_LOCK
	BLK
	LDB R3 NEWLINE
	TRP 3
	SUB R0 R0 			;Initialize the indexes into the array.
	LDR R1 CNT
	ADI R1 -1
	LDR R6 INT_SIZE
	MUL R6 R1

	LDA R7 ARRAY 				;Index into the two ends of the array.
	ADD R0 R7
	ADD R6 R7

	MOV R4 R0 	;Walk the array from both ends in to the center.
	MOV R5 R6
	CMP R4 R5
	BGT R4 END_PART_4

	;Print the elements
	LDR R3 (R0)
	TRP 1
	LDR R3 COMMA
	TRP 3
	LDR R3 SPACE
	TRP 3
	LDR R3 (R6)
	TRP 1

	PRINT_ELEMENTS_2 ADI R0 4
		ADI R6 -4
		MOV R4 R0 	;Walk the array from both ends in to the center.
		MOV R5 R6
		CMP R4 R5
		BGT R4 END_PART_4

		;Print the elements
		LDR R3 COMMA
		TRP 3
		LDR R3 SPACE
		TRP 3
		LDR R3 (R0)
		TRP 1
		LDR R3 COMMA
		TRP 3
		LDR R3 SPACE
		TRP 3
		LDR R3 (R6)
		TRP 1

		JMP PRINT_ELEMENTS_2

END_PART_4 LDB R3 NEWLINE
	TRP 3
	TRP 0 ;End of program.

;========================= THREADS =========================
CREATE_THREAD LDR R7 SPACE_FOR_FACTORIAL
	; Check for overflow
	MOV R6 SP
	SUB R6 R7			;Adjust for needed space.
	CMP R6 SL			;0(SP = SL), POS(SP > SL), NEG(SP < SL)
	BLT R6 OVERFLOW 	;R6 < 0 indicates SP is less than SL after the allocation (STACK OVERFLOW)

	; Allocate stack frame
	MOV R7 FP 			;Save current FP. This will be the PFP.
	MOV FP SP 			;Set the FP to the current SP.
	ADI SP -4			;Move the SP to the PFP position.
	STR R7 (SP)			;Save the PFP.
	ADI SP -4			;Move the SP up past the PFP.

	;Push function parameter 1.
	STR R2 (SP)
	ADI SP -4	

	MOV R7 PC			;PC increment by 1 instruction.
	ADI R7 60			;Compute return address.  Always fixed amount.
	STR R7 (FP) 		;Write the return address to the activation record.
	
	LCK THREAD_LOCK		;Wait to start the thread until main unlocks.
	ULK THREAD_LOCK	
	JMP FACTORIAL		;Jump to the beginning of the function.

	LDB R3 Char_F
	TRP 3
	LDB R3 Char_a
	TRP 3
	LDB R3 Char_c
	TRP 3
	LDB R3 Char_t
	TRP 3
	LDB R3 Char_o
	TRP 3
	LDB R3 Char_r
	TRP 3
	LDB R3 Char_i
	TRP 3
	LDB R3 Char_a
	TRP 3
	LDB R3 Char_l
	TRP 3
	LDB R3 SPACE
	TRP 3
	LDB R3 Char_o
	TRP 3
	LDB R3 Char_f
	TRP 3
	LDB R3 SPACE
	TRP 3
	MOV R3 R2
	TRP 1
	LDB R3 SPACE
	TRP 3
	LDB R3 Char_i
	TRP 3
	LDB R3 Char_s
	TRP 3
	LDB R3 SPACE
	TRP 3
	LDR R3 (SP)			;Get return value and display and store it.
	TRP 1

	LCK CNT_LOCK
	LDR R0 CNT 			;Index into the array to place X.
	LDR R6 INT_SIZE
	MUL R6 R0
	LDA R1 ARRAY
	ADD R1 R6
	STR R2 (R1)			;Store X
	ADI R1 4
	STR R3 (R1)
	ADI R0 2
	STR R0 CNT
	ULK CNT_LOCK

	END


;======================== FUNCTIONS ========================
FACTORIAL MOV R7 FP
	ADI R7 -8			;Compute the location of the first passed parameter.
	LDR R0 (R7)
	BRZ R0 BASE_CASE
	
	ADI R0 -1			;Decrement num in preparation for recursive call to FACTORIAL.

	;Non-base case.
	; Factorial Allocation
	; Compute space needed for function call
	; Check for overflow
	LDR R7 SPACE_FOR_FACTORIAL
	MOV R6 SP
	SUB R6 R7			;Adjust for needed space.
	CMP R6 SL			;0(SP = SL), POS(SP > SL), NEG(SP < SL)
	BLT R6 OVERFLOW 	;R6 < 0 indicates SP is less than SL after the allocation (STACK OVERFLOW)

	; Allocate stack frame
	MOV R7 FP 			;Save current FP. This will be the PFP.
	MOV FP SP 			;Set the FP to the current SP
	ADI SP -4			;Move the SP to the PFP position.
	STR R7 (SP)			;Save the PFP.
	ADI SP -4			;Move the SP up past the PFP.

	;Push function parameter 1.
	MOV R7 R0
	STR R7 (SP)
	ADI SP -4	

	MOV R7 PC			;PC increment by 1 instruction.
	ADI R7 36			;Compute return address.  Always fixed amount.
	STR R7 (FP) 		;Write the return address to the activation record.
	JMP FACTORIAL		;Jump to the beginning of the function.

	LDR R1 (SP) 		;Get the return value from the function call.
	MOV R7 FP			;Compute the location of the first passed parameter.
	ADI R7 -8			
	LDR R0 (R7)			;Load the parameter in preparation for multiplication.
	MUL R0 R1			;Multiply the result by the starting num.

	;Return (deallocate stack frame)
	MOV SP FP
	MOV R7 SP
	CMP R7 SB
	BGT R7 UNDERFLOW

	LDR R7 (FP)			;Point the FP at the previous FP.
	ADI FP -4 			;Point the FP at the location of the PFP.
	LDR FP (FP)			;Assign FP to point where PFP is pointing.
	STR R0 (SP)			;Push the return value onto the stack at SP.
	JMR R7				;Return

	;Return (deallocate stack frame)
	;Check for underflow
	BASE_CASE MOV SP FP
		MOV R7 SP
		CMP R7 SB
		BGT R7 UNDERFLOW

		LDR R7 (FP)			;Point the FP at the previous FP.
		ADI FP -4 			;Point the FP at the location of the PFP.
		LDR FP (FP)			;Assign FP to point where PFP is pointing.
		ADI R0 1
		STR R0 (SP)			;Push the return value onto the stack at SP.
		JMR R7				;Return
; END FACTORIAL


OVERFLOW SUB R3 R3 ;Set R3 to 0
	ADI R3 -42 ;Set R3 to -42, the value that indicates overflow.
	TRP 1
	TRP 0

UNDERFLOW SUB R3 R3 ;Set R3 to 0
	ADI R3 -43 ;Set R3 to -43, the value that indicates underflow. 
	TRP 1
	TRP 0
