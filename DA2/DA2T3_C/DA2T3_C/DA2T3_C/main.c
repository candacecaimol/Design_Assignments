/*
 * DA2T3_C.c
 *
 * Created: 3/13/2016 2:54:53 PM
 * Author : user
 */ 

#include <avr/io.h>

int main(void)
{
	DDRC |= 0x31;			//enable PC0 as output
	DDRD |= 0xFF;			//enable PB0-PB7 as output
	PORTC |= (0 << PC0);	//initialize PC0 to 0
	PORTD = 0x00;			//initialize binary counter to 0
	static int count = 0;	//used to count number of cycles
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
		PORTC ^= 1;						//toggle PC0
		if (PORTC & (1 << 0))	//if PC0 is set
		{
			PORTD += 1;						//increment binary counter
			count++;						//increment count
			if (count % 5 == 0)				//for every 5th count
			{
				PORTC ^= (1 << PC5);		//toggle PC5
			}
			if (count % 10 == 0)			//for every 10th count
			{
				PORTC ^= (1 << PC4);		//toggle PC4
			}
		}
	}
}


