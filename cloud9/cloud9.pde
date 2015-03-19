color sky;
color cloudColor;
PShape cloudSmall,cloudMedium,cloudLarge;
float smallX,smallY,medX,medY,largeX,largeY;
float smallInc,medInc,largeInc;


void setup() {
  size(500,500);
  sky = color (#33CCEE);
  cloudColor = color(#FFDDEE);
  cloudSmall=loadShape("cloud_small.svg");
  cloudMedium = loadShape("cloud_medium.svg");
  cloudLarge = loadShape("cloud_large.svg");
  cloudSmall.disableStyle();
  cloudMedium.disableStyle();
  cloudLarge.disableStyle();
  smallX = -50;
  medX = -120;
  largeX = -25;
  smallY = height*0.62;
  medY = height*0.15;
  largeY = height*0.34;
  smallInc = 0.6;
  medInc = 0.80;
  largeInc = 0.2;
  strokeWeight(2);
   background(sky);
  
}


void draw() {
  background(sky);
  shape(cloudMedium, width*0.5, height*0.5);
  pushMatrix();
  scale(1.4);
  shape(cloudMedium,medX,medY);
  popMatrix();
  pushMatrix();
  scale(1.2);
  shape(cloudLarge,largeX,largeY);
  popMatrix();
  shape(cloudSmall,smallX,smallY);
  
  largeX = largeX + largeInc;
  medX = medX + medInc;
  smallX = smallX + smallInc;
  
  // are the clouds off the page?
  // then put them all the way back on the left
  
  if (largeX>width) {
    largeX = 0-cloudLarge.width;
  } else {
    if (medX>width) {
      medX = 0-cloudMedium.width;
    } else {
      if (smallX>width) {
        smallX = 0-cloudSmall.width;
      }
    }
  }
}
  
  
