# Introduction #

So, super sweet, there's an API in development for accessing joystick data in the web browser in Javascript. Right now, it's only implemented in Chrome and the development builds of Firefox, though, so be aware. Moreover, it's not painless on Windows.

# OSX #

It just works. Go Apple!

# Windows #

Ugh. Currently, the gamepad API in Windows uses the XInput specification, which I personally think is kinda a disaster, and I don't know how to, or if it's even possible, for UnoJoy! to show up as an XInput device without  driver, and driverless installs are really important to me. Hopefully, this will change, and they'll support DirectInput as well, since that's waaaay more flexible.

Until then, the way to get UnoJoy to work is to download this:

http://code.google.com/p/x360ce/

and then add the .exe to your **browser's** directory (so like, Program Files/Google/Chrome), run it, get the controller set up the way you want, then close the program and open Chrome (or Firefox) and it should work.