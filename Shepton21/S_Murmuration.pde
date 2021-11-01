class MurmurationShow extends Show {

  int hour = 5;
  float mins = 0;
  int time = 0;
  int nBirds = 100;
  Flock flock;

  int sunriseHour = 5;
  int sunsetHour = 21;

  int roostHour = 20;
  int sunsetMargin = 3;
  final float maxCohesion = 3.0;

  color azureBlue = color(200, 50, 99);
  color nightBlue = color(250, 80, 30);
  color sunsetRed = color(350, 98, 60);
  boolean roostEnabled = false;

  color skyColor;
  color sunsetColor;

  int numStars = 100;

  PVector northStar;
  Star[] stars = new Star[numStars];
  boolean starsEnabled = false;
  float starRadius = 5;
  int starAlpha;
  int maxStarAlpha = 240;

  Window window;
  Rect rect;
  MurmurationShow(Settings settings) {
    super(settings); 
    window = new Window(settings);

    rect = window.getRect();

    northStar = rect.getPoint(0.75, 0.25);
    println("northStar", northStar);

    stars[0] = new Star(new PVector(0, 0), starRadius, 1);

    for (int i=1; i < numStars; i++) {
      float length = random(rect.Width);
      float theta = random(2*PI);

      PVector p = new PVector(length*(float)Math.sin(theta), length*(float)Math.cos(theta));
      stars[i] = new Star(p, random(0.5*starRadius, starRadius), random(0.5, 1));
    }
  }


  color getSkyColor() {
    float skyFactor = 1-Math.abs((time/720.0) - 1);
    return lerpColor(nightBlue, azureBlue, skyFactor);
  }

  float getCohesionFactor() {
    int dayEnd = (roostHour)*60;
    int dayStart = (sunriseHour)*60;

    float f = Math.abs(map(time, dayStart, dayEnd, 0.1, 1));
    return maxCohesion*Math.min(f, 1.0);
  }

  float getSunsetFactor(int sunsetHour) {
    int sunsetMins = sunsetHour*60;
    float m = sunsetMargin*60.0;
    float d = Math.abs(time-sunsetMins); 

    float factor = Math.max(1-(1/m*d), 0);

    //println(hour, time, d, sunsetMins, ", d=", d, ", m=", m, ", factor=",factor);
    return factor;
  }

  int getTimeRelativeToMidnight() {
    return time > 720 ? time-1440 : time;
  }

  color getSunsetColor() {
    float factor = Math.max(getSunsetFactor(sunsetHour), getSunsetFactor(sunriseHour));
    if (factor == 0) {
      return skyColor;
    }
    return lerpColor(skyColor, sunsetRed, factor);
  }

  int getStarAlpha() {
    int starStart = (sunsetHour-24)*60;
    int starEnd = (sunriseHour)*60;
    int adjustedTime = getTimeRelativeToMidnight();

    int alpha = (int)map(adjustedTime, starStart, starEnd, 0, 2*maxStarAlpha);
    //println(adjustedTime, starStart, starEnd, alpha);
    alpha = Math.min(alpha, 2*maxStarAlpha-alpha);

    return Math.max(0, alpha);
  }

  void update() {
    flock.update();
    mins+=0.5;
    if (mins >= 60) {
      hour++;
      mins = 0;
    }
    if (hour >= 24 ) {
      hour = 0;
    }
    time = hour*60+int(mins);

    //float cohesionFactor = getCohesionFactor();
    //float separationFactor = 0.5*2*(1.0-cohesionFactor/maxCohesion);

    skyColor = getSkyColor();
    sunsetColor = getSunsetColor();
    starAlpha = getStarAlpha();

    if (hour == roostHour && !roostEnabled) {
      int roostIndex = window.getRandomIndex();
      Rect rect = window.boxes[roostIndex].box;
      northStar = rect.getRandomPoint();
          
      for (Boid bird : flock.boids) {
        bird.setRoostRect(rect);
        //bird.cohesionFactor = cohesionFactor;
        //bird.separationFactor = separationFactor;
      }
      roostEnabled = true;
    } else if (hour == sunriseHour && roostEnabled) {
      for (Boid bird : flock.boids) {
        bird.clearRoostPosition();
        //bird.cohesionFactor = cohesionFactor;
        //bird.separationFactor = separationFactor;
      } 
      roostEnabled = false;
    }

    //println("cohesionFactor", cohesionFactor, "separationFactor", separationFactor);
  }

  void drawSky() {
    int ia = rect.Top;
    int ib = (rect.Top + rect.Bottom) / 2;
    int ic = (rect.Bottom);

    fill(skyColor);
    rect(rect.Left, ia, rect.Width, ib-ia);

    for (int i = ib; i <= ic; i++) {
      float inter = map(i, ib, ic, 0, 1);
      color c = lerpColor(skyColor, sunsetColor, inter);
      fill(c);
      rect(rect.Left, i, rect.Width, 1);
    }
  }

  void drawStars() {
    if (starAlpha <= 0) {
      return;
    }

    float theta = float(getTimeRelativeToMidnight())/720.0;
    float s = (float)Math.sin(theta);
    float c = (float)Math.cos(theta);

    for (Star star : stars) {
      PVector v = star.position;
      float px = northStar.x + c*v.x - s*v.y;
      float py = northStar.y + c*v.y + s*v.x;

      if (rect.contains(px, py)) {
        fill(H_MAX, starAlpha*star.alphaFactor*random(0.8, 1));
        ellipse(px, py, star.radius, star.radius);
      }
    }
  }

  void draw() {

    drawSky();
    drawStars();
    flock.draw();
  }

  void stop() {
  }

  void start() {

    flock = new Flock();
    Rect windowRect = window.getRect();

    int roostIndex = window.getRandomIndex();
    Rect rect = window.boxes[roostIndex].box;

    //PVector c = rect.center;
    //float separation = rect.Width*0.2*random(0.9, 1.1);
    float separation = 25;
    println("separation", separation);
    for (int k=0; k < nBirds; k++) {
      Boid b = new Boid(windowRect, rect.getRandomPoint(), separation);
      b.maxspeed*=random(0.8, 1.2);
      flock.addBoid(b);
    }
  }
}

class Star {
  final float alphaFactor;
  final float radius;
  final PVector position;

  Star(PVector position_, float radius_, float alphaFactor_) {
    position = position_;
    radius = radius_;
    alphaFactor = alphaFactor_;
  }
}
