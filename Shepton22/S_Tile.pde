String[] imageFiles = { "sheep.jpg", "babycham.jpg", "heart.jpg", "anglo.jpg", "snowdrops.jpg"};

class TileShow extends Show {
  float ticksPerImage = 15;
  int numSteps = 20;
  float ticks = 0;
  IntList tileOrder;

  Window window;
  Rect windowRect;
  int n = imageFiles.length;
  PImage[] tiles;
  PImage[][] originalTiles;

  int endFrames = 0;
  int endFramesMax = 5;
  int activeImageIndex = 0;

  boolean loaded = false;
  TileShow(Settings settings) {
    super(settings); 

    window = new Window(settings);
    windowRect = window.getRect();
    tileOrder = new IntList();
    originalTiles = new PImage[imageFiles.length][];
    tiles = new PImage[settings.n];
  }

  void loadTiles() {
    for(var i = 0 ; i < imageFiles.length; i++) {
      originalTiles[i] = processImage(loadImage("images/"+imageFiles[i]));
    }
    loaded = true;
  }

  PImage[] processImage(PImage img) {
    double windowRatio = (double)windowRect.Height/(double)windowRect.Width;
    double imageRatio = (double)img.height/(double)img.width;

    println(windowRatio, imageRatio);

    double scaleY = (double)windowRect.Height/(double)img.height;
    img.resize((int)(scaleY*img.width), (int)(scaleY*img.height));
    
    var xOffset = (img.width - windowRect.Width)/2;
    
    var tiles = new PImage[settings.n];
    for (int k = 0; k < settings.n; k++) {
      Rect box = window.boxes[k].box;
      PImage tileImage = img.get(xOffset + box.Left, box.Top, box.Width, box.Height); 
      tiles[k] = tileImage;
    }

    return tiles;
  }
  
  int getRandomIncrement() {
    return random(0,1) < 0.5 ? -1 : 1; 
  }
  
  int getNeighbour(int index, int count) {
    while(true) {
       var inc = random(0,1) < 0.5 ? -1 : 1;
       int nextIndex = index + inc;
       if(nextIndex >= 0 && nextIndex < count) {
          return nextIndex; 
       }
    }
  }
  
  void initTransitions(int count) {
    for(var k = 0 ; k < settings.n; k++) {
        tiles[k] = originalTiles[activeImageIndex][k];
    }
    
    tileOrder.clear();
    tileOrder.append(settings.n-1); //last tile is blank e.g. 9
    
    var p = 0;
    while(p < count) {
      var k0 = tileOrder.get(p); //e.g. 9
      var i0 = k0 % settings.nX; 
      var j0 = (k0 - i0) / settings.nX; 
      
      var vert = random(0,1) < 0.5;
      var i1 = vert ? i0 : getNeighbour(i0, settings.nX);
      var j1 = vert ? getNeighbour(j0, settings.nY) : j0;
      var k1 = j1*settings.nX + i1;
      
      var kPrev = p > 0 ? tileOrder.get(p-1) : -1;
      
      // dont' return to previous value
      if(k1 == kPrev) {
         continue;
      }

      tileOrder.append(k1);
      
      // swap tiles
      var temp = tiles[k0];
      tiles[k0] = tiles[k1];
      tiles[k1] = temp;
      p++;
    }
  }

  void update() {
    ticks++;
    if (ticks > ticksPerImage) {
      ticks = 0;
      
      var lastIndex = tileOrder.size()-1;
      if(lastIndex > 0) {
         var k0 = tileOrder.get(lastIndex-1);
         var k1 = tileOrder.get(lastIndex);
         
         var temp = tiles[k0];
         tiles[k0] = tiles[k1];
         tiles[k1] = temp;;
      }
      if(lastIndex >= 0) {
         tileOrder.remove(lastIndex);
      }
      if(lastIndex < 0) {
         endFrames++; 
         
         if(endFrames > endFramesMax) {
           nextLoop();    
         }
      }
    }
  }

  void drawTile(int tileIndex) {
    var size = tileOrder.size();
    var emptyTileIndex = size < 1 ? -1 : tileOrder.get(size-1); 
    var activeTileIndex = size < 2 ? -1: tileOrder.get(size-2); 
    if(tileIndex == emptyTileIndex) {
      return;
    }
    
    var tile = tiles[tileIndex];

    var box = window.boxes[tileIndex].box;
    var x = box.Left;
    var y = box.Top;
    
    if(tileIndex == activeTileIndex) {
      var targetIndex = tileOrder.get(size-1);
      var targetBox = window.boxes[targetIndex].box;
      
      float f = ticks/ticksPerImage;

      x += f*(targetBox.Left - box.Left);
      y += f*(targetBox.Top - box.Top);
    }
    image(tile, x, y);
  }

  void draw() {
    imageMode(CORNER);
    
    for(var k = 0 ; k < settings.n; k++) {
        drawTile(k);
    }

    //window.draw();
  }

  void start() {
    if (!loaded) {
      loadTiles();
    }
    endFrames = 0;
    ticks = 0;
    activeImageIndex++;
    if(activeImageIndex >= imageFiles.length) {
      activeImageIndex = 0;
    }
    //activeImageIndex = (int)random(0, imageFiles.length); 
    initTransitions(numSteps);
  }
}
