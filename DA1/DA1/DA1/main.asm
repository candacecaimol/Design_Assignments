;
; DA1.asm
;
; Created: 2/23/2016 10:36:43 PM
; Author : user
;


; Replace with your application code
.def COUNT=R17
.def SetR7= R22				;used to set R7.3 when sums are more than 8 bits

.org 0
	LDI COUNT, 25			;number of loops numbers stored
	LDI SetR7, 8			;value to set R7.3 
	LDI XL, LOW(RAMEND)		;loads lower 8 bits of RAMEND address
	LDI XH, HIGH(RAMEND)	;loads upper 8 bits of RAMEND address
	LDI YL, 0x7F			;starting midpoint in RAM (lower byte)
	LDI YH, 0x04
	SUB XL, YL				;XL = XL + YL (to get MID_RAM)
	SUB XH, YH				;XH = XH + YH

StoreNum:
	MOV R16, XL				;moves lower 8 bytes of RAMEND/2 to R16 (value stored)
	ST X+, R16				;RAM[X] = R16
	DEC COUNT				;COUNT--
	BRNE StoreNum			;continue loop until all 25 numbers are stored 

	LDI R20, 0				;initialize sum7 to 0 (lower byte)
	LDI R21, 0				;(higher byte)
	LDI R23, 0				;intialize sum3 to 0 (lower byte)
	LDI R24, 0				;(higher byte)
	SUB R9, R9				;initialize to 0; used to add to upper 8 bits of sum7 (ADC)
	SUB R8, R8				;initialize to 0; used to add to upper 8 bits of sum3 (ADC)
AddNums:
	CPI COUNT, 25			;compare to 25 (number of elements stored)
	BREQ CmpSums			;if equal, jump to compare sums
	LD R16, -X				;goes backwards toward RAM_MID
	MOV R19, R16			;R19 = RAM[X] (used to find mod7)
	MOV R18, R16			;R18 = RAM[X] (used to find mod3)
FindModulus7:
	SUBI R19, 7				;R19 = R19 - 7
	CPI R19, 7				;compares R19 to 7
	BRSH FindModulus7		;if >= 7, continue finding modulus7
FindModulus3:
	SUBI R18, 3				;R18 = R18 - 3
	CPI R18, 3				;compares R18 to 3
	BRSH FindModulus3		;if >= 3, continue finding modulus3

	INC COUNT				;COUNT++ (number of values parsed)
	CPI R19, 0				;compare mod7 to 0
	BRNE CheckModulus3		;if mod7 != 0, jump without adding
	ADD R20, R16			;lower byte: R20 = R20 + R16
	ADC R21, R9				;upper byte (with carry): R21 = R21 + 0
CheckModulus3:
	CPI R18, 0				;compare mod3 to 0
	BRNE AddNums			;jump if mod3 != 0
	ADD R23, R16			;else add onto sum3
	ADC R24, R8			
	JMP AddNums

CmpSums:
	CPI R21, 0				;see if sum7 is greater than 8 bits
	BREQ End				;if upper byte is empty, end program
	CPI R24, 0				;see if sum 3 is greater than 8 bits
	BREQ End				;if upper byte is empty, end program
	ADD R7, SetR7			;else, set R7.3 to 1
	
End:
	JMP End					;points to end of program 
