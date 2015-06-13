# Introduction #

Hey there - so DoubleJoy is currently an experimental firmware that makes the Arduino Uno show up as TWO joysticks.  Hence the 'Double' part. We're working on it RIGHT NOW, so if you're looking at this page, congratulations! It's kind of a secret at the moment.

# Details #

So, we're still trying to iron everything out, but it should work pretty much the same as UnoJoy, the only real difference is now you have to set the data for two controllers, like:
```
   setControllerData(1, coolControllerData); // Sets the first controller
   setControllerData(2, suckyControllerData); // Sets the second controller
```

Let us know if you try it out!

# Also #
This doesn't seem to work in Linux.  It probably needs to have a driver written for it, so I don't expect to see that happen for a while, unfortunately...