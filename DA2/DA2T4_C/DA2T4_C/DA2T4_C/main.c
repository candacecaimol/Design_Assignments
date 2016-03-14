/*
 * DA2T4_C.c
 *
 * Created: 3/13/2016 3:06:42 PM
 * Author : user
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>

int main(void)
{
	DDRC |= 0x31;			//enable PC0 as output
	DDRD |= 0xFF;			//enable PB0-PB7 as output
	PORTC |= (0 << PC0);	//initialize PC0 to 0
	PORTD = 0x00;			//initialize binary counter to 0
	
	PCICR |= (1 << PCIE1);	//change on enabled pin on PCINT[14:8] will cause interrupt
	PCIFR |= (1 << PCIF1);	//PCIF1 becomes set on logic change in PCINT[14:8]
	PCMSK1 |= (1 << PCINT8);//pin change interrupt enabled on PCINT8 (PC0)
	
	sei();					//set interrupts

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
		}
	}
}

ISR (PCINT1_vect) //PC0 in the PCINT1_vect
{
	static int count = 0;	//used to count cycles
	if (PORTC & (1 << 0))	//if PC0 is set
	{
		count++;
		if (count % 5 == 0)				//for every 5th count
		{
			PORTC ^= (1 << PC5);			//toggle PC5
		}
		
		if (count % 10 == 0)				//for every 10th count
		{
			PORTC ^= (1 << PC4);			//toggle PC4
		}
	}
	return;
}

