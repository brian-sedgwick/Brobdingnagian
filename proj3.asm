; Project 3
; Written by Brian Sedgwick
; 11-21-2015

; Data initialization.
SIZE 		.INT	7
cnt			.INT	0
tenth		.INT	0
arry_c 		.BYT	'0'
			.BYT	'0'
			.BYT	'0'
			.BYT	'0'
			.BYT	'0'
			.BYT	'0'
			.BYT	'0'
data		.INT	0
flag		.INT	0
opdv		.INT	0

zero		.BYT	'0'
one			.BYT	'1'
two			.BYT	'2'
three		.BYT	'3'
four 		.BYT 	'4'
five 		.BYT 	'5'
six 		.BYT	'6'
seven 		.BYT 	'7'
eight 		.BYT 	'8'
nine		.BYT	'9'

int_0 		.INT 	0
int_1		.INT 	1
int_10 		.INT 	10

space 		.BYT 	' '
Char_O 		.BYT 	'O'
Char_p 		.BYT 	'p'
Char_d 		.BYT 	'd'
Char_N 		.BYT 	'N'
Char_B 		.BYT	'B'
Char_g 		.BYT 	'g'
Char_i 		.BYT 	'i'
Char_s 		.BYT 	's'
Char_n 		.BYT	'n'
Char_o 		.BYT	'o'
Char_t 		.BYT 	't'
Char_a 		.BYT	'a'
Char_u 		.BYT	'u'
Char_m 		.BYT	'm'
Char_b 		.BYT 	'b'
Char_e 		.BYT	'e'
Char_r 		.BYT 	'r'
NEWLINE 	.BYT	'\n'
plus 		.BYT 	'+'
negative	.BYT	'-'
Char_at		.BYT 	'@'

SPACE_FOR_FUNC_OPD .INT 20
SPACE_FOR_FUNC_OPD_LOCALS .INT 4
SPACE_FOR_FUNC_FLUSH .INT 8
SPACE_FOR_FUNC_FLUSH_LOCALS .INT 0
SPACE_FOR_FUNC_GETDATA .INT 8
SPACE_FOR_FUNC_GETDATA_LOCALS .INT 0
SPACE_FOR_FUNC_RESET .INT 8
SPACE_FOR_FUNC_RESET_LOCALS .INT 4


;================================FUNCTION MAIN()
FUNC_RESET_ALLOCATION_1 LDR R7 SPACE_FOR_FUNC_RESET; Check for overflow
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

	; Allocate function parameters on the stack.
	LDR R0 int_1		;int w = 1
	STR R0 (SP)
	ADI SP -4

	LDR R0 int_0		;int x = 0
	STR R0 (SP)
	ADI SP -4

	LDR R0 int_0		;int y = 0
	STR R0 (SP)
	ADI SP -4

	LDR R0 int_0		;int z = 0
	STR R0 (SP)
	ADI SP -4

	MOV R7 PC			;PC increment by 1 instruction.
	ADI R7 36			;Compute return address.  Always fixed amount.
	STR R7 (FP) 		;Write the return address to the activation record.
	JMP FUNC_RESET	;Jump to the beginning of the function.

FUNC_GETDATA_ALLOCATION_1 LDR R7 SPACE_FOR_FUNC_GETDATA; Check for overflow
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

	MOV R7 PC			;PC increment by 1 instruction.
	ADI R7 36			;Compute return address.  Always fixed amount.
	STR R7 (FP) 		;Write the return address to the activation record.
	JMP FUNC_GETDATA	;Jump to the beginning of the function.

;Setup while loop.
LDB R0 arry_c
LDB R1 Char_at
WHILE0 CMP R0 R1
	BRZ R0 END_WHILE0
	;While body

	;if (c[0] == '+' || c[0] == '-')
	LDB R0 arry_c
	LDB R1 plus
	LDB R2 negative
	IF13 CMP R1 R0
		BRZ R1 START_IF13_BODY
		CMP R2 R0
		BNZ R2 IF13_ELSE

		;IF13 BODY
		START_IF13_BODY JMP FUNC_GETDATA_ALLOCATION_2
			FUNC_GETDATA_ALLOCATION_2 LDR R7 SPACE_FOR_FUNC_GETDATA; Check for overflow
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

				MOV R7 PC			;PC increment by 1 instruction.
				ADI R7 36			;Compute return address.  Always fixed amount.
				STR R7 (FP) 		;Write the return address to the activation record.
				JMP FUNC_GETDATA	;Jump to the beginning of the function.
			JMP IF13_END

	;Start of else clause.
	IF13_ELSE LDA R0 arry_c
		LDB R1 (R0)
		ADI R0 1
		STB R1 (R0)
		ADI R0 -1
		LDB R1 plus
		STB R1 (R0)
		LDR R1 cnt
		ADI R1 1
		STR R1 cnt

	;Start of 2nd while loop
	IF13_END LDR R0 data
		WHILE2 BRZ R0 END_WHILE2
			
			;WHILE2 body.
			;if(c[cnt-1] == '\n') 
			LDR R0 cnt
			LDA R1 arry_c
			ADI R0 -1
			ADD R1 R0
			LDB R2 (R1)
			LDB R3 NEWLINE
			IF14 CMP R2 R3
				BNZ R2 ELSE14
				
				;IF14 Body.
				LDR R0 int_0
				STR R0 data
				LDR R0 int_1
				STR R0 tenth
				LDR R0 cnt
				ADI R0 -2
				STR R0 cnt

				;Setup While 3.
				LDR R0 flag
				LDR R1 cnt
				WHILE3 BNZ R0 END_WHILE3
					BRZ R1 END_WHILE3
					
					;Start WHILE3 body.
					FUNC_OPD_ALLOCATION LDR R7 SPACE_FOR_FUNC_OPD; Check for overflow
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

						; Allocate function parameters on the stack frame.
						LDB R0 arry_c		;R0 <= c[0]
						STB R0 (SP)			;char s = c[0]
						ADI SP -4
						
						LDR R1 tenth		;R1 <= tenth
						STR R1 (SP)
						ADI SP -4

						LDA R2 arry_c		;calculate address of c[cnt]
						LDR R3 cnt 			
						ADD R2 R3
						LDB R3 (R2)			;R3 <= c[cnt]
						STR R3 (SP)			;char j = c[cnt]
						ADI SP -4

						MOV R7 PC			;PC increment by 1 instruction.
						ADI R7 36			;Compute return address.  Always fixed amount.
						STR R7 (FP) 		;Write the return address to the activation record.
						JMP FUNC_OPD		;Jump to the beginning of the function.
				
					;cnt--;
					LDR R0 cnt
					ADI R0 -1
					STR R0 cnt

					;tenth *= 10
					LDR R0 tenth
					LDR R1 int_10
					MUL R0 R1
					STR R0 tenth

					;End WHILE3 body.
					LDR R0 flag
					LDR R1 cnt
					JMP WHILE3
				;End While 3.	
				END_WHILE3 LDR R0 flag
				IF15 BNZ R0 END_IF15
					LDB R3 Char_O 
					TRP 3
					LDB R3 Char_p 
					TRP 3
					LDB R3 Char_e 
					TRP 3
					LDB R3 Char_r 
					TRP 3
					LDB R3 Char_a 
					TRP 3
					LDB R3 Char_n 
					TRP 3
					LDB R3 Char_d 
					TRP 3
					LDB R3 space 
					TRP 3
					LDB R3 Char_i
					TRP 3
					LDB R3 Char_s 
					TRP 3
					LDB R3 space 
					TRP 3
					LDR R3 opdv 
					TRP 1
					LDB R3 NEWLINE 
					TRP 3

				;End IF14 Body.
				END_IF15 JMP END_IF14
			ELSE14 JMP FUNC_GETDATA_ALLOCATION_3
				FUNC_GETDATA_ALLOCATION_3 LDR R7 SPACE_FOR_FUNC_GETDATA; Check for overflow
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

					MOV R7 PC			;PC increment by 1 instruction.
					ADI R7 36			;Compute return address.  Always fixed amount.
					STR R7 (FP) 		;Write the return address to the activation record.
					JMP FUNC_GETDATA	;Jump to the beginning of the function.
			
			;End if
			END_IF14 LDR R0 data
			JMP WHILE2
			;End WHILE2 body.
		END_WHILE2 JMP FUNC_RESET_ALLOCATION_2
			FUNC_RESET_ALLOCATION_2 LDR R7 SPACE_FOR_FUNC_RESET; Check for overflow
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

				; Allocate function parameters on the stack.
				LDR R0 int_1		;int w = 1
				STR R0 (SP)
				ADI SP -4

				LDR R0 int_0		;int x = 0
				STR R0 (SP)
				ADI SP -4

				LDR R0 int_0		;int y = 0
				STR R0 (SP)
				ADI SP -4

				LDR R0 int_0		;int z = 0
				STR R0 (SP)
				ADI SP -4

				MOV R7 PC			;PC increment by 1 instruction.
				ADI R7 36			;Compute return address.  Always fixed amount.
				STR R7 (FP) 		;Write the return address to the activation record.
				JMP FUNC_RESET	;Jump to the beginning of the function.

			FUNC_GETDATA_ALLOCATION_4 LDR R7 SPACE_FOR_FUNC_GETDATA; Check for overflow
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

				MOV R7 PC			;PC increment by 1 instruction.
				ADI R7 36			;Compute return address.  Always fixed amount.
				STR R7 (FP) 		;Write the return address to the activation record.
				JMP FUNC_GETDATA	;Jump to the beginning of the function.

	;Setup next loop iteration.
	LDB R0 arry_c
	LDB R1 Char_at
	JMP WHILE0

;End  While loop.
END_WHILE0 TRP 0
;END MAIN()


;================================Function void OPD(char, int, char)
FUNC_OPD LDR R7 SPACE_FOR_FUNC_OPD_LOCALS
	; Check for overflow
	MOV R6 SP
	SUB R6 R7			;Adjust for needed space.
	CMP R6 SL			;0(SP = SL), POS(SP > SL), NEG(SP < SL)
	BLT R6 OVERFLOW 	;R6 < 0 indicates SP is less than SL after the allocation (STACK OVERFLOW)
	
	; Allocate locals
	SUB R7 R7			;Set R7 to 0
	STR R7 (SP)			;Allocate int t = 0
	ADI SP -4			;Relocate the stack pointer.

	; Load function parameters into registers.
	MOV R0 FP 			;Make a copy of the FP to work with.
	ADI R0 -8			;Set the location in the stack frame of the first parameter.
	LDB R4 (R0)			;R4 <= char s
	ADI R0 -4
	LDR R5 (R0) 		;R5 <= int k
	ADI R0 -4
	LDB R6 (R0)			;R6 <= char j

	;+++++++++++++++ BEGIN FUNCTIONAL CODE

	;If statement, .BYT input equals test.
	MOV R0 R6 			;Load first op.
	LDB R3 zero		 	;Load second op.
	IF1		CMP R3 R0
			BNZ R3 ELSE_1  ;USE BNZ for isEqual check.
			; j == '0'
			ADI R7 0
			MOV R0 FP
			ADI R0 -20
			STR R7 (R0) ; store t in memory.
			JMP END
	;Result false.
	ELSE_1	MOV R0 R6 			;Load first op.
		LDB R3 one		 	;Load second op.
		IF2		CMP R3 R0
				BNZ R3 ELSE_2  ;USE BNZ for isEqual check.
				; j == '1'
				ADI R7 1
				MOV R0 FP
				ADI R0 -20
				STR R7 (R0) ; store t in memory.
				JMP END
		;Result false.
		ELSE_2	MOV R0 R6 			;Load first op.
			LDB R3 two		 	;Load second op.
			IF3		CMP R3 R0
					BNZ R3 ELSE_3  ;USE BNZ for isEqual check.
					; j == '2'
					ADI R7 2
					MOV R0 FP
					ADI R0 -20
					STR R7 (R0) ; store t in memory.
					JMP END
			;Result false.
			ELSE_3	MOV R0 R6 			;Load first op.
				LDB R3 three		 	;Load second op.
				IF4		CMP R3 R0
						BNZ R3 ELSE_4  ;USE BNZ for isEqual check.
						; j == '3'
						ADI R7 3
						MOV R0 FP
						ADI R0 -20
						STR R7 (R0) ; store t in memory.
						JMP END
				;Result false.
				ELSE_4	MOV R0 R6 			;Load first op.
					LDB R3 four		 	;Load second op.
					IF5		CMP R3 R0
							BNZ R3 ELSE_5  ;USE BNZ for isEqual check.
							; j == '4'
							ADI R7 4
							MOV R0 FP
							ADI R0 -20
							STR R7 (R0) ; store t in memory.
							JMP END
					;Result false.
					ELSE_5	MOV R0 R6 			;Load first op.
						LDB R3 five		 	;Load second op.
						IF6		CMP R3 R0
								BNZ R3 ELSE_6  ;USE BNZ for isEqual check.
								; j == '5'
								ADI R7 5
								MOV R0 FP
								ADI R0 -20
								STR R7 (R0) ; store t in memory.
								JMP END
						;Result false.
						ELSE_6	MOV R0 R6 			;Load first op.
							LDB R3 six		 	;Load second op.
							IF7		CMP R3 R0
									BNZ R3 ELSE_7  ;USE BNZ for isEqual check.
									; j == '6'
									ADI R7 6
									MOV R0 FP
									ADI R0 -20
									STR R7 (R0) ; store t in memory.
									JMP END
							;Result false.
							ELSE_7	MOV R0 R6 			;Load first op.
								LDB R3 seven		 	;Load second op.
								IF8		CMP R3 R0
										BNZ R3 ELSE_8  ;USE BNZ for isEqual check.
										; j == '7'
										ADI R7 7
										MOV R0 FP
										ADI R0 -20
										STR R7 (R0) ; store t in memory.
										JMP END
								;Result false.
								ELSE_8	MOV R0 R6 			;Load first op.
									LDB R3 eight		 	;Load second op.
									IF9		CMP R3 R0
											BNZ R3 ELSE_9  ;USE BNZ for isEqual check.
											; j == '8'
											ADI R7 8
											MOV R0 FP
											ADI R0 -20
											STR R7 (R0) ; store t in memory.
											JMP END
									;Result false.
									ELSE_9	MOV R0 R6 			;Load first op.
										LDB R3 nine		 	;Load second op.
										IF10	CMP R3 R0
												BNZ R3 ELSE_10  ;USE BNZ for isEqual check.
												; j == '9'
												ADI R7 9
												MOV R0 FP
												ADI R0 -20
												STR R7 (R0) ; store t in memory.
												JMP END
										;Result false.
										ELSE_10	MOV R3 R6
											TRP 3
											LDB R3 space
											TRP 3
											LDB R3 Char_i
											TRP 3
											LDB R3 Char_s
											TRP 3
											LDB R3 space
											TRP 3
											LDB R3 Char_n
											TRP 3
											LDB R3 Char_o
											TRP 3
											LDB R3 Char_t
											TRP 3
											LDB R3 space
											TRP 3
											LDB R3 Char_a
											TRP 3
											LDB R3 space
											TRP 3
											LDB R3 Char_n
											TRP 3
											LDB R3 Char_u
											TRP 3
											LDB R3 Char_m
											TRP 3
											LDB R3 Char_b
											TRP 3
											LDB R3 Char_e
											TRP 3
											LDB R3 Char_r
											TRP 3
											LDB R3 NEWLINE
											TRP 3

											;Set flag = 1
											SUB R0 R0
											ADI R0 1
											STR R0 flag
										;End of If-statement.
	END LDR R3 flag 	;Load first op.
	IF11	BNZ R3 ELSE11 	;USE BNZ for not check.
			
			MOV R0 R4 			;Load first op.
			LDB R3 plus			;Load second op.
			IF12 	CMP R3 R0
					BNZ R3 ELSE12 	;USE BNZ for isEqual check.
					;Result true.
					MUL R7 R5
					JMP END3
				;Result false.
				ELSE12 SUB R2 R2
					ADI R2 -1
					MUL R2 R5
					MUL R7 R2
			;End of If-statement.
			END3 LDR R3 opdv
				ADD R3 R7
				STR R3 opdv 
				
	;Result false.
	ELSE11	JMP END2
	;End of If-statement.
	
	;+++++++++++++++ END FUNCTIONAL CODE	

	;Return (deallocate stack frame)
	;Check for underflow
	END2 MOV SP FP
	MOV R7 SP
	CMP R7 SB
	BGT R7 UNDERFLOW

	LDR R7 (FP)			;Point the FP at the previous FP.
	ADI FP -4 			;Point the FP at the location of the PFP.
	LDR FP (FP)			;Assign FP to point where PFP is pointing.
	JMR R7				;Return
;End OPD()

;================================Function void flush()
;Function flush
FUNC_FLUSH LDR R7 SPACE_FOR_FUNC_FLUSH_LOCALS
	; Check for overflow
	MOV R6 SP
	SUB R6 R7			;Adjust for needed space.
	CMP R6 SL			;0(SP = SL), POS(SP > SL), NEG(SP < SL)
	BLT R6 OVERFLOW 	;R6 < 0 indicates SP is less than SL after the allocation (STACK OVERFLOW)

	;+++++++++++++++ BEGIN FUNCTIONAL CODE
	SUB R0 R0		
	STR R0 data 		;data = 0

	TRP 4
	STB R3 arry_c 			;c[0] = getchar()

	LDB R1 NEWLINE
	WHILE1	LDB R3 arry_c
		CMP R3 R1
		BRZ R3 END_WHILE1
		TRP 4
		STB R3 arry_c 			;c[0] = getchar()
		JMP WHILE1
	
	;+++++++++++++++ END FUNCTIONAL CODE
	
	;Return (deallocate stack frame)
	;Check for underflow
	END_WHILE1 MOV SP FP
	MOV R7 SP
	CMP R7 SB
	BGT R7 UNDERFLOW

	LDR R7 (FP)			;Point the FP at the previous FP.
	ADI FP -4 			;Point the FP at the location of the PFP.
	LDR FP (FP)			;Assign FP to point where PFP is pointing.
	JMR R7				;Return
;End flush()

;================================Function void getdata()
FUNC_GETDATA LDR R7 SPACE_FOR_FUNC_GETDATA_LOCALS
	; Check for overflow
	MOV R6 SP
	SUB R6 R7			;Adjust for needed space.
	CMP R6 SL			;0(SP = SL), POS(SP > SL), NEG(SP < SL)
	BLT R6 OVERFLOW 	;R6 < 0 indicates SP is less than SL after the allocation (STACK OVERFLOW)

	;+++++++++++++++ BEGIN FUNCTIONAL CODE
	;If statement, .BYT input equals test.
	LDR R0 SIZE 	;Load first op.
	LDR	R1 cnt	 	;Load second op.
	IF CMP R1 R0
		BRZ R1 ELSE ;USE BNZ for isEqual check.
		BGT R1 ELSE
		;Result true.
		TRP 4
		LDR R2 cnt
		LDA R1 arry_c
		ADD R1 R2
		STB R3 (R1) ;c[cnt] = getchar();
		ADI R2 1	;cnt++
		STR R2 cnt
		JMP END_IF
	ELSE LDB R3 Char_N
		TRP 3
		LDB R3 Char_u
		TRP 3
		LDB R3 Char_m
		TRP 3
		LDB R3 Char_b
		TRP 3
		LDB R3 Char_e
		TRP 3
		LDB R3 Char_r
		TRP 3
		LDB R3 space
		TRP 3
		LDB R3 Char_i
		TRP 3
		LDB R3 Char_s
		TRP 3
		LDB R3 space
		TRP 3
		LDB R3 Char_t
		TRP 3
		LDB R3 Char_o
		TRP 3
		TRP 3
		LDB R3 space
		TRP 3
		LDB R3 Char_B
		TRP 3
		LDB R3 Char_i
		TRP 3
		LDB R3 Char_g
		TRP 3
		LDB R3 NEWLINE
		TRP 3

		FUNC_FLUSH_ALLOCATION LDR R7 SPACE_FOR_FUNC_FLUSH; Check for overflow
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

			MOV R7 PC			;PC increment by 1 instruction.
			ADI R7 36			;Compute return address.  Always fixed amount.
			STR R7 (FP) 		;Write the return address to the activation record.
			JMP FUNC_FLUSH		;Jump to the beginning of the function.
	;+++++++++++++++ END FUNCTIONAL CODE

	;Return (deallocate stack frame)
	;Check for underflow
	END_IF MOV SP FP
	MOV R7 SP
	CMP R7 SB
	BGT R7 UNDERFLOW
	
	LDR R7 (FP)			;Point the FP at the previous FP.
	ADI FP -4 			;Point the FP at the location of the PFP.
	LDR FP (FP)			;Assign FP to point where PFP is pointing.
	JMR R7				;Return
;End getdata()

;================================Function void reset()
FUNC_RESET LDR R7 SPACE_FOR_FUNC_RESET_LOCALS
	; Check for overflow
	MOV R6 SP
	SUB R6 R7			;Adjust for needed space.
	CMP R6 SL			;0(SP = SL), POS(SP > SL), NEG(SP < SL)
	BLT R6 OVERFLOW 	;R6 < 0 indicates SP is less than SL after the allocation (STACK OVERFLOW)

	; Allocate locals
	SUB R7 R7			;Set R7 to 0
	STR R7 (SP)			;Allocate int k = 0
	ADI SP -4			;Relocate the stack pointer.

	;+++++++++++++++ BEGIN FUNCTIONAL CODE
	;Load for loop parameters.
	LDR R6 int_0		;For use in setting c[k] = 0;

	MOV R3 FP
	ADI R3 -24			;Set the FP offset to access local var k.
	LDR R0 (R3)			;R0 <= k
	LDR R1 SIZE
	FOR_1 CMP R0 R1
		BRZ R0 END_FOR_1
		BGT R0 END_FOR_1

		;Body of for loop code. 
		LDR R0 (R3)
		LDA R5 arry_c
		ADD R5 R0
		STB R6 (R5)		;c[k] = 0

		;End body of for loop code.
		;k++
		ADI R0 1
		STR R0 (R3)
		JMP FOR_1

	; Load function parameters into registers.	
	END_FOR_1 MOV R0 FP ;Make a copy of the FP to work with.
		ADI R0 -8			;Set the location in the stack frame of the first parameter.
		LDR R4 (R0)			;R4 <= int w
		ADI R0 -4
		LDR R5 (R0) 		;R5 <= int x
		ADI R0 -4
		LDR R6 (R0)			;R6 <= int y
		ADI R0 -4
		LDR R7 (R0)			;R6 <= int z

		STR R4 data
		STR R5 opdv
		STR R6 cnt
		STR R7 flag
	;+++++++++++++++ END FUNCTIONAL CODE

	;Return (deallocate stack frame)
	;Check for underflow
	MOV SP FP
	MOV R7 SP
	CMP R7 SB
	BGT R7 UNDERFLOW

	LDR R7 (FP)			;Point the FP at the previous FP.
	ADI FP -4 			;Point the FP at the location of the PFP.
	LDR FP (FP)			;Assign FP to point where PFP is pointing.
	JMR R7				;Return
;End reset()

OVERFLOW SUB R3 R3 ;Set R3 to 0
	ADI R3 -42 ;Set R3 to -42, the value that indicates overflow.
	TRP 1
	TRP 0

UNDERFLOW SUB R3 R3 ;Set R3 to 0
	ADI R3 -43 ;Set R3 to -43, the value that indicates underflow. 
	TRP 1
	TRP 0
