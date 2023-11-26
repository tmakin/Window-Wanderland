class CheckerBoardShow extends Show {
  final int ticksPerLoop = 500;
  int loopTicks = 0;
  
  int ticks = 0;
  final int cycleTicks = 3;

  Window window;
  CheckerBoardShow(Settings settings) {
    super(settings); 
    window = new Window(settings);
  }

  void update() {
    loopTicks++;
    if(loopTicks > ticksPerLoop) {
      nextLoop(); 
      loopTicks=0;
    }
    
    ticks++;
    if(ticks < cycleTicks) {
      return; 
    }
    ticks = 0;

    for (int k = 0; k < settings.n; k++) {
      var c = genColor(); 
      window.boxes[k].setColor(c);
    }
  }

  void draw() {
    window.draw();
  }

  void start() {
  }
}
