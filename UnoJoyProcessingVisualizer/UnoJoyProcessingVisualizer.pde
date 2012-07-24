import processing.serial.*;

// Game controller image
PImage controller;
int imageWidth = 516;
int imageHeight = 521;
Point offset = new Point( 40, 40 );

int stickIndicatorSize = 20;
int actionIndicatorSize = 35;
int functionIndicatorSize = 35;
int dpadIndicatorSize = 50;

int stickDiameter = int( 0.134 * imageWidth );

// Indicator positions
Point leftStickPos = new Point( 0.351*imageWidth + offset.x, 0.581*imageWidth + offset.y );
Point rightStickPos = new Point( 0.642*imageWidth + offset.x, 0.581*imageWidth + offset.y );

Point trianglePos = new Point( 0.795*imageWidth + offset.x, 0.357*imageWidth + offset.y );
Point circlePos = new Point( 0.868*imageWidth + offset.x, 0.430*imageWidth + offset.y );
Point squarePos = new Point( 0.721*imageWidth + offset.x, 0.430*imageWidth + offset.y );
Point crossPos = new Point( 0.795*imageWidth + offset.x, 0.504*imageWidth + offset.y );

Point l1Pos = new Point( 0.201*imageWidth + offset.x, 0.068*imageWidth + offset.y );
Point l2Pos = new Point( 0.201*imageWidth + offset.x, 0.156*imageWidth + offset.y );
Point l3Pos = new Point( leftStickPos.x,leftStickPos.y );

Point r1Pos = new Point( 0.795*imageWidth + offset.x, 0.068*imageWidth + offset.y );
Point r2Pos = new Point( 0.795*imageWidth + offset.x, 0.156*imageWidth + offset.y );
Point r3Pos = new Point( rightStickPos.x,rightStickPos.y );

Point selectPos = new Point( 0.405*imageWidth + offset.x, 0.446*imageWidth + offset.y );
Point startPos = new Point( 0.583*imageWidth + offset.x, 0.446*imageWidth + offset.y );
Point homePos = new Point( 0.502*imageWidth + offset.x, 0.518*imageWidth + offset.y );

Point dpadLeftPos = new Point( 0.130*imageWidth + offset.x, 0.426*imageWidth + offset.y );
Point dpadUpPos = new Point( 0.200*imageWidth + offset.x, 0.357*imageWidth + offset.y );
Point dpadRightPos = new Point( 0.270*imageWidth + offset.x, 0.427*imageWidth + offset.y );
Point dpadDownPos = new Point( 0.200*imageWidth + offset.x, 0.500*imageWidth + offset.y );

// joystick data
Point leftStickData = new Point( 128,128 );
Point rightStickData = new Point( 128,128 );

// Control flags
int triangleOn = 0;
int circleOn = 0;
int squareOn = 0;
int crossOn = 0;

int l1On = 0;
int l2On = 0;
int l3On = 0;

int r1On = 0;
int r2On = 0;
int r3On = 0;

int selectOn = 0;
int startOn = 0;
int homeOn = 0;

int dpadLeftOn = 0;
int dpadUpOn = 0;
int dpadRightOn = 0;
int dpadDownOn = 0;


int SerialPortLoaded = 0;
Serial SerialPort;

PFont font;

//
/// SETUP
//
void setup() {
  if (Serial.list().length > 0){
    SerialPortLoaded = 1;
    String portName = Serial.list()[0];
    println(portName);
    SerialPort = new Serial(this, portName, 38400);
  }
  font = loadFont("AngsanaNew-28.vlw");
  size( 600,600 );
  rectMode( CENTER );
  ellipseMode( CENTER );
  smooth();

  // load image
  controller = loadImage( "data/game_controller.png" );
  // We need to wait a bit, otherwise the Arduino
  //  won't be ready for serial data on OSX.
  //  delay() doesn't work in a setup function in
  //  Processing, so we do it the real way
  try {
   Thread.sleep(1000);
  } catch (InterruptedException e) { }
}


/**
 * DRAW
 */
 
  int counter = 0;
void draw() {
  // If the controller is connected,
  //  read the data in
  if (SerialPortLoaded == 1){
    readController();
  }

  background( 255 );
  image( controller, offset.x, offset.y );
  
  if(SerialPortLoaded == 0){
    textFont(font, 28);
    fill(250,0,0);
    text("Couldn't connect to the Arduino...", 175, 500);
  }
  
  
  noStroke();
  fill( 255, 0, 0, 100 );
    
  /// L & R BUTTONS ///
  if( l1On == 1 )
    ellipse( l1Pos.x, l1Pos.y, actionIndicatorSize, actionIndicatorSize );
  if( r1On == 1 )
    ellipse( r1Pos.x, r1Pos.y, actionIndicatorSize, actionIndicatorSize ); 
  if( l2On == 1 )
    ellipse( l2Pos.x, l2Pos.y, actionIndicatorSize, actionIndicatorSize );    
  if( r2On == 1 )
    ellipse( r2Pos.x, r2Pos.y, actionIndicatorSize, actionIndicatorSize ); 
  if( l3On == 1 )
    ellipse( l3Pos.x, l3Pos.y, stickDiameter, stickDiameter );
  if( r3On == 1 )
    ellipse( r3Pos.x, r3Pos.y, stickDiameter, stickDiameter ); 
//
  // STICKS //
  
  // LEFT
  
  strokeWeight( 1 );
  stroke( 255, 0, 0 );
  fill( 255,255,255, 100 );
  rect( leftStickPos.x, leftStickPos.y, stickDiameter, stickDiameter );
  
  //leftStickData.x = float(mouseX) / 600 * 255;
  //leftStickData.y = float(mouseY) / 600 * 255;
  
  stroke( 255, 0, 0 );
  strokeWeight( 2 );  
  
  line( leftStickPos.x + stickDiameter * (leftStickData.x-128)/255 - stickIndicatorSize/2, 
        leftStickPos.y + stickDiameter * (leftStickData.y-128)/255, 
        leftStickPos.x + stickDiameter * (leftStickData.x-128)/255 + stickIndicatorSize/2, 
        leftStickPos.y + stickDiameter * (leftStickData.y-128)/255  );
  
  line( leftStickPos.x + stickDiameter * (leftStickData.x-128)/255, 
        leftStickPos.y + stickDiameter * (leftStickData.y-128)/255 - stickIndicatorSize/2, 
        leftStickPos.x + stickDiameter * (leftStickData.x-128)/255, 
        leftStickPos.y + stickDiameter * (leftStickData.y-128)/255 + stickIndicatorSize/2  );
  
  noStroke();
  fill( 255, 0, 0, 100 );
  
  ellipse( leftStickPos.x + stickDiameter * (leftStickData.x-128)/255, 
           leftStickPos.y + stickDiameter * (leftStickData.y-128)/255, 
           stickIndicatorSize/1.5, stickIndicatorSize/1.5 );
  
  // RIGHT
  
  strokeWeight( 1 );
  stroke( 255, 0, 0 );
  fill( 255,255,255, 100 );
  rect( rightStickPos.x, rightStickPos.y, stickDiameter, stickDiameter );
  
 // rightStickData.x = float(mouseX) / 600 * 255;
 // rightStickData.y = float(mouseY) / 600 * 255;
  
  stroke( 255, 0, 0 );
  strokeWeight( 2 );  
  
  line( rightStickPos.x + stickDiameter * (rightStickData.x-128)/255 - stickIndicatorSize/2, 
        rightStickPos.y + stickDiameter * (rightStickData.y-128)/255, 
        rightStickPos.x + stickDiameter * (rightStickData.x-128)/255 + stickIndicatorSize/2, 
        rightStickPos.y + stickDiameter * (rightStickData.y-128)/255  );
  
  line( rightStickPos.x + stickDiameter * (rightStickData.x-128)/255, 
        rightStickPos.y + stickDiameter * (rightStickData.y-128)/255 - stickIndicatorSize/2, 
        rightStickPos.x + stickDiameter * (rightStickData.x-128)/255, 
        rightStickPos.y + stickDiameter * (rightStickData.y-128)/255 + stickIndicatorSize/2  );
  
  noStroke();
  fill( 255, 0, 0, 100 );
  
  ellipse( rightStickPos.x + stickDiameter * (rightStickData.x-128)/255, 
           rightStickPos.y + stickDiameter * (rightStickData.y-128)/255, 
           stickIndicatorSize/1.5, stickIndicatorSize/1.5 );
  
  /// ACTION BUTTONS ***
  // triangle
  if( triangleOn == 1 )
    ellipse( trianglePos.x, trianglePos.y, actionIndicatorSize, actionIndicatorSize );
  // circle
  if( circleOn == 1 )
    ellipse( circlePos.x, circlePos.y, actionIndicatorSize, actionIndicatorSize );
  // square
  if( squareOn == 1 )
    ellipse( squarePos.x, squarePos.y, actionIndicatorSize, actionIndicatorSize );
  // cross
  if( crossOn == 1 )
    ellipse( crossPos.x, crossPos.y, actionIndicatorSize, actionIndicatorSize );
  
  // SPECIAL BUTTONS //
  
  // select
  if( selectOn == 1 )
    ellipse( selectPos.x, selectPos.y, functionIndicatorSize, functionIndicatorSize );
    
  // start
  if( startOn == 1 )
    ellipse( startPos.x, startPos.y, functionIndicatorSize, functionIndicatorSize );

   // home
  if( homeOn == 1 )
    ellipse( homePos.x, homePos.y, functionIndicatorSize, functionIndicatorSize );
    
    
  // DPAD BUTTONS //
  
  // left
  if( dpadLeftOn == 1 )
    ellipse( dpadLeftPos.x, dpadLeftPos.y, dpadIndicatorSize, dpadIndicatorSize );
  
  // up
  if( dpadUpOn == 1 )
    ellipse( dpadUpPos.x, dpadUpPos.y, dpadIndicatorSize, dpadIndicatorSize );
    
  // right
  if( dpadRightOn == 1 )
    ellipse( dpadRightPos.x, dpadRightPos.y, dpadIndicatorSize, dpadIndicatorSize );
    
  // down
  if( dpadDownOn == 1 )
    ellipse( dpadDownPos.x, dpadDownPos.y, dpadIndicatorSize, dpadIndicatorSize );

}

// This waits 'timeout' ms for data from the serial port.
//  It returns the serial data if it didn't timeout,
//  and returns defaultValue if it did timeout.
// Using this prevents the serial port from holding
//  up the program in case of a transmission error.
int readSerialPort(int timeout, int defaultValue){
  while((SerialPort.available() == 0) && (timeout > 0)){
    //timeout--;
    delay(1);
  }
  if (timeout <= 0)
    return defaultValue;
  return SerialPort.read();
}

void readController(){
  SerialPort.clear();
  SerialPort.write(0);
  // Wait 25ms to get in data, or make these buttons zeroes
  int buttonData1 = readSerialPort(25, 0);
  
  SerialPort.write(1);
  // Wait 25ms to get in data, or make these buttons zeroes
  int buttonData2 = readSerialPort(25, 0);
  
  SerialPort.write(2);
  // Wait 25ms to get in data, or make these buttons zeroes
  int buttonData3 = readSerialPort(25, 0);
  
  SerialPort.write(3);
  // Wait 25ms to get in data, or make these buttons zeroes
  leftStickData.x = readSerialPort(25, 128);
  
  SerialPort.write(4);
  // Wait 25ms to get in data, or make these buttons zeroes
  leftStickData.y = readSerialPort(25, 128);
  
  SerialPort.write(5);
  // Wait 25ms to get in data, or make these buttons zeroes
  rightStickData.x = readSerialPort(25, 128);
  
  SerialPort.write(6);
  // Wait 25ms to get in data, or make these buttons zeroes
  rightStickData.y = readSerialPort(25, 128);
  
  // Now assign the buttons based on the data
  triangleOn = 1 & (buttonData1 >> 0);
  circleOn = 1 & (buttonData1 >> 1);
  squareOn = 1 & (buttonData1 >> 2);
  crossOn = 1 & (buttonData1 >> 3);
  l1On = 1 & (buttonData1 >> 4);
  l2On = 1 & (buttonData1 >> 5);
  l3On = 1 & (buttonData1 >> 6);
  r1On = 1 & (buttonData1 >> 7);
  		
  r2On = 1 & (buttonData2 >> 0);
  r3On = 1 & (buttonData2 >> 1);
  selectOn = 1 & (buttonData2 >> 2);
  startOn = 1 & (buttonData2 >> 3);
  homeOn = 1 & (buttonData2 >> 4);
  dpadLeftOn = 1 & (buttonData2 >> 5);
  dpadUpOn = 1 & (buttonData2 >> 6);
  dpadRightOn = 1 & (buttonData2 >> 7);
  
  dpadDownOn = 1 & (buttonData3 >> 0);
  
  
}

void turnAllOn() {
  
  triangleOn = 1;
  circleOn = 1;
  squareOn = 1;
  crossOn = 1;
  
  l1On = 1;
  l2On = 1;
  l3On = 1;
  
  r1On = 1;
  r2On = 1;
  r3On = 1;
  
  selectOn = 1;
  startOn = 1;
  homeOn = 1;
  
  dpadLeftOn = 1;
  dpadUpOn = 1;
  dpadRightOn = 1;
  dpadDownOn = 1;
}

void turnAllOff(){
  triangleOn = 0;
  circleOn = 0;
  squareOn = 0;
  crossOn = 0;
  
  l1On = 0;
  l2On = 0;
  l3On = 0;
  
  r1On = 0;
  r2On = 0;
  r3On = 0;
  
  selectOn = 0;
  startOn = 0;
  homeOn = 0;
  
  dpadLeftOn = 0;
  dpadUpOn = 0;
  dpadRightOn = 0;
  dpadDownOn = 0;
}


