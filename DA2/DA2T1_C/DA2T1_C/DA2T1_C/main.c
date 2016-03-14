/*
 * DA2T1_C.c
 *
 * Created: 3/13/2016 2:25:22 PM
 * Author : user
 */ 

#include <avr/io.h>

int main(void)
{
	DDRC |= 0x01;			//enable PB0 as output
	PORTC |= (1 << PC0);	//initialize PB0 to 1
	while (1)
	{
		TCNT1 = 0x85EE;		//starting value of Timer1
		TCCR1A = 0x00;		//Normal mode
		TCCR1B = 0x03;		//Prescaler value 64
		while (!(TIFR1 & (1<<TOV1)))	//while no overflow
		{
			//keep cycling through timer
		}
		TCCR1B = 0x00;					//reset TCCR1B to 0
		TIFR1 = 0x01;					//clear overflow flags by loading with 0x01
		PORTC ^= 1;						//toggle PB0
	}
}


