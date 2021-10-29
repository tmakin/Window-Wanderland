class MurmurationShow extends Show {

  int hour = 22;
  float mins = 0;
  int time = 0;
  int nBirds = 100;
  Flock flock;

  int sunriseHour = 5;
  int sunsetHour = 21;

  int roostHour = 20;
  int sunsetMargin = 3;

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

      stars[0] = new Star(new PVector(0,0), starRadius, 1);
      
    for (int i=1; i < numStars; i++) {
      PVector p = new PVector(random(-rect.Width, rect.Width), random(-rect.Height, rect.Height));
      stars[i] = new Star(p, random(0.5*starRadius, starRadius), random(0.5, 1));
    }
  }


  color getSkyColor() {
    float factor = 1-Math.abs((time/720.0) - 1);
    //println(hour, mins, time, factor);
    return lerpColor(nightBlue, azureBlue, factor);
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


    if (hour == roostHour && !roostEnabled) {
      int roostIndex = window.getRandomIndex();
      Rect rect = window.boxes[roostIndex].box;

      for (Boid bird : flock.boids) {
        bird.setRoostRect(rect);
      }
      roostEnabled = true;
    } else if (hour == sunriseHour && roostEnabled) {
      for (Boid bird : flock.boids) {
        bird.clearRoostPosition();
      } 
      roostEnabled = false;
    }

    skyColor = getSkyColor();
    sunsetColor = getSunsetColor();
    starAlpha = getStarAlpha();

    window.setColor(skyColor);
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

    //println("drawStars", time, starAlpha);



    pushMatrix();

    translate(northStar.x, northStar.y, 0.01);
    rotate((float)(getTimeRelativeToMidnight())/720);
    //println(northStar);

    for (Star star : stars) {
      PVector v = star.position;
      fill(H_MAX, starAlpha*star.alphaFactor*random(0.8, 1));
      ellipse(v.x, v.y, star.radius, star.radius);
    }


    popMatrix();
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

    PVector c = rect.center;
    for (int k=0; k < nBirds; k++) {
      flock.addBoid(new Boid(windowRect, rect.getRandomPoint()));
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
