// Brickbreaker code
// Breaking & Making Workshop
// Calvert Co. Public Library
// Spring 2015
// Prof. Garrison LeMasters
// Georgetown University
// 
// Code licensed under Creative Commons 4.0
//

// Let's give the computer an overview
// of the kinds of variables we'll
// use and their names.  Variables are just
// letters or words that are assigned
// a specific value, as in algebra.  In
// programming, sometimes the variable
// names can grow very long.
// for example:
// x = 4; myX = 200; numberOfPassengers = 4;
//
// Here are examples of the kinds
// of variables we'll use:
//
// int = integer (-13,-1,0,88)
//
// float = floating point (decimal)
//       (-13.9, 0.440, 3.14159)
// 
// boolean = binary value
//      (always either True or False)
//
// color = special color code
//      (corresponds to HTML colors)
//      (see http://html-color-codes.com)
//      (colors are usually 6 characters long)
//      (and are preceded by a # sign)
//      (e.g., #FFCC33, or #000000, or #503090)
//      (read the code as 3 pairs of digits)
//      (e.g., #FF and #CC and #33)
//      (the first pair describes the amount of red,)
//      (the second pair the amount of green, the last)
//      (pair describes the amount of blue)

boolean blankBackground;
color backgroundColor;

int wallTopLocation;
int wallBottomLocation;
int wallLeftLocation;
int wallRightLocation;

int brickHeight;
int brickWidth;
int mortarThickness;

int totalBrickRows;
int totalBrickColumns;

int wallHeight;
int wallWidth;

// The next few items are special kinds of variables
// that you build by hand, instead of relying on the
// ones that come with Processing.  Here, I've
// built one called "paddle," one called "brick," and
// one called "ball".  Each of these is an example
// of an "object."  Programmers use objects all the time.
// Think of an object as a magic box.  If you give it the
// right information, it will open up and give you 
// something in return.  But if you give it the wrong
// information, who knows what will happen?

Brick[][] gameBrick;
Ball gameBall;


///////////////////////////////////////////////////////////////////
//
// We've finished naming all of our variables for the computer.
//
// Now we actually start building the playing field on the screen.
//
///////////////////////////////////////////////////////////////////

// when a line starts with "void", it indicates a new set
// of instructions.  Here is a function called "setup()".
// Processing ALWAYS DOES EVERYTHING IN THE SETUP FIRST.
// After that, it NEVER looks at the setup() function again.

void setup() {

  // first, build a window.
  // make it 800 pixels (dots) wide by 600 pixels high
  size(500, 500);

  blankBackground=false;
  backgroundColor = #DDDDDD; // light grey
  wallTopLocation = 60;  // 60 pixels from the top of the window
  totalBrickRows = 5;
  brickWidth = 21;
  brickHeight = 21;

  // instead of just saying "make the wall 200 pixels high,"
  // I describe the height with other variables.  This makes
  // it much easier on me later.  If I change the number
  // of rows of bricks, for example, the wall height will
  // AUTOMAGICALLY shrink.
  //
  // Don't be intimidated by this stuff.
  // It doesn't have to make sense at first.
  // Sense comes later.
  //
  wallHeight = (brickHeight+mortarThickness)*totalBrickRows;
  wallWidth = int(width/(brickWidth+mortarThickness))*(brickWidth+mortarThickness);
  totalBrickColumns = wallWidth/(brickWidth+mortarThickness);
  wallLeftLocation = (width - wallWidth)/2;
  wallRightLocation = wallLeftLocation+wallWidth;
  wallBottomLocation = wallTopLocation+(totalBrickRows*(brickHeight+mortarThickness));
  print(wallLeftLocation,wallRightLocation,wallBottomLocation);
  // here, we're figuring out how many bricks across by how many bricks down we need
  
  gameBrick = new Brick[totalBrickColumns][totalBrickRows];

  // now we go build those bricks, one by one.

  doBrickInitialize();
  
  // let's finish by building our brick-breaking ball
  
  gameBall = new Ball(width/2, height/1.5, 11, 11, -1.3333, -0.43, #FFCC33);
  
  // now clear the window out to get started!
  
  background(backgroundColor);
  
}


// This is it: The "draw()" loop
// is the magic part of this language.  
// Processing repeats this loop over and over,
// about 60 times per second.  Very fast!
// It will repeat 60x / second until
// you stop the program (or until it crashes)!

void draw() {
  if (blankBackground == true) {
    background(backgroundColor);
  } else {
    fill(backgroundColor,10); // make things almost transparent
    rect(0,0,width,height); // fill screen w/ almost transparent giant rectangle
  }
    
  doDrawBricks();
  doMoveBall();
}

// this function draws our wall
// it draws all the bricks in a single row,
// and then it moves down to the next row.

void doDrawBricks() {
  for (int y=0; y<totalBrickRows; y = y + 1) {
    for (int x=0; x<totalBrickColumns; x = x + 1) {

      // does our specific brick exist?

      if (gameBrick[x][y].exists == true) {
        if (doCollisionCheck(gameBrick[x][y].positionX, gameBrick[x][y].positionY)) {
          gameBrick[x][y].destroyBrick();
        } else {
          gameBrick[x][y].makeBrick();
        }
      }
    }
  }
}


void doMoveBall() {
  gameBall.doBoundaryCheck();
  gameBall.doMoveBall();
}

void doBrickInitialize() {
  for (int y=0; y<totalBrickRows; y = y + 1) {
    for (int x=0; x<totalBrickColumns; x = x + 1) {

      // where do these bricks sit on the screen?
      // we'll calculate their position
      // and call those positions "realX" and "realY"

      int realX = wallLeftLocation+((brickWidth+mortarThickness)*x);
      int realY = wallTopLocation+((brickHeight+mortarThickness)*y);

      // here's where we create each brick, and fill it up with information
      // about where it lives on the screen, its color, etc.

      gameBrick[x][y] = new Brick(realX, realY, brickWidth, brickHeight, #FFCC00, true);
    }
  }
}

boolean doCollisionCheck(float brickLeft, float brickTop) {

  //size up the brick's dimensions
  float brickRight = brickLeft+brickWidth;
  float brickBottom = brickTop+brickHeight;

  //get a single dot for X and Y
  //set our flags
  boolean ballBrick=false;
  boolean horiZone=false;

  // ugh.  Since our ball isn't just one pixel wide, but is 10 or so,
  // we have to adjust our calculations to check both the left side of the
  // ball AND the right side of the ball.

  for (int ballPixels = - 5; ballPixels < 6; ballPixels = ballPixels + 5) {

    float ballPositionX=(gameBall.positionX+(gameBall.wide*0.5))+ballPixels;
    float ballPositionY=(gameBall.positionY+(gameBall.high*0.5))+ballPixels;

    // is the ball in the same row as the brick?
    if (ballPositionY>brickTop && ballPositionY<brickBottom) {
      // It is!  Now look to see if it is in the same column as the brick?
      if (ballPositionX>brickLeft && ballPositionX<brickRight) {
        // A Hit!  A palpable hit!  Set the flag that tells the
        // computer "we've hit a brick, so get ready to break it."
        ballBrick=true;
      }
    }

    // here's where the computer looks to see what happened
    // when we ran all of those tests above.  We are trying
    // to figure out how the ball will bounce.

    if (ballBrick) {
      if (ballPositionY>brickTop+ballPixels && ballPositionY<brickBottom-ballPixels) {
        horiZone=true;
      }
      if (ballPositionX>brickLeft+ballPixels && ballPositionX<brickRight-ballPixels) {
        horiZone=false;
      }
    }
  }

  // Now we go ahead and set the ball to bounce the right direction.

  if (horiZone && ballBrick) {
    gameBall.horizontalbounce();
  } else if (ballBrick) {
    gameBall.verticalbounce();
  }
  return (ballBrick);
}

// Here is the custom cookie-cutter
// I wrote in order to build a paddle.
// This hand-made paddle has the following
// qualities:
// positionX, positionY, oldPositionX, oldPositionY,
// width, height;



// Here is where we build our ball object

class Ball {
  float positionX, positionY;
  int wide, high;
  float xVelocity, yVelocity;
  color ballColor;

  Ball (float tpositionX, float tpositionY, int wd, int hi, float txV, float tyV, color tcol) {
    positionX=tpositionX;
    positionY=tpositionY;
    high=hi;
    wide=wd;
    xVelocity=txV;
    yVelocity=tyV;
    ballColor=tcol;
  }

  void doMoveBall() {
    positionX = positionX + xVelocity; // calculate new x position of the ball
    positionY = positionY + yVelocity; // calculate new y position of the ball
    pushMatrix();
    fill(ballColor);
    translate(positionX, positionY);
    rect(0, 0, wide, high);
    popMatrix();
  }

  // did we hit a wall?  then reverse direction!

  void doBoundaryCheck() {
    if (positionX+1>=width-wide || positionX<=1) {
      xVelocity*=-1.0;
    }
    // did we hit the ceiling or the floor?  Reverse!
    if (positionY+1>=height-high || positionY<=1) {  
      yVelocity*=-1.0;
    }
  }

  void verticalbounce() {
    yVelocity = yVelocity * -1.0;
  }

  void horizontalbounce() {
    xVelocity = xVelocity * -1.0;
  }
}

// Here are the instructions on how to make a
// brick for our brick wall.  Each brick is unique.
// Each brick has the following qualities:
// positionX, positionY, width, and height;
// It also has a color;
// It also has a sort of "yes/no" checkbox
// that stores the answer to the question:
// "Is this brick alive or dead?" -- which is just
// another way of saying, did the ball hit this
// brick yet or not?  When the ball hits a brick,
// I change its "alive or dead?" value to dead.
// When a brick is "dead", the program knows not to 
// bother drawing it on the screen.

class Brick {
  int positionX, positionY, wide, high;
  color brickColor;
  boolean exists;

  Brick (int tpositionX, int tpositionY, int wd, int hi, color tcol, boolean toBe) {
    positionX=tpositionX;
    positionY=tpositionY;
    high=hi;
    wide=wd;
    brickColor=tcol;
    exists=toBe;
  }

  void makeBrick() {
    pushMatrix();
    fill(brickColor);
    translate(positionX, positionY);
    rect(0, 0, wide, high);
    popMatrix();
  }
  
  // if we need to kill a brick, we do it here!
  
  void destroyBrick() {
  // ha!  You no longer exist!
   exists = false;  
  }
  
  
}

