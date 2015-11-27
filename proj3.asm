; Project 3
; Written by Brian Sedgwick
; 11-21-2015

; Data initialization.
SIZE 	.INT	7
cnt		.INT	0
tenth	.INT	0
c 		.BYT	'0'
		.BYT	'0'
		.BYT	'0'
		.BYT	'0'
		.BYT	'0'
		.BYT	'0'
		.BYT	'0'
data	.INT	0
flag	.INT	0
opdv	.INT	0

zero	.BYT	'0'
one		.BYT	'1'
two		.BYT	'2'
three	.BYT	'3'
four 	.BYT 	'4'
five 	.BYT 	'5'
six 	.BYT	'6'
seven 	.BYT 	'7'
eight 	.BYT 	'8'
nine	.BYT	'9'

int_1	.INT 	1
int_2	.INT 	2
int_3	.INT 	3
int_4	.INT 	4
int_5	.INT 	5

space 	.BYT 	' '
i 		.BYT 	'i'
s 		.BYT 	's'
n 		.BYT	'n'
o 		.BYT	'o'
t 		.BYT 	't'
a 		.BYT	'a'
u 		.BYT	'u'
m 		.BYT	'm'
b 		.BYT 	'b'
e 		.BYT	'e'
r 		.BYT 	'r'
NEWLINE .BYT	'\n'
plus 	.BYT 	'+'
negative	.BYT	'-'


SPACE_FOR_FUNC_OPD .INT 20
SPACE_FOR_FUNC_OPD_LOCALS .INT 4
SPACE_FOR_FUNC_FLUSH .INT 8
SPACE_FOR_FUNC_FLUSH_LOCALS .INT 0
SPACE_FOR_FUNC_GETDATA .INT 8
SPACE_FOR_FUNC_GETDATA_LOCALS .INT 0
SPACE_FOR_FUNC_RESET .INT 8
SPACE_FOR_FUNC_RESET_LOCALS .INT 4


;================================FUNCTION MAIN()

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
	LDB R0 plus			;char s = '+'
	STB R0 (SP)
	ADI SP -4
	
	LDR R0 int_1		;int k = 1
	STR R0 (SP)
	ADI SP -4

	LDB R0 one			;char j = '1'
	STR R0 (SP)
	ADI SP -4

	MOV R7 PC			;PC increment by 1 instruction.
	ADI R7 36			;Compute return address.  Always fixed amount.
	STR R7 (FP) 		;Write the return address to the activation record.
	JMP FUNC_OPD		;Jump to the beginning of the function.

	LDR R3 opdv
	TRP 1
	LDR R3 NEWLINE
	TRP 3

TRP 0
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
	LDR R4 (R0)			;R4 <= char s
	ADI R0 -4
	LDR R5 (R0) 		;R5 <= int k
	ADI R0 -4
	LDR R6 (R0)			;R6 <= char j

	;+++++++++++++++ BEGIN FUNCTIONAL CODE

	;If statement, .BYT input equals test.
	MOV R0 R6 			;Load first op.
	LDR R3 zero		 	;Load second op.
	IF1		CMP R3 R0
			TRP 99
			BNZ R3 ELSE_1  ;USE BNZ for isEqual check.
			; j == '0'
			ADI R7 0
			MOV R0 FP
			ADI R0 -20
			STR R7 (R0) ; store t in memory.
			JMP END
	;Result false.
	ELSE_1	MOV R0 R6 			;Load first op.
		LDR R3 one		 	;Load second op.
		IF2		CMP R3 R0
				TRP 99
				BNZ R3 ELSE_2  ;USE BNZ for isEqual check.
				; j == '1'
				ADI R7 1
				MOV R0 FP
				ADI R0 -20
				STR R7 (R0) ; store t in memory.
				JMP END
		;Result false.
		ELSE_2	MOV R0 R6 			;Load first op.
			LDR R3 two		 	;Load second op.
			IF3		CMP R3 R0
					TRP 99
					BNZ R3 ELSE_3  ;USE BNZ for isEqual check.
					; j == '2'
					ADI R7 2
					MOV R0 FP
					ADI R0 -20
					STR R7 (R0) ; store t in memory.
					JMP END
			;Result false.
			ELSE_3	MOV R0 R6 			;Load first op.
				LDR R3 three		 	;Load second op.
				IF4		CMP R3 R0
						TRP 99
						BNZ R3 ELSE_4  ;USE BNZ for isEqual check.
						; j == '3'
						ADI R7 3
						MOV R0 FP
						ADI R0 -20
						STR R7 (R0) ; store t in memory.
						JMP END
				;Result false.
				ELSE_4	MOV R0 R6 			;Load first op.
					LDR R3 four		 	;Load second op.
					IF5		CMP R3 R0
							TRP 99
							BNZ R3 ELSE_5  ;USE BNZ for isEqual check.
							; j == '4'
							ADI R7 4
							MOV R0 FP
							ADI R0 -20
							STR R7 (R0) ; store t in memory.
							JMP END
					;Result false.
					ELSE_5	MOV R0 R6 			;Load first op.
						LDR R3 five		 	;Load second op.
						IF6		CMP R3 R0
								TRP 99
								BNZ R3 ELSE_6  ;USE BNZ for isEqual check.
								; j == '5'
								ADI R7 5
								MOV R0 FP
								ADI R0 -20
								STR R7 (R0) ; store t in memory.
								JMP END
						;Result false.
						ELSE_6	MOV R0 R6 			;Load first op.
							LDR R3 six		 	;Load second op.
							IF7		CMP R3 R0
									TRP 99
									BNZ R3 ELSE_7  ;USE BNZ for isEqual check.
									; j == '6'
									ADI R7 6
									MOV R0 FP
									ADI R0 -20
									STR R7 (R0) ; store t in memory.
									JMP END
							;Result false.
							ELSE_7	MOV R0 R6 			;Load first op.
								LDR R3 seven		 	;Load second op.
								IF8		CMP R3 R0
										TRP 99
										BNZ R3 ELSE_8  ;USE BNZ for isEqual check.
										; j == '7'
										ADI R7 7
										MOV R0 FP
										ADI R0 -20
										STR R7 (R0) ; store t in memory.
										JMP END
								;Result false.
								ELSE_8	MOV R0 R6 			;Load first op.
									LDR R3 eight		 	;Load second op.
									IF9		CMP R3 R0
											TRP 99
											BNZ R3 ELSE_9  ;USE BNZ for isEqual check.
											; j == '8'
											ADI R7 8
											MOV R0 FP
											ADI R0 -20
											STR R7 (R0) ; store t in memory.
											JMP END
									;Result false.
									ELSE_9	MOV R0 R6 			;Load first op.
										LDR R3 nine		 	;Load second op.
										IF10	CMP R3 R0
												TRP 99
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
											LDB R3 i
											TRP 3
											LDB R3 s
											TRP 3
											LDB R3 space
											TRP 3
											LDB R3 n
											TRP 3
											LDB R3 o
											TRP 3
											LDB R3 t
											TRP 3
											LDB R3 space
											TRP 3
											LDB R3 a
											TRP 3
											LDB R3 space
											TRP 3
											LDB R3 n
											TRP 3
											LDB R3 u
											TRP 3
											LDB R3 m
											TRP 3
											LDB R3 b
											TRP 3
											LDB R3 e
											TRP 3
											LDB R3 r
											TRP 3
											LDB R3 NEWLINE
											TRP 3

											;Set flag = 1
											SUB R0 R0
											ADI R0 1
											STR R0 flag
										;End of If-statement.
	END LDR R3 flag 	;Load first op.
	IF11	BRZ R3 ELSE11 	;USE BRZ for not check.
			
			MOV R0 R4 			;Load first op.
			LDB R3 plus			;Load second op.
			IF12 	CMP R3 R0
					TRP 99
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
	TRP 99
	JMR R7				;Return
;End OPD()

;================================Function void flush()
FUNC_FLUSH LDR R7 SPACE_FOR_FUNC_FLUSH_LOCALS
	; Check for overflow
	MOV R6 SP
	SUB R6 R7			;Adjust for needed space.
	CMP R6 SL			;0(SP = SL), POS(SP > SL), NEG(SP < SL)
	BLT R6 OVERFLOW 	;R6 < 0 indicates SP is less than SL after the allocation (STACK OVERFLOW)

	;+++++++++++++++ BEGIN FUNCTIONAL CODE
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
;End flush()

;================================Function void getdata()
FUNC_GETDATA LDR R7 SPACE_FOR_FUNC_GETDATA_LOCALS
	; Check for overflow
	MOV R6 SP
	SUB R6 R7			;Adjust for needed space.
	CMP R6 SL			;0(SP = SL), POS(SP > SL), NEG(SP < SL)
	BLT R6 OVERFLOW 	;R6 < 0 indicates SP is less than SL after the allocation (STACK OVERFLOW)

	;+++++++++++++++ BEGIN FUNCTIONAL CODE
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
;End getdata()

;================================Function void reset()
FUNC_RESET LDR R7 SPACE_FOR_FUNC_RESET_LOCALS
	; Check for overflow
	MOV R6 SP
	SUB R6 R7			;Adjust for needed space.
	CMP R6 SL			;0(SP = SL), POS(SP > SL), NEG(SP < SL)
	BLT R6 OVERFLOW 	;R6 < 0 indicates SP is less than SL after the allocation (STACK OVERFLOW)

	;+++++++++++++++ BEGIN FUNCTIONAL CODE
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
