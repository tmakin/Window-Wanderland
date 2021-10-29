

class Apple {

  float x, y;
  float diameter;
  Body body;
  int type = 0;
  PImage img;

  Apple(float x, float y, float d, PImage img) {
    this.x = x;
    this.y = y;
    this.diameter = d;
    this.img = img.copy();

    this.img.resize((int)d, (int)d);

    this.initPhysics();
    //println(type);
  } 

  private void initPhysics() {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;

    //print(x, y, box2d, bd);
    this.body = box2d.createBody(bd);

    FixtureDef fd = new FixtureDef();
    fd.shape = getShape();
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 1;
    fd.restitution = 0.35;

    // Attach fixture to body
    body.createFixture(fd);

    body.setAngularVelocity(random(-2, 1));
    float a = 10;
    body.setLinearVelocity(new Vec2(random(-a, a), -a));
  }

  Shape getShape() {
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(diameter*0.5);
    return cs;
  }

  void setActive(boolean value) {
    this.body.setActive(value);
  }

  void setPosition(float x, float y) {
    Vec2 worldPos = box2d.vectorPixelsToWorld(x, y);
    body.setTransform(worldPos, body.getAngle());
  }

  Vec2 getPosition() {
    assert(body != null);
    return box2d.getBodyPixelCoord(body);
  }

  void destroy() {

    body.setActive(false);
    box2d.destroyBody(body); 
    body = null;
  }

  void display() {
    if (body == null) {
      return;
    }
    Vec2 pos = getPosition();
    float a = body.getAngle();

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    //drawShape();
    imageMode(CENTER);
    image(img, 0, 0);
    popMatrix();
  }

  /*
  void drawShape() {
   if(type == 0) {
   ellipse(0,0, diameter, diameter); 
   return;
   }
   
   beginShape();
   for (Vec2 v : vDisplay) {
   vertex(v.x, v.y);
   }
   endShape();
   }
   */
}
