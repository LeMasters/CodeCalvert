float diameter;
float radius;

void setup() {
  size(500,500);
  diameter = width / 10;
  radius = diameter * 0.5;
  noLoop();
}

void draw() {
  for (int x = 0; x<10; x=x+1) {
    for (int y = 0; y<10; y=y+1) {
      for (int z = 4; z>0; z=z-1) {
        fill(random(255));
        ellipse(x * diameter+radius, y * diameter+radius, diameter * z * 0.25, diameter * z * 0.25);
      }
    }
  }
}
