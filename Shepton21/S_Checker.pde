class CheckerBoardShow extends Show {

  int ticks = 0;
  final int cycleTicks = 500;

  color a1, a2;
  color b1, b2;

  Window window;
  CheckerBoardShow(Settings settings) {
    super(settings); 
    window = new Window(settings);

    a2 = genColor();  
    b2 = genColor();  

    nextColor();
  }

  void nextColor() {
    ticks = 0;
    a1 = a2;
    b1 = b2;

    a2 = genColor();  
    b2 = genColor();
  }

  void update() {
    ticks++;
    if (ticks >=cycleTicks) {
      nextColor();
    }
    
    float f = (float)ticks/(float)cycleTicks;
    color a = lerpColor(a1, a2, f);
    color b = lerpColor(b1, b2, f);

    int k = 0;
    int offset = 0;
    for (int j = 0; j < settings.nY; j++) {
      offset++;

      for (int i = 0; i <settings.nX; i++) {
        color c = (i+offset) % 2 == 0 ? a : b;
        window.boxes[k].setColor(c);
        k++;
      }
    }
  }

  void draw() {
    window.draw();
  }
  void stop() {
  }
  void start() {
  }
}
