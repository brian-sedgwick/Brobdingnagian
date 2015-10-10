;BEGIN STATIC DATA

A1 	.INT	1
A2 	.INT	2
A3 	.INT	3
A4 	.INT	4
A5 	.INT	5
A6 	.INT	6

B1 	.INT 	300
B2 	.INT 	150
B3 	.INT 	50
B4 	.INT 	20
B5 	.INT 	10
B6 	.INT 	5

C1 	.INT 	500
C2 	.INT 	2
C3 	.INT 	5
C4 	.INT 	10

;Declare characters of name
S 	.BYT	83
e 	.BYT	101
d 	.BYT	100
g 	.BYT	103
w 	.BYT	119
i 	.BYT	105
c 	.BYT	99
k 	.BYT	107

COMMA .BYT 	44
SPACE .BYT 32

B 	.BYT	66
r	.BYT	114
a 	.BYT	97
n 	.BYT	110

NEWLINE .BYT 10

; BEGIN CODE

; 1. Outout "Brian Sedgwick".

LDR R3 S
TRP 3
LDR R3 e
TRP 3
LDR R3 d
TRP 3
LDR R3 g
TRP 3
LDR R3 w
TRP 3
LDR R3 i
TRP 3
LDR R3 c
TRP 3
LDR R3 k
TRP 3

LDR R3 COMMA
TRP 3
LDR R3 SPACE
TRP 3

LDR R3 B
TRP 3
LDR R3 r
TRP 3
LDR R3 i
TRP 3
LDR R3 a
TRP 3
LDR R3 n
TRP 3

; 2. Output a blank line.
LDR R3 NEWLINE
TRP 3
TRP 3

; 3. Add all the elements of B together; displaying the intermediate results of each operation.
  	LDR R2 SPACE ;Load ' ' in R2
LDR R3 B1 ; Load 300 in R3

LDR R1 B2 	; Load 150 in R1
ADD R3 R1 	; R3 <- 300 + 150
TRP 1		; Output 450

;Output 2 spaces.
MOV R4 R3	; Move the result from R3 to R4
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3
MOV R3 R4	; Put the intermediate sum back in R3

LDR R1 B3 	; Load 50 in R1
ADD R3 R1 	; R3 <- 450 + 50
TRP 1		; Output 500

;Output 2 spaces.
MOV R4 R3	; Move the result from R3 to R4
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3
MOV R3 R4	; Put the intermediate sum back in R3

LDR R1 B4 	; Load 20 in R1
ADD R3 R1 	; R3 <- 500 + 20
TRP 1		; Output 520

;Output 2 spaces.
MOV R4 R3	; Move the result from R3 to R4
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3
MOV R3 R4	; Put the intermediate sum back in R3

LDR R1 B5 	; Load 10 in R1
ADD R3 R1 	; R3 <- 520 + 10
TRP 1		; Output 530

;Output 2 spaces.
MOV R4 R3	; Move the result from R3 to R4
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3
MOV R3 R4	; Put the intermediate sum back in R3

LDR R1 B6 	; Load 5 in R1
ADD R3 R1 	; R3 <- 530 + 5
TRP 1		; Output 535

MOV R7 R3	; Store the final result in R7

; 4. Output a blank line.
LDR R3 NEWLINE
TRP 3
TRP 3

; 5. Multiply all elements of A together; outputting each intermediate result.
LDR R3 A1 ; Put the first element of A into R3

; Multiply A1 * A2 and output result
LDR R1 A2
MUL R3 R1
TRP 1

;Output 2 spaces.
MOV R4 R3	; Move the result from R3 to R4
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3
MOV R3 R4	; Put the intermediate sum back in R3

; Multiply the result by A3 and output.
LDR R1 A3
MUL R3 R1
TRP 1

;Output 2 spaces.
MOV R4 R3	; Move the result from R3 to R4
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3
MOV R3 R4	; Put the intermediate sum back in R3

; Multiply the result by A4 and output.
LDR R1 A4
MUL R3 R1
TRP 1

;Output 2 spaces.
MOV R4 R3	; Move the result from R3 to R4
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3
MOV R3 R4	; Put the intermediate sum back in R3

; Multiply the result by A5 and output.
LDR R1 A5
MUL R3 R1
TRP 1

;Output 2 spaces.
MOV R4 R3	; Move the result from R3 to R4
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3
MOV R3 R4	; Put the intermediate sum back in R3

; Multiply the result by A6 and output.
LDR R1 A6
MUL R3 R1
TRP 1

MOV R5 R3 	; Store the final result of step 5 in R5

; 6. Output a blank line.
LDR R3 NEWLINE
TRP 3
LDR R3 NEWLINE
TRP 3

; 7. Divide the final result from part 3, by each element of list B.
; Divide 535 / B1
MOV R3 R7
LDR R4 B1
DIV R3 R4
TRP 1

;Output 2 spaces.
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3

; Divide 535 / B2
MOV R3 R7
LDR R4 B2
DIV R3 R4
TRP 1

;Output 2 spaces.
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3

; Divide 535 / B3
MOV R3 R7
LDR R4 B3
DIV R3 R4
TRP 1

;Output 2 spaces.
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3

; Divide 535 / B4
MOV R3 R7
LDR R4 B4
DIV R3 R4
TRP 1

;Output 2 spaces.
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3

; Divide 535 / B5
MOV R3 R7
LDR R4 B5
DIV R3 R4
TRP 1

;Output 2 spaces.
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3

; Divide 535 / B6
MOV R3 R7
LDR R4 B6
DIV R3 R4
TRP 1

; 8. Output a blank line.
LDR R3 NEWLINE
TRP 3
TRP 3

; 9. Subtract each element of list C from the final result of step 5.
MOV R3 R5 	; Load the final result of step 5 into R3.
LDR R4 C1
SUB R3 R4
TRP 1

;Output 2 spaces.
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3

MOV R3 R5 	; Load the final result of step 5 into R3.
LDR R4 C2
SUB R3 R4
TRP 1

;Output 2 spaces.
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3

MOV R3 R5 	; Load the final result of step 5 into R3.
LDR R4 C3
SUB R3 R4
TRP 1

;Output 2 spaces.
MOV R3 R2	; Put the SPACE in R3
TRP 3
TRP 3

MOV R3 R5 	; Load the final result of step 5 into R3.
LDR R4 C4
SUB R3 R4
TRP 1

TRP 0