# Introduction #

On its own, UnoJoy will show up to your computer as a joystick with 4 analog axes, an 8 directional hat switch, and 13 digital buttons.  This corresponds with the basic buttons of a PS3 controller.  However, you can

# You will need #

Right now, this walkthrough assumes that you are using Windows.  I'm using Atmel Studio (formerly AVR Studio) for developing, since it's free and awesome, so you should go download that here: http://www.atmel.com/tools/ATMELSTUDIO.aspx

Otherwise on Windows, if you love the command line, go get WinAVR.

It's totally possible to do this on OSX or Linux, but I don't know those toolchains, and I hate the command line, so I'm not particularly motivated to learn them.  However, the awesome folks at Objective Development have a nice installer which will get you all the tools here: http://www.obdev.at/products/crosspack/index.html

# What we'll be doing - A brief, incomplete rundown of USB HID devices #

USB is a fairly complicated thing.  Rather than just a dumb communication pathway, it's a multi-layered protocol that does a bunch of handshaking and negotiation that tells the host (your PC) what the device does and the data it will send during a process called **enumeration**.  USB devices are divided into **classes**, and different classes go through different enumeration processes. UnoJoy is a Human Interface Device, or HID, class device, and that means it goes through a very specific process with a rigidly established format.


Basically, when you connect your HID device to your computer, the computer asks the device what it does and what the format of the data will be in.  The device responds to that request with an **HID report descriptor**.  The HID report descriptor tells the computer the shape and size of the data it will be sending, and what part of the data packet corresponds to what desired input.  So, in order to add more buttons or axes, we need to:
  * Change the report descriptor
  * Change the data that gets sent

# How we do that #

To do this, we will need to modify the following files in the _UnoJoy/ATmega8u2_ directory:
  * usb\_gamepad.c
  * usb\_gamepad.h

## usb\_gamepad.c ##

Here's where the HID Report Descriptor is contained, starting down at line 130.  It looks like this:
```
static const uint8_t PROGMEM gamepad_hid_report_desc[] = {
	0x05, 0x01,        // USAGE_PAGE (Generic Desktop)
	0x09, 0x05,        // USAGE (Gamepad)
	0xa1, 0x01,        // COLLECTION (Application)
	0x15, 0x00,        //   LOGICAL_MINIMUM (0)
	0x25, 0x01,        //   LOGICAL_MAXIMUM (1)
```

The HID report descriptor is a big list of information outlining what sort of data the USB device will be sending your computer.  It consists of a bunch of (usually) 2 byte chunks, with the first byte being a command and the second byte being an input to that command.  Each line has been commented, so it should be pretty easy to figure out what's going on.

The meat of our report descriptor is here, starting at line 133:
```
        ...
	0xa1, 0x01,        // COLLECTION (Application)
	0x15, 0x00,        //   LOGICAL_MINIMUM (0)
	0x25, 0x01,        //   LOGICAL_MAXIMUM (1)
	0x35, 0x00,        //   PHYSICAL_MINIMUM (0)
	0x45, 0x01,        //   PHYSICAL_MAXIMUM (1)
	0x75, 0x01,        //   REPORT_SIZE (1)
	0x95, 0x0d,        //   REPORT_COUNT (13)
	0x05, 0x09,        //   USAGE_PAGE (Button)
	0x19, 0x01,        //   USAGE_MINIMUM (Button 1)
	0x29, 0x0d,        //   USAGE_MAXIMUM (Button 13)
	0x81, 0x02,        //   INPUT (Data,Var,Abs)
	0x95, 0x03,        //   REPORT_COUNT (3)
	0x81, 0x01,        //   INPUT (Cnst,Ary,Abs)
	0x05, 0x01,        //   USAGE_PAGE (Generic Desktop)
	0x25, 0x07,        //   LOGICAL_MAXIMUM (7)
	0x46, 0x3b, 0x01,  //   PHYSICAL_MAXIMUM (315)
	0x75, 0x04,        //   REPORT_SIZE (4)
	0x95, 0x01,        //   REPORT_COUNT (1)
	0x65, 0x14,        //   UNIT (Eng Rot:Angular Pos)
	0x09, 0x39,        //   USAGE (Hat switch)
	0x81, 0x42,        //   INPUT (Data,Var,Abs,Null)
	0x65, 0x00,        //   UNIT (None)
	0x95, 0x01,        //   REPORT_COUNT (1)
	0x81, 0x01,        //   INPUT (Cnst,Ary,Abs)
	0x26, 0xff, 0x00,  //   LOGICAL_MAXIMUM (255)
	0x46, 0xff, 0x00,  //   PHYSICAL_MAXIMUM (255)
	0x09, 0x30,        //   USAGE (X)
	0x09, 0x31,        //   USAGE (Y)
	0x09, 0x32,        //   USAGE (Z)
	0x09, 0x35,        //   USAGE (Rz)
	0x75, 0x08,        //   REPORT_SIZE (8)
	0x95, 0x04,        //   REPORT_COUNT (4)
	0x81, 0x02,        //   INPUT (Data,Var,Abs)
        ...
```

Now, this looks like a lot, but we'll break it down.  The overall pattern for each input block goes, "Declare the range of values the input will report, Declare how many bits each of this type of input takes, Declare how many of this type of input you have, Declare how this input is to be interpreted by the computer, and finally ends the block with the INPUT command.  So, for example, declaring the buttons happens here:
```
	0x15, 0x00,  //   LOGICAL_MINIMUM (0) Button gives values from
	0x25, 0x01,  //   LOGICAL_MAXIMUM (1) 0 to 1
	0x35, 0x00,  //   PHYSICAL_MINIMUM (0) Physical report is optional,
	0x45, 0x01,  //   PHYSICAL_MAXIMUM (1) but in real life, buttons can be pressed or unpressed
	0x75, 0x01,  //   REPORT_SIZE (1)  Each button has 1 bit of data
	0x95, 0x0d,  //   REPORT_COUNT (13) And there are 13 buttons
	0x05, 0x09,  //   USAGE_PAGE (Button) Tell the PC that these inputs are of the standard button type
	0x19, 0x01,  //   USAGE_MINIMUM (Button 1) And that they correspond to 
	0x29, 0x0d,  //   USAGE_MAXIMUM (Button 13) buttons 1 through 13
	0x81, 0x02,  //   INPUT (Data,Var,Abs) And actually add the button data to the report packet

        // This here is actually padding - we have 3 more fake buttons
        // that just bring our total to 16, so we have a packet that has
        // an even 2 bytes of button data
	0x95, 0x03,        //   REPORT_COUNT (3) // Add three more report entities - the size of 1 bit is carried over from the previous REPORT_SIZE (1) command
	0x81, 0x01,        //   INPUT (Cnst,Ary,Abs) // Send constant data for these
```

So, if we wanted to add another button, we would change both REPORT\_COUNT values to say REPORT\_COUNT (14) and REPORT\_COUNT (2) (in order to keep the button data 16 bits wide, and change the USAGE\_MAXIMUM to 14 as well, to add a 14th button on the PC side, making it look like this:
```
	0x75, 0x01,  //   REPORT_SIZE (1)  
	0x95, 0x0e,  //   REPORT_COUNT (14) - Notice the numbers went from 0x95, 0x0d, to 0x95, 0x0e, (we're using hexadecimal)
	0x05, 0x09,  //   USAGE_PAGE (Button)
	0x19, 0x01,  //   USAGE_MINIMUM (Button 1) 
	0x29, 0x0d,  //   USAGE_MAXIMUM (Button 14)- Notice the numbers went from 0x29, 0x0d, to 0x29, 0x0e, (we're using hexadecimal)
	0x81, 0x02,  //   INPUT (Data,Var,Abs)
	0x95, 0x02,        //   REPORT_COUNT (2) - Notice the numbers went from 0x95, 0x03, to 0x95, 0x02,
	0x81, 0x01,        //   INPUT (Cnst,Ary,Abs) 
```

The axes work the same way, and the report descriptor bit for them looks like this:
```
	0x26, 0xff, 0x00,  //   LOGICAL_MAXIMUM (255)
	0x46, 0xff, 0x00,  //   PHYSICAL_MAXIMUM (255)
	0x09, 0x30,        //   USAGE (X)
	0x09, 0x31,        //   USAGE (Y)
	0x09, 0x32,        //   USAGE (Z)
	0x09, 0x35,        //   USAGE (Rz)
	0x75, 0x08,        //   REPORT_SIZE (8)
	0x95, 0x04,        //   REPORT_COUNT (4)
	0x81, 0x02,        //   INPUT (Data,Var,Abs)
```

Again, we're defining the logical and physical characteristics of the inputs, then telling the computer how they're used with the USAGE commands, then telling the computer how big each chunk of data is (8 bytes) and how many chunks we're sending (4).  If you want to add, say, 2 more axes, I would add in the Rx and Ry (X and Y rotation) like this:
```
	0x26, 0xff, 0x00,  //   LOGICAL_MAXIMUM (255)
	0x46, 0xff, 0x00,  //   PHYSICAL_MAXIMUM (255)
	0x09, 0x30,        //   USAGE (X)
	0x09, 0x31,        //   USAGE (Y)
	0x09, 0x32,        //   USAGE (Z)
	0x09, 0x33,        //   USAGE (Rx) - New!
	0x09, 0x34,        //   USAGE (Ry) - Sexy!
	0x09, 0x35,        //   USAGE (Rz)
	0x75, 0x08,        //   REPORT_SIZE (8)
	0x95, 0x06,        //   REPORT_COUNT (6) Note - this changed from 4
	0x81, 0x02,        //   INPUT (Data,Var,Abs)
```

You can look up the exact usage codes here http://www.usb.org/developers/devclass_docs/Hut1_11.pdf - the relevant ones are under the Generic Desktop page for our purposes.

Notice, after the axes, we have a bunch of other stuff we're sending, most of it marked unknown.  All of that stuff is in 'Vendor Defined' blocks, and it contains the analog button data and likely the SIXAXIS motion control data.  However, since it's all in vendor defined blocks, the basic Windows driver will ignore all that data.

HOWEVER, we're not done yet.  We've only so far told the PC that we're going to send it different data - we haven't yet set things up to actually send it.  We'll make those changes in...

## usb\_gamepad.h ##

Whenever UnoJoy receives a request for USB data, it responds by sending out the contents of a gamepad\_data\_t struct.  If the size of the data contained in this struct doesn't match up with the amount of data the HID report descriptor says it will be sending, then the controller won't work.  So, now that we've changed the HID report descriptor to say that we've got more data, we need to actually send that new data, so we need to modify our gamepad\_data\_t definition.  Fortunately, that's easy.  The definition looks like this:

```
typedef struct {
	// digital buttons, 0 = off, 1 = on

	uint8_t square_btn : 1;
	uint8_t cross_btn : 1;
	uint8_t circle_btn : 1;
	uint8_t triangle_btn : 1;

        ... a bunch of button and axis definitions ...
	uint8_t l2_axis;
	uint8_t r2_axis;
} gamepad_state_t;
```

Things you may not have seen before:
  * uint8\_t - this is just a way to say, 'unsigned integer, 8 bits long'.  We use this to know precisely what values we'll have, since int and char can be confusing (int is 16 bits in AVR, but 32 bits in most other languages, etc.)
  * uint8\_t variableName : 1; - This is known as bit packing - we're declaring a field in our struct with a name, but telling the compiler that this field is only 1 bit wide - perfect for a button.  This way, we can store 8 buttons in a single byte, saving a lot of bandwidth in our communication.
  * uint8\_t : 3; - Like above, this is also bit packing.  However, this is just unused padding we've added after the buttons to align our button block into 8 bit blocks.  We saw this before in the HID report descriptor, when we added in the same number of padding input blocks.

Anyhow, since we altered the report descriptor, we need to change our gamepad\_state\_t to match that. Therefore, we'll need to add an extra button and two extra axes, here:

```
	uint8_t ps_btn : 1;
	uint8_t new_btn : 1; // Here's our new button
	uint8_t : 2 // changed from uint8_t : 3;
```

and here:

```

	uint8_t l_x_axis;
	uint8_t l_y_axis;
	uint8_t r_x_axis;
	uint8_t r_y_axis;
        uint8_t new_axis;  // Yay, added in a new axis
	uint8_t newer_axis; // Here too!
	uint8_t unknown[4];
```

Cool!  Now your joystick, when you compile, re-flash, then re-plug in your controller, should now show you a joystick with 14 buttons and 6 axes!  Of course, those extra inputs don't do anything yet.  We need to go back to...

## usb\_gamepad.c, round 2 ##

Now, we need to actually let you update the new controller data.  That happens in the **sendPS3Data(dataForController\_t btnList)** function at line 353.  Now, you have two options here - you can either modify the function to take in the new data as new arguments, or you can modify the dataForController\_t struct in dataForController\_t.h


## Troubleshooting (Windows) ##

If you plug the controller in and it shows up as a joystick, but then it's not listed when you go to Game Controller Settings, then you've probably got a mismatch between the length of your HID report descriptor and the size of the struct you're sending over USB. Check if you have any extra or missing buttons or padding.