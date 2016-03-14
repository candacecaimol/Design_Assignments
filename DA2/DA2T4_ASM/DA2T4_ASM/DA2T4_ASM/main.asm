/*
 * AssemblerApplication1.asm
 *
 *  Created: 3/7/2016 1:28:25 PM
 *   Author: caimol
 */ 


.ORG 0					;location for reset
	JMP MAIN			;jump to main program, skipping the jump to interrupt subroutine
.ORG 0x08				;location for PCINT1
	JMP EX1_ISR		;jump to interrupt subroutine
MAIN:
	SBI DDRC, 5			;enable PC5 as output
	SBI DDRC, 4			;enable PC4 as output
	SUB R5, R5			;initialize count5 to 0
	SUB R10, R10		;initialize count10 to 0
	LDI R16, 5			;R16 = 5
	ADD R1, R16			;used to compare to count5
	LDI R16, 10			;R16 = 10
	ADD R2, R16			;used to compare to count10
	LDI R16, 32			;R16 = 32
	ADD R6, R16			;2^5 (causes PC5 to light up)
	LDI R16, 16			;R16 = 16
	ADD R7, R16			;2^4 (causes PC4 to light up)
	SUB R8, R8			;initialize PC5 to 0 (off)
	;;;;;;;;initializations for counter;;;;;;;;;;
	SBI DDRD, 0			;enable PB0 as output
	SBI DDRD, 1			;enable PB1 as output
	SBI DDRD, 2			;enable PB2 as output
	SBI DDRD, 3			;enable PB3 as output
	SBI DDRD, 4			;enable PB4 as output
	SBI DDRD, 5			;enable PB5 as output
	SBI DDRD, 6			;enable PB6 as output
	SBI DDRD, 7			;enable PB7 as output
	LDI R19, 0			;counter initialized to 0 (R19 is designated register)
	OUT PORTD, R19		;output the counter value
	;;;;;;;;initializations for PC0 output (blinks with counter);;;;;;;;;;;;;
	LDI R16, 1			;R16 = 1 (bit 0)
	SBI DDRC, 0			;enable PC0 as output 
	OUT PORTC, R8		;output 0 to PORTC (initialized as off) 
		;;;;;;;;;;;;;;;;;;;;;;;setting conditions for interrupt;;;;;;;;;;;;;;;;;;;
	LDI R20, 1 << PCIE1	;enable PCIE1
	STS PCICR, R20		;change on enabled pin on PCINT[14:8] will cause interrupt
	LDI R20, 1 << PCIF1	;enable PCIF1
	STS PCIFR, R20		;PCIF1 becomes set on logic change in PCINT[14:8]
	LDI R20, 1 << PCINT8;enable PCINT8 (PC0)
	STS PCMSK1, R20		;pin change interrupt enabled on PCINT8
	SEI					;set I (enable interrupts)
	;;;;;;;;;;;;;;;;;;;;;;;end ISR settings;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
START:
	RCALL DELAY_SUBR	;call delay subroutine
	EOR R8, R16			;XOR to toggle bit 0 of R8
	;;;;;;;for counter;;;;;;;;;;;;
	OUT PORTC, R8		;output R8 to PORTC
	SBIS PORTC, 0		;compare current value at PB0 to check if high (rising edge). if so skip next instruction
	JMP OUTCOUNT		;jump to OUTCOUNT (don't increment)
	INC R19				;else, increment current count in counter
OUTCOUNT:
	OUT PORTD, R19		;output current counter value to PORTB
	;;;;;;;;;;;;end counter stuff;;;;;;;;;;;;;;
	OUT	PORTC, R8		;output value to PORTC
	RJMP START			;loop back through main routine
DELAY_SUBR:
	LDI R20, 0x85		;R20 = 0x85
	STS TCNT1H, R20		;load TCNT1H (top byte of starting value of timer)
	LDI R20, 0xEE		;R20 = 0xEE
	STS TCNT1L, R20		;R20 = 0xEE (lower byte of starting value of timer)
	LDI R20, 0x00		;R20 = 0x00
	STS TCCR1A, R20		;0x00 = Normal mode
	LDI R20, 0x03		;R20 = 0x03
	STS TCCR1B, R20		;prescaler = 64 
AGAIN:
	IN R20, TIFR1		;gets TOV1 flag from TIFR1
	SBRS R20, TOV1		;skip next instruction if OV
	RJMP AGAIN			;else loop until OV
	LDI R20, 0x00		;R20 = 0x00
	STS TCCR1B, R20		;Reset TCCR1B
	LDI R20, 0x01		;R20 = 0x01 to reset TIFR
	OUT TIFR1, R20		;Reset TIFR 
	RET					;return from function call
	;;;;;;;;;;;;;;;;;;;;;;interrupt subroutine;;;;;;;;;;;;;;;;;;;;;;;;;
EX1_ISR:				;interrupt subroutine
	OUT PORTC, R8
	SBIS PORTC, 0
	JMP CHECK5
	INC R5				;increment R5 (count5)
	INC R10				;increment R10 (count10)
CHECK5:
	CP R5, R1			;compare count5 to 5
	BRLO CHECK10		;branch if lower than 
	EOR R8, R6			;else, toggle PC5
	SUB R5, R5			;reset count5 to 0
CHECK10:
	CP R10, R2			;compare count10 to 10
	BRLO ISR_DONE		;branch if lower than
	EOR R8, R7			;else, toggle PC4
	SUB R10, R10		;reset count10 to 0
ISR_DONE:
	LDI R20, 1 << INTF1	;write logical 1 to INTF1
	OUT EIFR, R20		;clear interrupt flag
	RETI					;return from interrupt subroutine






