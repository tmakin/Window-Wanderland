class Snowflake {
  Particle current;
  ArrayList<Particle> snowflake;
  float initialRadius;
  float rot=0;
  float seed, seed2;
  int maxPoints;
  int ticks=0;
  int maxTicks;
  float rotationSpeed;
  PVector origin;
  int initialTicks;
  float alpha;
  float scaleFactor;


  Snowflake(PVector origin_, float boxWidth) {
    origin = origin_;
    initialRadius = 500;
    scaleFactor = 0.5*boxWidth/initialRadius;

    regen();
  }

  Particle createParticle() {
    return new Particle(initialRadius, seed, seed2);
  }

  void regen() {
    alpha = 100;
    initialTicks = (int)random(0, 500);
    maxTicks = (int)random(300, 2000);
    rotationSpeed = random(-1.0/200, 1.0/200);
    seed = random(1);
    seed2 = random(1);
    maxPoints = floor(random(100, 300));
    current = createParticle();
    snowflake = new ArrayList<Particle>();
    ticks = 0;
  }

  void update() {
    if (initialTicks > 0) {
      initialTicks--;
      return;
    }
    ticks++;
    rot += rotationSpeed;

    int count = 0;

    while (!current.finished() && !current.intersects(snowflake)) {
      current.update();
      count++;
    }

    if (count > 0 && snowflake.size() < maxPoints) {
      snowflake.add(current);
      current = createParticle();
    }
    
    var f = ((float)ticks)/maxTicks;
    alpha = (100*(1.0-f));

    if (ticks > maxTicks) {
      regen();
      return;
    }
  }

  void draw() {
    pushMatrix();

    translate(origin.x, origin.y);
    scale(scaleFactor);
    rotate(rot);

    noStroke();
    fill(0, 0, 255, alpha);

    for (int i = 0; i < 6; i++) {
      rotate(PI/3);

      for (var p : snowflake) {
        p.show();
      }

      pushMatrix();
      scale(1, -1);
      for (var p : snowflake) {
        p.show();
      }
      popMatrix();
    }
    popMatrix();
  }
}
