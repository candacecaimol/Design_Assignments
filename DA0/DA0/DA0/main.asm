;
; DA0.asm
;
; Created: 2/14/2016 12:25:46 PM
; Author : user
;


; Replace with your application code
.org 0
	SBI DDRB, 2		;set PB2 as output
	LDI R18, 0		;output register set to PB2 = 0 (off)
    LDI R16, 55		;load immediate to R16 (NUM1)
	LDI R17, 55		;load immediate to R17 (NUM2)
	ADD R17, R16	;sum = NUM2 + NUM1
	LDI R16, 55		;load immediate to R16 (NUM3)
	ADD R17, R16	;sum = sum + NUM3
	LDI R16, 55		;load immediate to R16 (NUM4)
	ADD R17, R16	;sum = sum + NUM4
	LDI R16, 55		;load immediate to R16 (NUM5)
	ADD R17, R16	;sum = sum + NUM5
	BRCC NoOverflow	;if no carry, branch to where light won't turn on
	LDI R18, 4		;else set to light up bit 2
NoOverFlow:
	OUT PORTB, R18	;sends value of R18 to corresponding bit
