/*
 * DA2_C.c
 *
 * Created: 3/10/2016 12:35:29 AM
 * Author : user
 */ 

#include <avr/io.h>

int main(void)
{
	DDRC |= 0x01;			//enable PC0 as output
	DDRD |= 0xFF;			//enable PB0-PB7 as output
	PORTC |= (1 << PC0);	//initialize PC0 to 0
	PORTD = 0x00;			//initialize binary counter to 0	
	while (1)
	{
		TCNT1 = 0x85EE;		//starting value of Timer1 
		TCCR1A = 0x00;		//Normal mode
		TCCR1B = 0x03;		//Prescaler value 
		while (!(TIFR1 & (1<<TOV1)))	//while no overflow
		{
										//keep cycling through timer
		}
		TCCR1B = 0x00;					//reset TCCR1B to 0
		TIFR1 = 0x01;					//clear overflow flags by loading with 0x01
		PORTC ^= 1;						//toggle PC0 
		if ((PORTC & (1 << 0)) == 1)	//if PC0 is set
		{
			PORTD += 1;						//increment binary counter
		}
	}
}



