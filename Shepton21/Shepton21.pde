import shiffman.box2d.*;

import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;


ShowManager showManager;

void setup() {

  noCursor();
  fullScreen(P3D, 1);
  //size(1024, 768, P3D);

  frameRate(40);

  background(0);
  setColorMode();


  // setup box2d
  box2d.createWorld();

  showManager = new ShowManager();
}

void keyPressed()
{
  showManager.keyPressed();
}

void draw() {
  showManager.draw();
}

class ShowManager {
  private final float rotInc = 0.01;

  private Show currentShow;
  private final Show[] showList;
  private int cX;
  private int cY;
  private Settings settings;
  private Window window;

  ShowManager() {
    settings = new Settings();
    window = new Window(settings);

    cX = int((width-settings.nX*settings.w)*0.5);
    cY = int((height-settings.nY*settings.h)*0.5);

    showList = new Show[5];

    showList[0]= new CheckerBoardShow(settings);
    showList[1] = new AnagramShow(settings);
    showList[2] = new PictureShow(settings);
    showList[3] = new MurmurationShow(settings);
    showList[4] = new AppleShow(settings);

    setShow(settings.showIndex);
  }

  void keyPressed()
  {
    if (key == 's') {
      settings.save();
    }
    if (key == CODED) {
      switch(keyCode) {
      case RIGHT:
        settings.rotY+=rotInc;
        break;
      case LEFT:
        settings.rotY-=rotInc;
        break;
      case UP:
        settings.rotX += rotInc;
        break;
      case DOWN:
        settings.rotX -= rotInc;
        break;
      }
    } else {
      if (key >=48 && key <=57) {
        showManager.setShow(key-48);
      }
    }
  }

  void draw() {
    currentShow.update();

    background(0);
    //lights();
        //clip(0,0, 400,400);
        
    noStroke();
    pushMatrix();
    translate(cX, cY, 0);
    rotateY(settings.rotY);
    rotateX(settings.rotX);

    currentShow.draw();
    window.drawFrame();

    popMatrix();
  }

  void setShow(int index) {
    if (index < 0 || index >= showList.length) {
      println("Invalis show", index);
      index = 0;
    } 
    
    settings.showIndex = index;

    if (currentShow != null) {
      currentShow.stop();
    }

    currentShow = showList[index];
    currentShow.start();
    println("SetShow", index);
  }
}
