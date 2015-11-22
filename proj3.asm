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




;FUNCTION MAIN()

TRP 0
;END MAIN()

OVERFLOW SUB R3 R3 ;Set R3 to 0
	ADI R3 -42 ;Set R3 to -42, the value that indicates overflow.
	TRP 1
	TRP 0

UNDERFLOW SUB R3 R3 ;Set R3 to 0
	ADI R3 -43 ;Set R3 to -43, the value that indicates underflow. 
	TRP 1
	TRP 0
