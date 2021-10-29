// The Boid class


class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void update() {
    for (Boid b : boids) {
      b.flock(boids);
    }

    for (Boid b : boids) {
      b.update();
      b.borders();
    }
  }

  void draw() {
    for (Boid b : boids) {
      b.draw();
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
}


class Boid {

  float defaultMaxSpeed = 3.0;

  PVector roostPosition = null;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r = 2.0;
  float maxforce = 0.03;
  float maxspeed = defaultMaxSpeed;
  float roostSpeed = 1;
  Rect roostRect = null;
  float desiredseparation = 25.0f;
  float roostSeparation = 5.0f;
  boolean insideRoost = false;
  Rect rect;

  float _distance = 0;

  Boid(Rect rect_, PVector position) {
    this.rect = rect_;
    this.velocity = PVector.random2D();
    this.position = position;
    this.acceleration = new PVector(0, 0);
  }

  void setRoostPosition(PVector value) {
    roostPosition = value;
    insideRoost = false;
    maxspeed = defaultMaxSpeed;
  }

  void setRoostRect(Rect rect) {
    roostRect = rect;
    roostPosition = rect.getRandomPoint();
    roostPosition = rect.center;
  }


  void clearRoostPosition() {
    roostRect = null;
    roostPosition = null;
    maxspeed = defaultMaxSpeed;
    insideRoost = false;
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {

    for (Boid other : boids) {
      if (insideRoost == other.insideRoost) {
        other._distance = PVector.dist(position, other.position);
      } else {
        other._distance = 10000;
      }
    }

    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment

    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    // Add the force vectors to acceleration

    applyForce(ali);
    applyForce(sep);

    if (roostRect != null) {
      insideRoost = roostRect.contains(position);
      if (insideRoost) {
        acceleration.mult(0.1);
      } else {
        PVector f = seek(roostPosition, 1.0);
        applyForce(f);
      }
    } else {
      PVector coh = cohesion(boids);   // Cohesion
      applyForce(coh);
    }
  }


  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    if (insideRoost) {
      velocity.mult(0.9); //damping
    }

    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);


    //borders();
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target, float factor) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce*factor);  // Limit to maximum steering force
    return steer;
  }

  void draw() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading() + radians(90);

    fill(0, 100);
    stroke(0);
    strokeWeight(1); 
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    // use hard boders if roosting
    if (insideRoost) {
      if (position.x < roostRect.Left || position.x > roostRect.Right) velocity.x *= -1;
      if (position.y < 0 || roostRect.Top > roostRect.Bottom) velocity.y *= -1;
      return;
    }

    if (position.x < -r) position.x = rect.Width+r;
    if (position.y < -r) position.y = rect.Height+r;
    if (position.x > rect.Width+r) position.x = -r;
    if (position.y > rect.Height+r) position.y = -r;
  }


  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {

    float sepDist = insideRoost ? roostSeparation : desiredseparation;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = other._distance;
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < sepDist)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    float mag = steer.mag();
    if (mag > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.mult(maxspeed/mag);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = other._distance;
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = other._distance;
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum, 1.0);  // Steer towards the position
    } else {
      return new PVector(0, 0);
    }
  }
}
