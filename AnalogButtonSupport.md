# Introduction #

As you may know, the PS3 has support for analog buttons for all of the buttons.  In the stock code, we don't support those buttons.  Right now, the stock code simply sets the analog button values to 'full on' when pressed, and 'full off' when released.

If there's demand for it, we're happy to put together some code that supports it.  Right now, we don't feel like it's a good tradeoff between added complexity vs. added functionality, and our design goal is to make UnoJoy as simple to use as possible.  If you want to extend it for your own purposes, here's how you'll need to change things, and feel free to send a message to us if you want some help!

# If you want to have analog button support #

The relevant sections of code you'll want to change are mostly in the the ATmega8u2 code project.  To work with that, I highly recommend AVR Studio 5, because it's awesome and should involve zero setup on your part to set up and compile the code.  We're all about ease of use around here.

You'll need to muck around with:

usb\_gamepad.c - You'll need to make changes in the sendPS3Data function

dataForController\_t.h - You'll need to add in data members to hold the analog button data

UnoJoy.c - You'll need to add code to get that new data from the Arduino. We communicate the dataForController\_t by sending it one byte at a time - the host requests which byte it wants, and the Arduino responds with the correct byte.  So, depending on how you structure your new fields, you'll need to add the communications step for them in the code.

Back on the Arduino side, you'll need to customize the UnoJoy.h file to use your modified dataForController\_t type that has the new fields for analog button data.

# Rationale #

The idea behind this is threefold:
1. Not many games really use pressure sensitive buttons to begin with
2. Adding in the extra data pretty much quadruples the size of the data we're sending back and forth
3. Having manual pressure data adds extra work for users.

The biggest factor is part number 3 - either we encourage people who want to just use digital buttons to also manually set the pressure for every button press they want to use, or we don't really tell them that, and then have the controller not work mysteriously for some games but not others.  From a usability standpoint, we thought that this added potential for confusion wasn't worth it, because of point 1.

Point 2 is a lesser concern, but still, adding the data for each button would nearly quadruple the amount of data we were pushing.  This isn't so much of a technical problem as a usability problem - if we make the dataForControl\_t struct 4 times larger, it makes reading through the library that much harder to do, and it's already probably longer than is user-friendly.