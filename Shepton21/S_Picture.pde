String[] imageFiles = {"apple.png", "tree.jpg", "mountains.jpg", };

class PictureShow extends Show {

  PImage img;
  int ticks = 0;
  int numHidden = 0;
  IntList displayOrder;

  Window window;
  Rect windowRect;
  int n = imageFiles.length;
  PImage[] images = new PImage[n];
  int imageIndex = 0;

  boolean hide = true;
  boolean loaded = false;
  PictureShow(Settings settings) {
    super(settings); 

    window = new Window(settings);
    windowRect = window.getRect();
    displayOrder = new IntList();
  }

  void loadImages() {
    for (int i=0; i < n; i++) {
      images[i] = processImage(loadImage("images/"+imageFiles[i]));
    }
    loaded = true;
  }

  PImage processImage(PImage img) {
    double windowRatio = (double)windowRect.Height/(double)windowRect.Width;
    double imageRatio = (double)img.height/(double)img.width;

    println(windowRatio, imageRatio);

    if (imageRatio > imageRatio) {
      int newHeight = (int)Math.floor(windowRatio*img.width);
      int y = (img.height-newHeight)/2;
      println("Image too tall", img.height);
      println("newHeight", newHeight);
      img = img.get(0, y, img.width, newHeight);
    } else {

      int newWidth = (int)Math.floor(img.height/windowRatio);
      int x = (img.width-newWidth)/2;
      println("Image too wide", img.width);
      println("newWidth", newWidth);
      img = img.get(x, 0, newWidth, img.height);
    }

    img.resize(windowRect.Width, windowRect.Height);

    return img;
  }

  void nextImage() {
    imageIndex++;
    if (imageIndex >= n) {
      imageIndex = 0;
    }
  }

  void hideNextBox() {
    if (numHidden < displayOrder.size()) {
      int index = displayOrder.get(numHidden);

      if (hide) {
        window.boxes[index].fadeOut();
      } else {
        window.boxes[index].fadeIn();
      }
    }
    numHidden++;

    if (numHidden > 30) {
      if (hide) {
        numHidden = 0;
        hide = !hide;
      } else {
        start();
        nextImage();
      }
    }
  }

  void update() {
    ticks++;
    if (ticks > 10) {
      ticks = 0;
      hideNextBox();
    }
  }

  void draw() {
    imageMode(CORNER);
    image(images[imageIndex], 0, 0);

    translate(0, 0, 0.01);
    window.draw();
    window.drawFrame();
  }
  void stop() {
  }
  void start() {
    if (!loaded) {
      loadImages();
    }
    color black = color(0, 0, 0);

    displayOrder.clear();
    for (int k = 0; k <settings.n; k++) {
      window.boxes[k].setColor(black);
      window.boxes[k].setAlpha(255);
      displayOrder.append(k);
    }
    displayOrder.shuffle();
    numHidden = 0;
    hide = true;
    ticks = 0;

    println("Pictureshow started");
  }
}
