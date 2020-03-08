import shiffman.box2d.*;

float dia = 40;

class ShowBox {
  int numBalls;
  Rect box;
  Ball[] balls;
  color c1 = genColor();
  color c2 = genColor();
  float fc=0;
  float g = 1;
  int prevTime = -1;
  int type;
  boolean attractionEnabled = false;
  
  Box2DProcessing box2d;
  
  ShowBox(int numBalls_, Rect rect_, Box2DProcessing box2d_, int type_) {
    numBalls = numBalls_;
    box = rect_;
    balls = new Ball[numBalls];
        
    box2d = box2d_; 
    type= type_;
        
    this.initBalls();
    this.initBoundaryPhysics();
  }
 
  private void initBalls() {
    for (int i = 0; i < numBalls; i++) {
      balls[i] = new Ball(box.Left + random(box.Width), box.Top + random(box.Height), random(0.8*dia-10, 1.5*dia), box2d, type);
    } 
  }
  
  private void initBoundaryPhysics() {
    Vec2[] points = {
      new Vec2(box.Left,box.Top),
      new Vec2(box.Right,box.Top),
      new Vec2(box.Right,box.Bottom),
      new Vec2(box.Left,box.Bottom),
      new Vec2(box.Left,box.Top)
    };
    
    Vec2[] vertices = new Vec2[5];
    for (int i = 0; i < points.length; i++) {
      vertices[i] = box2d.coordPixelsToWorld(points[i]);     
    }
    
    ChainShape chain = new ChainShape();
    chain.createChain(vertices, vertices.length);
 
    // Create body
    BodyDef bd = new BodyDef();
    Body body = box2d.world.createBody(bd);
    
    // Attach chain to body
    // we could explicitly define the fixture if we need specify frictions, restitution, etc.
    body.createFixture(chain,1); 
  }
  
  void update() {
    // Limit update calls to once a second
    int time = second();
    if(prevTime == time) {
      return; 
    }
    
    // update the balls
    for (Ball ball : balls) {
     ball.checkBoundary(box);  
    }
    
    prevTime = time;
    
    if((time % 10) == 0) {
      g = -g;
      // print("Gravity flip", time, g);
    }
    box2d.setGravity(0, g);
  }
 
  color genColor() {
   float h = random(255);
   float s = random(100, 255);
   float b = 255;
   return color(h,s,b);
  }
  
  void changeColor() {
    fc = 1.0;
    c2 = genColor();
  }
  
  void blackout() {
    fc = 0.0;
    c2 = color(0);
  }
 
  public void attract() {
    if(!attractionEnabled) {
      return; 
    }
    for (int j = 1; j < numBalls; j++) {
      balls[j].attract(balls[0]);
    }
  }
  
  public void boom(Vec2 p) {
    Vec2 pBox = box2d.coordPixelsToWorld(p);  
    
    for (int j = 0; j < numBalls; j++) {
      balls[j].boom(pBox);
    }
  }
 
  public void display() {
    // background
    if(fc < 1) {
      fc += 0.01;
    }
    else if(random(1) > 0.99) {
      c1 = c2;
      c2 = genColor();
      fc = 0;
    }
    
    if(random(1) > 0.995) {
      attractionEnabled = (random(1) > 0.7);
    }
    
    color c = lerpColor(c1, c2, fc);
    fill(c);
    
    box.display();
    
    color ballColor = color(0, 240);
    fill(ballColor);
    for (int j = 0; j < numBalls; j++) {
      balls[j].display(); 
    }
  }
}
