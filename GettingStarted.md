## Introduction ##

Welcome to UnoJoy!  This document is here to get you set up in the shortest amount of time possible. UnoJoy is kinda weird, since it's different than anything you've probably ever done on Arduino, since it's a two-step process - First, you have to upload code onto the Arduino like normal, but then you have to run a special program that changes the Arduino into a controller.  Here's how to do everything:

## Step 1: Put the test program onto your Arduino ##

From the UnoJoy folder, open the Arduino sketch in the UnoJoyArduinoSample folder.  Upload this code onto your Arduino.

## Step 2: Test the controller in Processing ##

From the UnoJoy folder, open the Processing sketch in the UnoJoyProcessingVisualizer.  Run this, and you should see that the controller has its joysticks in the upper left, and no buttons are pressed.  Connect pin 2 to ground, and you should see the Triangle button turn on.

## Step 3: Install the drivers for the DFU Bootloader ##

In the UnoJoy folder, there are driver installers appropriate to the OS you are running -

Windows - InstallUnoJoyDrivers.bat

OSX Lion - LionUnoJoyDrivers.pkg

OSX Snow Leopard - SnowLeopardUnoJoyDrivers.pkg

Then, with your Arduino plugged into your computer, connect the following two pins to put the Arduino into DFU mode:

http://wiki.unojoy.googlecode.com/hg/Images/ResetDFU.JPG

## Step 4: Re-flash the Arduino communications chip ##

On Windows, you will also need to download and install the Atmel FLIP tool - you can find it here:

http://www.atmel.com/tools/FLIP.aspx

Now that the drivers are installed, go back to the UnoJoy folder and run the TurnIntoAJoystick.bat(or .command) application.  Unplug and re-plug in your Arduino, and it should now show up to your system as a joystick!

To check out what your computer currently sees the Arduino as:

On Windows 7, you can check it out by going to

> Start->Devices and Printers

> In Arduino mode, it will appear as 'Arduino UNO (COM 23)'
> In DFU mode, it will appear as 'Arduino UNO DFU'
> In UnoJoy mode, it will appear at the top as 'UnoJoy Joystick'

On OSX, you should see it:

> Snow Leopard: Apple->About This Mac->More Info...->USB
> Lion: Apple->About This Mac->More Info...->System Report->USB

> You may need to refresh (command-R) to see it update.
> In Arduino mode, it will appear as 'Arduino UNO'
> In DFU mode, it will appear as 'Arduino UNO DFU'
> In UnoJoy mode, it will appear at the top as 'UnoJoy Joystick'

## Step 5: Start making your own controller ##

Now that you have a basic controller put together, you probably want to start changing it.  However, the Arduino can only take in new code when it's in Arduino mode. In order to put the Arduino back into Arduino mode, plug in the Arduino and put it back into DFU mode like you did in Step 3, then run the 'TurnIntoAnArduino.bat' or .command program.  Unplug and plug the Arduino back in, and it should show up as an Arduino again.  Then, the easiest way to develop your controller will be to follow the following steps:
  1. Change and Upload code to Arduino (Arduino mode)
  1. Open up UnoJoyProcessingVisualizer.exe (Arduino Mode)
  1. Test controller's functionality (Arduino mode)
  1. Repeat steps 1-3 until satisfied with your controller
  1. Change into UnoJoy then plug into PC (UnoJoy mode)
  1. Play games with your new controller