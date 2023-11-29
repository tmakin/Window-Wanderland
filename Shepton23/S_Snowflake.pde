// Coding Challenge 127: Brownian Motion Snowflake
// Daniel Shiffman
// https://thecodingtrain.com/CodingChallenges/127-brownian-snowflake.html
// https://youtu.be/XUA8UREROYE
// https://editor.p5js.org/codingtrain/sketches/SJcAeCpgE

class SnowflakeShow extends Show  {
 
  ArrayList<Snowflake> snowflakes;

  float hue = 300;
  int ticks=1000;

  Window window;
  SnowflakeShow(Settings settings) {
    super(settings); 
    window = new Window(settings);
    
    regen();
  }
  
  void start() {
  }
  
  void regen() {
    snowflakes = new ArrayList<Snowflake>();
    
    for( var box : window.boxes) {
        box.brightnessInc = random(0.1,0.2);
    }
    
    for(var rect : window.boxes) {
      snowflakes.add(new Snowflake(rect.box.center, rect.box.Width));
    }
  }

  void update() {
    hue+=0.1;
    if(hue > 355) {
      hue =0;
    }
    
    for( var box : window.boxes) {
      box.updateBrightness();
      var c = color(hue, S_MAX*0.75, box.brightness);
      box.setColor(c);
    }
    
    for(var snowflake : snowflakes) {
       snowflake.update();
    } 
  }
          
  void draw() {
    ticks++;
    //var showText = ticks < 500;
    var showText = false;
    
    if(ticks > 2000) {
       ticks = 0; 
    }
    
    window.draw();
      
    for(var i=0; i < snowflakes.size(); i++) {
      if(showText && i==2) {
         continue; 
      }
       var snowflake = snowflakes.get(i);
       snowflake.draw();
    } 
    
    if(showText) {
        drawText();
    }
  }
  
  void drawText() {
    fill(0,0,100);
    textSize(20);
    textAlign(RIGHT);
    var x = 3*window.boxes[0].box.Width-10;
    text("window",x, 30); 
    text("wanderland", x, 50);
    
    textSize(15);
    text("shepton mallet", x, 90); 
    text("2023", x, 110); 
 
  }
}
