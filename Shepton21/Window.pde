
class Window {

  Settings settings;
  ShowBox[] boxes;



  public Window(Settings settings_) {
    settings = settings_;
    boxes = new ShowBox[settings.n];


    int k=0;
    for (int j = 0; j < settings.nY; j++) {
      for (int i = 0; i <settings.nX; i++) {

        Rect rect = new Rect(settings.w*i, settings.h*j, settings.w, settings.h);
        ShowBox b = new ShowBox(rect);

        boxes[k] = b;
        k++;
      }
    }
  }

  void setColor(color c) {
    for (ShowBox showBox : boxes) {
      showBox.setColor(c);
    }
  }

  Rect getRect() {
    return new Rect(0, 0, settings.nX*settings.w, settings.nY*settings.h);
  }

  void clearChars() {
    for (int i=0; i < boxes.length; i++) {
      boxes[i].setChar(' ');
    }
  }

  void setChars(String word) {
    println("setChars", word);
    clearChars();
    int count = Math.min(word.length(), boxes.length);
    for (int i=0; i < count; i++) {
      boxes[i].setChar(word.charAt(i));
    }
  }

  int getRandomIndex() {
    return (int)(Math.floor(random(settings.n)));
  }

  boolean isAnimating() {
    for (int k = 0; k < boxes.length; k++) {
      if (boxes[k].isAnimating()) {
        return true;
      }
    }  

    return false;
  }

  public void draw() {

    noStroke();
    for (int k = 0; k < settings.n; k++) {
      boxes[k].draw();
    }
  }

  public void drawFrame() {
    for(ShowBox showBox : boxes) {
       showBox.drawFrame();
    }
  }
}
