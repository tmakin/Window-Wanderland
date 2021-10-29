import shiffman.box2d.*;
import java.util.ArrayDeque;
import java.util.HashSet;

Box2DProcessing box2d = new Box2DProcessing(this);


class AppleShow extends Show {
  final int maxBalls = 60;
  final float gravity = -20;
  final float minDia = 30;
  final float maxDia = 65;

  Rect rect;
  int type;

  PImage appleImg;
  int ticks = 1000;

  Windmill windmill;
  PBox leftBoundary;
  PBox rightBoundary;
  Window window;

  ArrayList<Apple> apples = new ArrayList<Apple>();

  AppleShow(Settings settings) {
    super(settings); 

    Window window = new Window(settings);
    rect = window.getRect();

    appleImg = loadAppleImage();

    windmill = initWindmill();

    initBoundaries();
  }

  private Windmill initWindmill() {
    float x = rect.center.x;
    float y = rect.center.y + settings.h*0.5;
    PBox axel = new PBox(x, y, 10, 10, true);
    PBox sail = new PBox(x, y, rect.Width-1.8*maxDia, 40, false);
    return new Windmill(axel, sail);
  }

  private PImage loadAppleImage() {
    PImage img = loadImage("images/apple.png");

    int margin = 18;
    int size = 100;
    img.resize(size+2*margin, size+2*margin); 
    return img.get(margin, margin, size, size);
  }

  private void addApple() {
    if (apples.size() >= maxBalls) {
      return;
    }
    Apple apple = new Apple(rect.Left + random(rect.Width), rect.Top -300, random(minDia, maxDia), this.appleImg);
    apples.add(apple);
  }

  private void removeDeadApples() {
    // update the balls
    IntList indexesToRemove = new IntList();
    for (int k = 0; k < apples.size(); k++) {
      Apple apple = apples.get(k);
      Vec2 pos = apple.getPosition();
      if (pos.y > rect.Bottom+100) {
        apple.destroy();
        indexesToRemove.append(k);
      }
    }

    for (int i = indexesToRemove.size()-1; i >= 0; i--) {
      int k = indexesToRemove.get(i);
      apples.remove(k);
    }
  }

  private void initBoundaries() {
    Rect r = rect;
    int w = 10;
    leftBoundary = new PBox(r.Left, r.Top, w, 2*r.Height, true);
    rightBoundary = new PBox(r.Right, r.Top, w, 2*r.Height, true);
  }


  void update() {

    ticks++;
    if (ticks > 10) {
      removeDeadApples();
      addApple(); 
      ticks = 0;
    }

    windmill.update();
    box2d.step();
  }

  public void draw() {
    //rect.drawRect();

    color ballColor = color(0, 240);
    fill(ballColor);
    for (Apple apple : apples) {
      apple.display();
    }
    windmill.draw();
    //leftBoundary.draw();
  }

  void start() {
    box2d.setGravity(0, gravity);
  }
  void stop() {
  }
}
