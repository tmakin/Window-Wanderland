
class ShowBox {
  Rect box;
  Rect targetRect = null;
  color c = color(0, 0, 0);
  float g = 1;
  int prevTime = -1;
  int type;

  char character = ' ';
  int speed = 8;
  boolean disabled = false;

  int ALPHA_MAX = 255;
  int alpha = ALPHA_MAX;
  int targetAlpha = ALPHA_MAX;

  int frameSize = 8;
  PVector[] animationPath = null;
  PVector translation = null;
  int animationIndex = 0;
  float brightness;
  float brightnessInc;
  float brightnessMin=10;
  float brightnessMax=70;
  
  ShowBox(Rect rect_) {
    box = rect_;
    
    brightness = random(brightnessMin,brightnessMax);
    regenBrightnessInc();
  }

  void regenBrightnessInc() {
    brightnessInc = random(0.1,0.2);
  }

  void updateBrightness() {
    brightness+=brightnessInc;
    
    if(brightness < brightnessMin) {
       brightness=brightnessMin;
       brightnessInc=-brightnessInc;
    }
    
    if(brightness > brightnessMax) {
       brightness=brightnessMax;
       brightnessInc=-brightnessInc;
    }
     
  }

  void setChar(char character_) {
    character = character_;
  }
  
  void disable() {
    this.disabled = true; 
  }

  public void drawFrame() {
    stroke(100);
    strokeWeight(frameSize); 
    noFill();
    translate(0, 0, 0.1);
    box.drawRect();
  }

  public void draw() {
    this.updateAlpha();
    this.updateAnimation();
    
    if(disabled || alpha <= 0) {
      return; 
    }

    if (alpha >= ALPHA_MAX) {
      fill(c);
    } else {
      fill(c, alpha);
    }

    pushMatrix();

    if (translation != null) {
      translate(translation.x, translation.y, translation.z);
    }

    noStroke();
    box.drawRect();

    if (character != ' ') {
      fill(color(0, 0, 0));
      textSize(50);
      textAlign(CENTER, CENTER);
      text(character, box.Left+box.Width*0.5, box.Top+box.Height*0.5, 0.1);
    }

    popMatrix();
  }

  public void setColor(color value) {
    c = value;
  }

  public void setAlpha(int value) {
    alpha = targetAlpha = value;
  }

  private int getDiff(int xCurrent, int xTarget, int speed) {
    if (xCurrent == xTarget) {
      return 0;
    } 

    int result = Math.min(Math.abs(xCurrent - xTarget), speed); 
    if (xCurrent < xTarget) {
      return result;
    } else {
      return -result;
    }
  }

  private void updateAnimation() {
    if (animationPath == null) {
      return;
    }

    if (animationIndex >= animationPath.length) {
      box.setPos(targetRect.Left, targetRect.Top);
      animationPath = null;
      translation = null;
      targetRect = null;
      return;
    }
    translation = animationPath[animationIndex];
    animationIndex++;
  }

  private void updateAlpha() {
    if (targetAlpha == alpha) {
      return;
    }

    int diff = getDiff(alpha, targetAlpha, 2);
    alpha += diff;
  }

  public boolean isAnimating() {
    return this.animationPath != null;
  }

  public void animate(Rect targetRect, float zMax) {
    this.targetRect = targetRect.clone();
    PVector d = PVector.sub(targetRect.origin, box.origin); 
    int numSteps = 30;

    animationPath = new PVector[numSteps];
    for (int i = 0; i < numSteps; i++) {
      float x = (2*i - (float)numSteps)/(float)numSteps;
      float z = zMax*(1-x*x);
      float f = i/(float)numSteps;
      animationPath[i] = new PVector(d.x*f, d.y*f, z);
    }
    animationIndex = 0;
  }

  public void fadeIn() {
    targetAlpha = ALPHA_MAX;
  }

  public void fadeOut() {
    targetAlpha = 0;
  }
}
