# Introduction #

I really don't know much about Linux at all, so I will start off with the caveat that Linux is not one of the primary platforms for UnoJoy, and I'm not really in a position to offer any real support for it.  I've also heard that joystick support is hit or miss for different games/programs on Linux, and I really can't help you with any problems you have with that.

However, UnoJoy will show up to Linux as a video game controller, if you have the proper packages installed. Additionally, the toolchain for programming everything should work under Linux as well.  That said, I've also only tested this out on a current copy of Ubuntu running on a 2 year old Dell laptop, so your mileage may vary depending on your kernel, package manager, hardware, etc.

# The toolchain #

You'll need Arduino, as well as dfu-programmer.  Get Arduino from your package manager, but dfu-programmer doesn't work with the Arduino [R3](https://code.google.com/p/unojoy/source/detail?r=3), so you'll want to download the OSX-dfu-programmer-binary.zip file from the download page, extract that, then compile that from the source code included if you can.  If you can't, the dfu-programmer application you install from your package manager will work for the [R1](https://code.google.com/p/unojoy/source/detail?r=1) and [R2](https://code.google.com/p/unojoy/source/detail?r=2) Arduinos.

For flashing the communications chip with dfu-programmer, you'll need to navigate to the UnoJoy/ATmega8u2Code/HexFiles folder and use the commands:

(for [R1](https://code.google.com/p/unojoy/source/detail?r=1) and [R2](https://code.google.com/p/unojoy/source/detail?r=2))

`dfu-programmer atmega8u2 flash UnoJoy.hex `

(for [R3](https://code.google.com/p/unojoy/source/detail?r=3))

`dfu-programmer atmega16u2 flash UnoJoy.hex`

Replace UnoJoy.hex with Arduino-usbserial-uno.hex to turn your Arduino back into an Arduino

# How to get UnoJoy set up, if it's already been programmed #

After setting up the Arduino with UnoJoy, you'll need to to grab the following packages from Synaptic Package Manager - the easy way to find them is by filtering with 'joystick'

  * joystick
  * xserver-xorg-input-joystick
  * jstest-gtk

Once you have these packages installed, you should be able to plug in UnoJoy and test it out with jstest-gtk!