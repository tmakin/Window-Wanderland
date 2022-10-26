
class Windmill {

  // Our object is two boxes and one joint
  // Consider making the fixed box much smaller and not drawing it
  RevoluteJoint joint;
  PBox axel;
  PBox sail;
  Vec2 rotOrigin;
  final float defaultTorque = 100000.0;
  float torque = defaultTorque;
  int ticks  = 0;

  Windmill(PBox axel, PBox sail) {

    this.axel = axel;
    this.sail = sail;

    // Define joint as between two bodies
    RevoluteJointDef rjd = new RevoluteJointDef();

    rotOrigin = axel.body.getWorldCenter();

    rjd.initialize(axel.body, sail.body, rotOrigin);

    // Turning on a motor (optional)
    rjd.motorSpeed = -PI;       // how fast?
    rjd.maxMotorTorque = torque; // how powerful?
    rjd.enableMotor = true;      // is it on?

    sail.body.setAngularVelocity(-1);

    // Create the joint
    joint = (RevoluteJoint) box2d.world.createJoint(rjd);
  }

  // Turn the motor on or off
  void toggleMotor() {
    joint.enableMotor(!joint.isMotorEnabled());
  }

  float getAngle() {
    return this.sail.body.getAngle();
  }

  float getJointSpeed() {
    return this.joint.getJointSpeed();
  }

  void increaseTorqueLimit() {
    torque*=2;
    println("windmill torque increased", torque);
    joint.setMaxMotorTorque(torque);
  }

  void decreseTorqueLimit() {

    if (torque == defaultTorque) {
      return;
    }

    torque=Math.max(defaultTorque, 0.5*torque);

    println("windmill torque decresed", torque);
    joint.setMaxMotorTorque(torque);
  }

  void update() {

    ticks++;
    if (ticks < 50) {
      return;
    }
    ticks = 0;
    float speed = this.joint.getJointSpeed();
    if (Math.abs(speed) < 0.5) {
      increaseTorqueLimit();
    } else {
      decreseTorqueLimit();
    }
  }

  void draw() {
    axel.draw();
    sail.draw();

    // Draw anchor just for debug
    Vec2 anchor = box2d.coordWorldToPixels(rotOrigin);
    fill(255, 0, 0);
    stroke(50, 0, 0);

    ellipse(anchor.x, anchor.y, 4, 4);
  }
}


class PBox {

  // We need to keep track of a Body and a width and height
  Body body;
  float w;
  float h;

  // Constructor
  PBox(float x, float y, float w_, float h_, boolean lock) {
    w = w_;
    h = h_;

    // Define and create the body
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(new Vec2(x, y)));
    if (lock) bd.type = BodyType.STATIC;
    else bd.type = BodyType.DYNAMIC;

    body = box2d.createBody(bd);

    // Define the shape -- a  (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    body.createFixture(fd);

    // Give it some initial random velocity
    //body.setLinearVelocity(new Vec2(random(-5,5),random(2,5)));
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Drawing the box
  void draw() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    rectMode(PConstants.CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(175);
    noStroke();
    rect(0, 0, w, h);
    popMatrix();
  }
}
