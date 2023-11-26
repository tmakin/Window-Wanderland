// Coding Challenge 127: Brownian Motion Snowflake
// Daniel Shiffman
// https://thecodingtrain.com/CodingChallenges/127-brownian-snowflake.html
// https://youtu.be/XUA8UREROYE
// https://editor.p5js.org/codingtrain/sketches/SJcAeCpgE

class Particle {
  PVector pos;
  float r;
  float maxRadius;
  float delta;

  Particle(float radius, float seed, float seed2) {
    maxRadius = radius;
    delta = maxRadius*lerp(0.006, 0.009, seed);
    pos = PVector.fromAngle(random(0,seed2*PI/6));
    pos.mult(radius);
    update();
    r = 6;
  }
  
  void update() {
    pos.x -= 1;
    pos.y += random(-delta, delta);

    float angle = pos.heading();
    angle = constrain(angle, 0.01*PI/6, PI/6);
    float magnitude = min(pos.mag(),maxRadius);
    pos = PVector.fromAngle(angle);
    pos.setMag(magnitude);
  }

  void show() {
    var d = r*3;
    ellipse(pos.x, pos.y, d, d);
  }

  boolean intersects(ArrayList<Particle> snowflake) {
    for (Particle s : snowflake) {
      float d = dist(s.pos.x, s.pos.y, pos.x, pos.y); 
      if (d < r) {
        return true;
      }
    }
    return false;
  }

  boolean finished() {
    return (pos.x < 1);
  }
}
