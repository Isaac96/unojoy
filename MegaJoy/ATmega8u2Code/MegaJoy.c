/* UnoJoy.c
 * Copyright (C) 2012 Alan Chatham <alan@openchord.org>
 * Made in conjunction with the RMIT Exertion Games Lab
 *
 * Based on works by:
 *   Josh Kropf <http://git.slashdev.ca/ps3-teensy-hid>
 *   grunskis <http://github.com/grunskis/gamepad>
 *   Toodles <http://forums.shoryuken.com/showthread.php?t=131230>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/* Keyboard example for Teensy USB Development Board
 * http://www.pjrc.com/teensy/usb_keyboard.html
 * Copyright (c) 2008 PJRC.COM, LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


#include <avr/io.h>
#include <util/delay.h>
#include <avr/wdt.h>
#include <avr/eeprom.h>
#include <avr/interrupt.h>
#include "dataForMegaController_t.h"
#include "usb_gamepad.h"

#define RXLED 4
#define TXLED 5

#define CPU_PRESCALE(n)	(CLKPR = 0x80, CLKPR = (n))

// This sets up an empty controller data packet and sends it out
//  to all the controllers attached.
void setControllersToZero(void){
	dataForMegaController_t emptyData;
	for (int i = 0; i < BUTTON_ARRAY_LENGTH; i++)
		emptyData.buttonArray[i] = 0;
	emptyData.leftStickX = 128;
	emptyData.leftStickY = 128;
	emptyData.rightStickX = 128;
	emptyData.rightStickY = 128;
	emptyData.stick3X = 128;
	emptyData.stick3Y = 128;
	sendControllerDataViaUSB(emptyData, 0);
	sendControllerDataViaUSB(emptyData, 1);
}

// Initializes the USART to receive and transmit,
//  takes in a value you can find in the datasheet
//  based on desired communication and clock speeds
void USART_Init(uint16_t baudSetting){
	// Set baud rate
	UBRR1 = baudSetting;
	// Enable receiver and transmitter
	UCSR1B = (1<<RXEN1)|(1<<TXEN1);
	// Set frame format: 8data, 1stop bit
	UCSR1C = (1<<UCSZ10)|(1<<UCSZ11);	
}

// This reads the USART serial port, returning any data that's in the
//  buffer, or a guaranteed zero if it took longer than timeout ms
//  Input: uint_16 timeout - milliseconds to wait for data before timing out
unsigned char serialRead( uint16_t timeout ){
	// Wait for data to be received 
	while ( !(UCSR1A & (1<<RXC1)) ){
		_delay_ms(1);
		timeout--;
		if (timeout == 0){
			return 0b0;
		}			
	}	
	// Get and return received data from buffer 
	return UDR1;
}

// This sends out a byte of data via the USART.
void serialWrite( unsigned char data )
{
	// Wait for empty transmit buffer
	while ( !( UCSR1A & (1<<UDRE1)) ){
	}	
	// Put data into buffer, sends the data
	UDR1 = data;
}

void flushSerialRead()
{
	unsigned char dummy;
	while ( UCSR1A & (1<<RXC1) )
		dummy = UDR1;
}

// This turns on one of the LEDs hooked up to the chip
void LEDon(char ledNumber){
	DDRD |= 1 << ledNumber;
	PORTD &= ~(1 << ledNumber);
}

// And this turns it off
void LEDoff(char ledNumber){
	DDRD &= ~(1 << ledNumber);
	PORTD |= 1 << ledNumber;
}

int main(void) {
	// Make sure our watchdog timer is disabled!
	wdt_reset(); 
	MCUSR &= ~(1 << WDRF); 
	wdt_disable();

	// Start up the USART for serial communications
	// 25 corresponds to 38400 baud - see datasheet for more values
	USART_Init(25);// 103 corresponds to 9600, 8 corresponds to 115200 baud, 3 for 250000
	
	// set the prescale for the USB for our 16 MHz clock
	CPU_PRESCALE(0);

	// Initialize our USB connection
	usb_init();
	while (!usb_configured()){
		LEDon(TXLED);
		_delay_ms(50);
		LEDoff(TXLED);
		_delay_ms(50);
	} // wait

	// Wait an extra second for the PC's operating system to load drivers
	// and do whatever it does to actually be ready for input
	// This wait also gives the Arduino bootloader time to timeout,
	//  so the serial data you'll be properly aligned.
	_delay_ms(500);
	dataForMegaController_t dataToSend;

	while (1) {
		// Delay so we're not going too fast
		_delay_ms(10);
		
        // We get our data from the ATmega328p by writing which byte we
        //  want from the dataForController_t, and then wait for the
        //  ATmega328p to send that back to us.
        // The serialRead(number) function reads the serial port, and the
        //  number is a timeout (in ms) so if there's a transmission error,
        //  we don't stall forever.
		LEDon(TXLED);
		flushSerialRead();
		
		for (int i = 0; i < BUTTON_ARRAY_LENGTH; i++){
			dataToSend.buttonArray[i] = 0;	
		}
		//for (int i = 3; i < 6; i++){
		//	serialWrite(i);
		//	dataToSend.buttonArray[i] = serialRead(25);
		//}			
		serialWrite(0);
		dataToSend.buttonArray[0] = serialRead(25);
		
		serialWrite(1);
		dataToSend.buttonArray[4] = serialRead(25);
		
		serialWrite(2);
		dataToSend.buttonArray[3] = serialRead(25);
		
		serialWrite(3);
		//serialWrite(BUTTON_ARRAY_LENGTH);
		dataToSend.leftStickX = serialRead(25);
        
		serialWrite(4);
		//serialWrite(BUTTON_ARRAY_LENGTH + 1);
		dataToSend.leftStickY = serialRead(25);
        
		serialWrite(5);
		//serialWrite(BUTTON_ARRAY_LENGTH + 2);
		dataToSend.rightStickX = serialRead(25);
        
		//serialWrite(BUTTON_ARRAY_LENGTH + 3);
		serialWrite(6);
		dataToSend.rightStickY= serialRead(25);
		
		// FIX THESE LATER TO ACTUALLY READ IN THE DATA
		serialWrite(5);
		dataToSend.stick3X= serialRead(25);
		
		serialWrite(6);
		dataToSend.stick3Y= serialRead(25);
		
		// Communication with the Arduino chip is over here
		LEDoff(TXLED);	
        dataToSend.dpadUpOn = 0;
        dataToSend.dpadDownOn = 0;
        dataToSend.dpadLeftOn = 0;
        dataToSend.dpadRightOn = 0;
        // Finally, we send the data out via the USB port
		sendControllerDataViaUSB(dataToSend, 1);	
		_delay_ms(10);
		sendControllerDataViaUSB(dataToSend, 2);
	}
}