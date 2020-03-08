class Ball {
  
  float x, y;
  float diameter;
  Box2DProcessing box2d;
  Body body;
  int type;
  Vec2[] vDisplay;
 
  Ball(float xin, float yin, float din, Box2DProcessing box2d_, int type_) {
    x = xin;
    y = yin;
    type = type_;
    diameter = din;
    box2d = box2d_;
    
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
    body = box2d.createBody(bd);

    FixtureDef fd = new FixtureDef();
    fd.shape = getShape();
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0;
    fd.restitution = 0.8;

    // Attach fixture to body
    body.createFixture(fd);

    //body.setAngularVelocity(random(-10, 10));
    float a = 10;
    body.setLinearVelocity(new Vec2(random(-a, a), random(-a, a)));
  }
  
  Shape getShape() {
    if(type == 0) {
       CircleShape cs = new CircleShape();
       cs.m_radius = box2d.scalarPixelsToWorld(diameter*0.5);
       return cs;
    }

    Vec2[] vShape, vDisplay; 
    

    if(type == 2) {
      vShape = getHeartVertices(8);
      vDisplay = getHeartVertices(30);
    } 
    else if(type == 1) {
      vShape = vDisplay = getPolygonVertices(3);
    }
    else {
      vShape = vDisplay = getPolygonVertices(5);
    }
    
    int count = vShape.length;
     Vec2[] world = new Vec2[count];
     for(int i = 0 ; i < count; i++) {
       world[i] = box2d.vectorPixelsToWorld(vShape[i]);
     }
     PolygonShape sd = new PolygonShape();
     sd.set(world, count); 
     
     this.vDisplay = vDisplay;
     return sd;
  }
  
  Vec2[] getPolygonVertices(int count) {
    float radius = diameter * 0.5;
    float delta = TWO_PI / count;
    float t = 0;
    Vec2[] v = new Vec2[count];
    for (int i = 0 ; i < count; i++) {
      float angle = i*delta;
      float x = radius*cos(angle-PI/2) + t*random(radius);
      float y = radius*sin(angle-PI/2) + t*random(radius);
      v[i] = new Vec2(x, y);
    } 
    return v;
  }
  
  Vec2[] getHeartVertices(int count) {
    float t = 0.7;
    float radius = diameter * 0.5;
    float delta = TWO_PI / count;
    Vec2[] v = new Vec2[count];
    for (int i = 0 ; i < count; i++) {
      float angle = i*delta;
      float circleX = cos(angle-PI/2);
      float circleY = sin(angle-PI/2);
      float heartX = pow(sin(angle), 3);
      float heartY = (-13*cos(angle)+5*cos(2*angle)+2*cos(3*angle)+cos(4*angle))/17;
      
      float x = radius*lerp(circleX,heartX,t);
      float y = radius*lerp(circleY,heartY,t);
      v[i] = new Vec2(x, y);
    } 
    return v;
  }
  
  
  // Formula for gravitational attraction
  // We are computing this in "world" coordinates
  // No need to convert to pixels and back
  void attract(Ball attractor) {
    float G = 50; // Strength of force
    // clone() makes us a copy
    Vec2 pos = attractor.body.getWorldCenter();    
    Vec2 moverPos = this.body.getWorldCenter();
    // Vector pointing from mover to attractor
    Vec2 force = pos.sub(moverPos);
    float dist2 = force.lengthSquared();
    // Keep force within bounds
    dist2 = constrain(dist2,1,25);
    force.normalize();
    // Note the attractor's mass is 0 because it's fixed so can't use that
    float strength = (G * 1 * this.body.m_mass) / dist2; // Calculate gravitional force magnitude
    force.mulLocal(strength);         // Get force vector --> magnitude * direction
    
    body.applyForce(force, body.getWorldCenter());
  }
  
  void boom(Vec2 p) {  
    float G = 10000; // Strength of force
    
    Vec2 pos = this.body.getWorldCenter();
    // Vector pointing from mover to attractor
    Vec2 force = pos.sub(p);
    float dist = force.normalize();
    // Keep force within bounds
    dist = max(dist,5);
    // Note the attractor's mass is 0 because it's fixed so can't use that
    float strength = (G * 1 * this.body.m_mass) / (dist*dist); // Calculate gravitional force magnitude
    force.mulLocal(strength);         // Get force vector --> magnitude * direction
    
    body.applyLinearImpulse(force, pos, true);
    
    //print("boom", force);
  
  }
  
  // The box2D boudnary phics will take care of most containment
  
  void checkBoundary(Rect rect) {
    PVector pos = box2d.getBodyPixelCoordPVector(body);

    if(!rect.contains(pos.x, pos.y)) {
      pos = rect.center;
      Vec2 worldPos = box2d.coordPixelsToWorld(pos);
      body.setTransform(worldPos,0);
    }
    
    this.x = pos.x;
    this.y = pos.y;
  }
  
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    drawShape();
    popMatrix(); 
  }
  
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
}
