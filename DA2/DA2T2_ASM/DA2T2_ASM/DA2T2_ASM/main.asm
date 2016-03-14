/*
 * AssemblerApplication1.asm
 *
 *  Created: 3/7/2016 1:28:25 PM
 *   Author: caimol
 */ 

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
	SBI DDRC, 0			;Set PC0 to o/p
	LDI R17, 0			;R17 = 0
	OUT PORTC, R17		;initialize PC0 to off
START:
	RCALL DELAY_SUBR	;call delay
	EOR R17, R16		;toggle bit 0 of R17
	;;;;;;;;;;for counter;;;;;;;;;
	OUT PORTC, R17		;output R17 to PORTC
	SBIS PORTC, 0		;if PB0 is set, skip next instruction
	JMP OUTCOUNT		;jump to OUTCOUNT without incrementing
	INC R19				;else, increment current count in counter
OUTCOUNT:
	OUT PORTD, R19		;output current counter value to PORTB
	;;;;;;;;;;;;end counter stuff;;;;;;;;;;;;;;
	OUT PORTC, R17		;output to PORTC
	RJMP START			;infinitely loop back through main routine

DELAY_SUBR:				;delay subroutine
	LDI R20, 0x85		;R20 = 0x85
	STS TCNT1H, R20		;load TCNT1H
	LDI R20, 0xEE		;R20 = 0xEE
	STS TCNT1L, R20		;load TCNT1L
	LDI R20, 0x00		;R20 = 0x00
	STS TCCR1A, R20		;normal mode
	LDI R20, 0x03		;R20 = 0x03
	STS TCCR1B, R20		;prescaler = 64
AGAIN:
	IN R20, TIFR1		;gets TOV1 flag from TIFR1
	SBRS R20, TOV1		;skip necxt instruction if OV
	RJMP AGAIN			;else, loop until OV
	LDI R20, 0x00		;R20 = 0x00
	STS TCCR1B, R20		;reset TCCR1B
	LDI R20, 0x01		;R20 = 0x01 to reset TIFR
	OUT TIFR1, R20		;reset TIFR
	RET





