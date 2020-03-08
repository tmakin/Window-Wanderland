import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
//import oscP5.*;

int numBalls = 12; //number of balls per box
float gravity = -10;

int side = 210;
int top = 28;
int bottom = 54;
int marginX = 104;
int marginY = 34;

int randomBoom = 0;
int randomBoomFreq = 5; // number of frames between each boom event
int randomBoomLength = 20; // number of boom events in the sequence

ShowBox[] boxes = new ShowBox[4];
Rect boundary;
//OscP5 osc;
float oscX;
float oscY;

void setup() {
  fullScreen(2);
  //size(1024, 768);
  frameRate(40);
  noStroke();
  background(0);
  colorMode(HSB, 255);


  //osc = new OscP5(this , 12000 );
  
  int w = width - 2*side;
  int h = height - top - bottom;
  int windowWidth = (w-marginX)/2;
  int windowHeight = (h-marginY)/2;
  int xOffset = windowWidth + marginX;
  int yOffset = windowHeight + marginY;
  
  int[] x = { 0, xOffset, xOffset, 0};
  int[] y = { 0, 0, yOffset, yOffset};
  
  boundary = new Rect(side, top, w, h);
  
  for (int i = 0; i < 4; i++) {
    Rect rect = new Rect(side+x[i], top+y[i], windowWidth, windowHeight);
    
    Box2DProcessing box2d = new Box2DProcessing(this);
    box2d.createWorld();
    box2d.setGravity(0, gravity);
    boxes[i] = new ShowBox(numBalls, rect, box2d, 3);
  } 
}

void keyPressed()
{
  if(key == 'b') {
    startRandomBoom();
  }
  //println("key", key);
}
void mouseClicked() {
  //Vec2 p = new Vec2(mouseX, mouseY);
  //boom(p);
  startRandomBoom();
}

void startRandomBoom() {
  randomBoom = randomBoomFreq*20;
}

void cancelRandomBoom() {
  randomBoom = 0;
}

void boom(Vec2 p) {
  for (ShowBox box : boxes) {
    box.boom(p);
    box.changeColor();
  }
}

void changeColor() {
   cancelRandomBoom();
   for (ShowBox box : boxes) {
      box.changeColor(); 
   }
}


void blackout() {
   cancelRandomBoom();
   for (ShowBox box : boxes) {
      box.blackout(); 
   }
}

void draw() {
  
  if(random(1) > 0.9999) {
    startRandomBoom(); 
  }
  
  // random boom iteration
  if(randomBoom > 0) {
     randomBoom--;
     if(randomBoom % randomBoomFreq == 0) {
       Vec2 p = new Vec2(
        random(boundary.Left, boundary.Right), 
        random(boundary.Top, boundary.Bottom)
       );
       boom(p);
     }
  }
  
  if(oscX > 0 && oscY > 0) {
     Vec2 p = new Vec2(
       boundary.Left + oscX*boundary.Width, 
       boundary.Top + (1-oscY)*boundary.Height
     );
     oscX = oscY = -1;
     boom(p);
  }
  
  for (ShowBox box : boxes) {
    box.update();
    box.box2d.step();
    box.display();  
    box.attract();
  }
}

/* 
//incoming osc message are forwarded to the oscEvent method.
void oscEvent(OscMessage message) {
  
  String pattern = message.addrPattern();
  print("### received an osc message.");
  print(" addrpattern: "+pattern);
  // print(" typetag: "+message.typetag());
  OscArgument arg = message.get(0);
  println(" value: "+arg.floatValue());
  
  switch(pattern) {
    case "/osc/slider2Dx":
      oscX = arg.floatValue();
      break;
    case "/osc/slider2Dy":
      oscY = arg.floatValue();
      break;
    case "/osc/color":
      startRandomBoom();
      break;
    case "/osc/blackout":
      blackout();
      break;
  }
}
*/
