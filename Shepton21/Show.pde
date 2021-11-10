abstract class Show {
  Settings settings;
  Integer loopCount=0;
  
  Show(Settings settings_) {
    settings = settings_;
  }


  abstract void update();
  abstract void start();
  abstract void draw();
  
  void nextLoop() {
    loopCount++; 
    println("Loop count=", loopCount);
  }
  
  void resetLoops() {
     loopCount=0; 
  }
}
