// simple mouse movements

float ballXPosition;
float ballYPosition;
float ballSize;

void setup() {
  size(500,500);
  fill(#FFCC33);
  strokeWeight(3);
  smooth();
  ballSize = 15;
}


void draw() {
// background(#FFFFFF);  
  ballXPosition = mouseX;
  ballYPosition = mouseY;
  ellipse(ballXPosition,ballYPosition,ballSize,ballSize);
//  if (mousePressed == true) {
//    ballSize = ballSize + 2;
//  }
}
