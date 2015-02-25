// Breakout experiment (simplified 2015 Feb)
// March 6-18 2012 // November 2012

int scoreLocX=730;
int scoreLocY=41;
int scoreScore=0;
int zz;
int wallTop, wallLeft, wallBottom, wallRight;
int brickHeight = 15;
int mortar = 1;
int numBrickRows = 9;
int numBrickCols;
int brickWidth = 63;
int wallHeight, wallWidth;
int paddleUpLimit, paddleDownLimit;
color paddleColor;
float margeN=1.00;
float margeNy=3.00;

Brick[][] myBricks;
Ball myBalls;
Paddle myPaddle;

void setup() {
  size(800, 600);
  // myFont=loadFont("Helvetica-48.vlw");
  // textFont(myFont, 29);
  //myTexture=loadImage("paper.jpg");

  //ellipseMode(CORNER);
  //colorMode(HSB);
  //  frameRate(24);
  smooth();
  noStroke();
  paddleColor=#FFCC33;
  //  minim=new Minim(this);
  //  player=minim.loadFile("beep-7.wav");
  //player.play();
  wallTop = 60;
  wallHeight = (brickHeight+mortar)*numBrickRows;
  wallWidth = int(width/(brickWidth+mortar))*(brickWidth+mortar);
  numBrickCols = wallWidth/(brickWidth+mortar);
  wallLeft = (width - wallWidth)/2;
  wallRight = wallLeft+wallWidth;
  wallBottom = wallTop+(numBrickRows*(brickHeight+mortar));
  myBricks = new Brick[numBrickCols][numBrickRows];
  paddleUpLimit=int(height*0.50);
  paddleDownLimit=int(height*0.90);
  doBrickInit();
  myPaddle = new Paddle(width/2, int(height*0.75), width/2, int(height*0.75), brickWidth*2, int(brickHeight*0.50));
  myBalls = new Ball(width/2, height/1.5, 11, 11, -2.5, -2.85, #FFCC33);
}

void draw() {
  background(24);
  doDrawBricks();
  doMoveBall();
 // doScoreDraw();
}

void doDrawBricks() {
  for (int y=0; y<numBrickRows; y++) {
    for (int x=0; x<numBrickCols; x++) {
      if (myBricks[x][y].exists) {
        if (myBricks[x][y].descent !=0) {          
          myBricks[x][y].fallaway();
        } else
          if (dobrickbump(myBricks[x][y].posX, myBricks[x][y].posY)) {
          myBricks[x][y].destroy();
          scoreScore=scoreScore+5;
        } else {
          myBricks[x][y].make();
        }
      }
    }
  }
}

void doPaddleBusiness() {
  myPaddle.show();
  int tempY=int(myBalls.posY+int(myBalls.high*0.50));
  int tempX=int(myBalls.posX+int(myBalls.wide*0.50));
  if ((tempY > myPaddle.posY-margeN) && (tempY < myPaddle.posY+myPaddle.high+margeN)) {
    if ((tempX >= myPaddle.posX) && (tempX <= myPaddle.posX+myPaddle.wide)) {
      //      player.play();
      myBalls.verticalbounce();
    }
  }
}

void doMoveBall() {
  myBalls.boundarycheck();
  myBalls.makemove();
}

void doBrickInit() {
  for (int y=0; y<numBrickRows; y++) {
    for (int x=0; x<numBrickCols; x++) {
      int realX = wallLeft+((brickWidth+mortar)*x);
      int realY = wallTop+((brickHeight+mortar)*y);
      color brxCol = color(y*256/numBrickRows, 225, 250);
      myBricks[x][y] = new Brick(realX, realY, brickWidth, brickHeight, brxCol, true, 0.0, 0);
    }
  }
}

boolean dobrickbump(float brickLeft, float brickTop) {

  //size up the brick's dimensions
  float brickRight = brickLeft+brickWidth;
  float brickBottom = brickTop+brickHeight;

  //get a single dot for X and Y
  //set our flags
  boolean ballBrick=false;
  boolean horiZone=false;

  for (int shiftN=-5; shiftN<5; shiftN+=5) {

    float ballProxyX=(myBalls.posX+(myBalls.wide*0.5))+shiftN;
    float ballProxyY=(myBalls.posY+(myBalls.high*0.5))+shiftN;

    // in the row?
    if (ballProxyY>brickTop && ballProxyY<brickBottom) {
      // in the column?
      if (ballProxyX>brickLeft && ballProxyX<brickRight) {
        // then mark it as "within the brick"
        ballBrick=true;
      }
    }

    if (ballBrick) {
      if (ballProxyY>brickTop+margeN && ballProxyY<brickBottom-margeN) {
        horiZone=true;
      }
      if (ballProxyX>brickLeft+margeNy && ballProxyX<brickRight-margeNy) {
        horiZone=false; // check dead center 1ce instead of left AND right zones
      }
    }
  }
  if (horiZone && ballBrick) {
    myBalls.horizontalbounce();
  } else if (ballBrick) {
    myBalls.verticalbounce();
  }
  return (ballBrick);
}

void doScoreDraw() {
//  text(scoreScore, scoreLocX, scoreLocY);
}

void stop() {
  //  player.close();
  //  minim.stop();
  //  super.stop();
}


// paddle object

class Paddle {
  int posX, posY, oldX, oldY, wide, high;

  Paddle (int X, int Y, int oX, int oY, int wd, int hi) {
    posX=X;
    posY=Y;
    oldX=oX;
    oldY=oY;
    high=hi;
    wide=wd;
  }

  void show() {
    float targetX=map(mouseX, 0, width, 0, width-wide);
    float targetY=map(mouseY, 0, height, paddleUpLimit, paddleDownLimit);
    posX=oldX+int((targetX-oldX)*0.1);
    posY=oldY+int((targetY-oldY)*0.1);
    pushMatrix();
    fill(paddleColor);
    translate(posX, posY);
    rect(0, 0, wide, high);
    popMatrix();
    oldX=posX;
    oldY=posY;
  }
}

// ball object

class Ball {
  float posX, posY;
  int wide, high;
  float xVelocity, yVelocity;
  color col;

  Ball (float tposX, float tposY, int wd, int hi, float txV, float tyV, color tcol) {
    posX=tposX;
    posY=tposY;
    high=hi;
    wide=wd;
    xVelocity=txV;
    yVelocity=tyV;
    col=tcol;
  }

  void makemove() {

    posX+=xVelocity; // calculate new x position of the ball
    posY+=yVelocity; // calculate new y position of the ball
    pushMatrix();
    fill(col);
    translate(posX, posY);
    rect(0, 0, wide, high);
    popMatrix();
  }

  void boundarycheck() {
    if (posX+1>=width-wide || posX<=1) {
      xVelocity*=-1.0;
    }

    if (posY+1>=height-high || posY<=1) {  
      yVelocity*=-1.0;
    }
  }

  void verticalbounce() {
//    player.play();    
    yVelocity*=-1.0;
  }

  void horizontalbounce() {
//    player.play();    
    xVelocity*=-1.0;    
  }
}

// brickmaker

class Brick {
  int posX, posY, wide, high;
  color col;
  boolean exists;
  float descent;
  int timer;

  Brick (int tposX, int tposY, int wd, int hi, color tcol, boolean toBe, float drop, int _timer) {
    posX=tposX;
    posY=tposY;
    high=hi;
    wide=wd;
    col=tcol;
    exists=toBe;
    descent=drop;
    timer=_timer;
  }

  void make() {
    pushMatrix();
    fill(col);
//    tint(col);
    translate(posX, posY);
//    image(myTexture,0,0,wide,high);
    rect(0, 0, wide, high);
    popMatrix();
  }

  void destroy() {
    descent=0.3;
    timer=frameCount;
    col=#3F3F3F;
    make();
  }

  void fallaway() {
    make();
    if (timer+25<frameCount) {
      descent=descent*1.04;
      posY=posY+int(descent);
      if (posY>height) {
        descent=0;
        exists=false;
      }
    }
  }
}