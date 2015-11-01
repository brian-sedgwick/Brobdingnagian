; Project 2
; Written by Brian Sedgwick
; 10-30-2015


SIZE	.INT 10
ARR 	.INT 10
		.INT 2
		.INT 3
		.INT 4
		.INT 15
		.INT -6
		.INT 7
		.INT 8
		.INT 9
		.INT 10

INDEX	.INT 0
SUM		.INT 0
TEMP	.INT 0
RESULT	.INT 0

SPACE	.BYT ' '
NEWLINE .BYT '\n'
i 		.BYT 'i'
s 		.BYT 's'
e 		.BYT 'e'
v 		.BYT 'v'
n 		.BYT 'n'
o 		.BYT 'o'
d 		.BYT 'd'
u 		.BYT 'u'
m 		.BYT 'm'

D 		.BYT 'D'
A 		.BYT 'A'
G 		.BYT 'G'
S 		.BYT 'S'

INT_SZ	.INT 4

LDR R5 SUM
LDR R2 INDEX
WHILE LDR R4 SIZE
	LDR R0 INT_SZ
	MUL R4 R0
	CMP R4 R2
	BRZ R4 END_WHILE
	BLT R4 END_WHILE
	LDA R1 ARR ;Put the address of ARR in the register
	ADD R1 R2 ; Index into the array.  The address of arr[i] is now in R1.
	LDR R3 (R1) ; Load the actual value of arr[i] into R3.
	ADD R5 R3 ; sum += arr[i];
	STR R5 SUM

	MOV R7 R3 ; Copy arr[i] to R7 for calculations of EVEN / ODD.
	SUB R6 R6 ; Set R6 to 0
	ADI R6 2
	DIV R7 R6 ; Divide arr[i] by 2 and then multiply by 2.  If the result is the same as the original
	MUL R7 R6 ; then arr[i] is even.  Else, it's odd.
	CMP R7 R3

	IF	BNZ R7 ODD ; The number was odd.
		EVEN TRP 1 ; Print arr[i]
			LDB R3 SPACE
			TRP 3
			LDB R3 i
			TRP 3
			LDB R3 s
			TRP 3
			LDB R3 SPACE
			TRP 3
			LDB R3 e
			TRP 3
			LDB R3 v
			TRP 3
			LDB R3 e
			TRP 3
			LDB R3 n
			TRP 3
			LDB R3 NEWLINE
			TRP 3
			JMP END_IF
		ODD TRP 1 ; Print arr[i]
			LDB R3 SPACE
			TRP 3
			LDB R3 i
			TRP 3
			LDB R3 s
			TRP 3
			LDB R3 SPACE
			TRP 3
			LDB R3 o
			TRP 3
			LDB R3 d
			TRP 3
			TRP 3
			LDB R3 NEWLINE
			TRP 3
	END_IF	ADI R2 4
JMP WHILE
END_WHILE LDB R3 S
TRP 3
LDB R3 u
TRP 3
LDB R3 m
TRP 3
LDB R3 SPACE
TRP 3
LDB R3 i
TRP 3
LDB R3 s
TRP 3
LDB R3 SPACE
TRP 3
MOV R3 R5
TRP 1
LDB R3 NEWLINE
TRP 3
TRP 3

;;;; BEGINNING OF PART 2
LDB R3 D ;Print DAGS #
TRP 3
LDB R3 A
TRP 3
LDB R3 G
TRP 3
LDB R3 S
TRP 3
LDB R3 SPACE
TRP 3
LDR R3 D
TRP 1
MOV R7 R3 ; Save the integer value of DAGS for later.
LDR R3 SPACE
TRP 3

LDB R1 D ;Swap 'D' and 'G'
LDB R2 G
STB R1 G
STB R2 D

LDB R3 D ;Print GADS #
TRP 3
LDB R3 A
TRP 3
LDB R3 G
TRP 3
LDB R3 S
TRP 3
LDB R3 SPACE
TRP 3
LDR R3 D
TRP 1
MOV R6 R3 ;Save the value of GADS for later
LDR R3 SPACE
TRP 3

SUB R7 R6 ; Print DAGS - GADS
MOV R3 R7
TRP 1

TRP 0 ; END OF PROGRAM