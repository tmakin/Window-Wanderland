class Snowflake {
  Particle current;
  ArrayList<Particle> snowflake;
  float initialRadius;
  float rot=0;
  float seed, seed2;
  int maxPoints;
  int ticks=0;
  int meltTicks = 0;
  int maxTicks;
  float rotationSpeed;
  PVector origin;
  int initialTicks;
  float alpha;
  float scaleFactor;
  float drawCount =0;
  int finishedTicks = 0;
  boolean finished = false;


  Snowflake(PVector origin_, float boxWidth) {
    origin = origin_;
    initialRadius = 500;
    scaleFactor = 0.5*boxWidth/initialRadius;

    regen();
    
    // first time much longer
    initialTicks *= 4;
  }

  Particle createParticle() {
    return new Particle(initialRadius, seed, seed2);
  }

  void regen() {
    alpha = 100;

    initialTicks = (int)random(0, 100);
    meltTicks = (int)random(200, 400);
    maxTicks = (int)random(300, 1500);
    rotationSpeed = random(-1.0/300, 1.0/300);
    seed = random(1);
    seed2 = random(1);
    maxPoints = floor(random(100, 300));
    current = createParticle();
    snowflake = new ArrayList<Particle>();
    ticks = 0;
    drawCount = 0;
    finished = false;
    finishedTicks = 0;
  }

  void update() {
    if (initialTicks > 0) {
      initialTicks--;
      return;
    }
    ticks++;
    
    if (ticks > maxTicks || drawCount < 0) {
      regen();
      return;
    }
    
    // update alpha
    var f = ((float)ticks)/maxTicks;
    alpha = (100*(1.0-f));
    
    // rotation
    rot += rotationSpeed;

    if(finished) {
        finishedTicks++;
        if(finishedTicks > meltTicks) {
            drawCount-=0.5;
        }
        return;
    }
    
    int solverIterations = 0;

    while (!current.finished() && !current.intersects(snowflake)) {
      current.update();
      solverIterations++;
    }
    
    if(solverIterations == 0 || snowflake.size() >= maxPoints) {
       finished = true;
       return;
    }

    snowflake.add(current);
    drawCount++;
    current = createParticle();
  }

  void draw() {
    if(drawCount <= 0) {
      return;      
    }
    
    pushMatrix();

    translate(origin.x, origin.y);
    scale(scaleFactor);
    rotate(rot);

    noStroke();
    fill(0, 0, 255, alpha);

    for (int i = 0; i < 6; i++) {
      rotate(PI/3);

      for (int j = 0; j < drawCount; j++) {
        snowflake.get(j).show();
      }

      pushMatrix();
      scale(1, -1);
      for (int j = 0; j < drawCount; j++) {
        snowflake.get(j).show();
      }
      popMatrix();
    }
    popMatrix();
  }
}
