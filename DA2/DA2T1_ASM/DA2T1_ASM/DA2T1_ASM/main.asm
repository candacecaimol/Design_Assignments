/*
 * AssemblerApplication1.asm
 *
 *  Created: 3/7/2016 1:28:25 PM
 *   Author: caimol
 */ 


	LDI R16, 1			;R16 = 1 (bit 0)
	SBI DDRC, 0			;Set PC0 to o/p
	LDI R17, 0			;R17 = 0
	OUT PORTC, R17		;initialize PC0 to off
BEGIN:
	RCALL DELAY_SUBR	;call delay
	EOR R17, R16		;toggle bit 0 of R17
	OUT PORTC, R17		;output to PORTC
	RJMP BEGIN			;infinitely loop back through main routine
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




