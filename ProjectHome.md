# UnoJoy! #
### Want to make video game controllers? You're in the right place. ###

UnoJoy lets you take a regular Arduino Uno and turn it into a native USB game controller, compatible with Windows, OSX, and PlayStation 3 (including Home Button support!).

Making cool stuff with UnoJoy?  We'd love to hear about it! Check out our project blog for more details, and we'd love to feature your stuff there!
http://unojoy.tumblr.com

### How It Works ###
UnoJoy is a combination of a library for Arduino and a special firmware file for the communication chip on the Arduino. In order to make your own controller, you'll:

  1. Install the drivers for the communication chip bootloader
  1. In Arduino, use the library to make your own controller interactions, mapping whatever inputs and calculations you want to the buttons and sticks of a PS3 controller.
  1. Use the included testing application to easily test your controller while it's still in Arduino mode.
  1. Use the simple included tools to re-flash the Arduino's communications chip with the special firmware
  1. Plug it into your PC/Mac/PS3 and play!

For more information, check out the [Getting Started page](GettingStarted.md)

### Totally Reversible ###
The firmware flashing tools are super easy to use, and it's easy to turn your UnoJoy project back into a regular Arduino at any time!

So check out the downloads section for a total release, or download the source repository!