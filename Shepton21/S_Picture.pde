String[] imageFiles = { "sheep.jpg", "babycham.jpg", "prison.jpg", "anglo.jpg", "snowdrops.jpg"};

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
  float x = 0;
  float xMax = 0;
  int ticksPerImage = 680;
  float speed = 0;
  int imageTicks = 0;

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
    updateImageSpeed();
  }

  PImage processImage(PImage img) {
    double windowRatio = (double)windowRect.Height/(double)windowRect.Width;
    double imageRatio = (double)img.height/(double)img.width;

    println(windowRatio, imageRatio);

    double scaleY = (double)windowRect.Height/(double)img.height;
    img.resize((int)(scaleY*img.width), (int)(scaleY*img.height));

    return img;
  }

  void updateImageSpeed() {
    x = 0;
    
    PImage img = images[imageIndex];
    xMax = img.width-windowRect.Width;
    speed = (float)xMax/(float)ticksPerImage;
   
  }
  
  void nextImage() {
     // println("imageTicks", imageTicks);
    imageTicks = 0;
    imageIndex++;

    
    if (imageIndex >= n) {
      imageIndex = 0;
      nextLoop(); 
    }
    
        updateImageSpeed();
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
    imageTicks++;
    if (ticks > 10) {
      ticks = 0;
      hideNextBox();
    }
    
    if(x < xMax) {
      x+=speed;
      
      //println("x", x);
      //println("speed", speed);
      //println("xMax", xMax);
    }
  }

  void draw() {
    imageMode(CORNER);
    
    PImage img = images[imageIndex];
    image(img, -x, 0);

    translate(0, 0, 0.01);
    window.draw();
    
    // draw boxes to mask overlapping images
    fill(0);
    int margin = 1+(width-windowRect.Width)/2;
    rect(-margin, 0, margin, height);
    rect(windowRect.Width, 0, margin, height);
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
  }
}
