abstract class Show {
  Settings settings;
  Show(Settings settings_) {
    settings = settings_;
  }


  abstract void update();
  abstract void stop();
  abstract void start();
  abstract void draw();
}
