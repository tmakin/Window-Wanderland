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


  private final Show[] showList;
  private int cX;
  private int cY;
  private Settings settings;
  private Window window;
  
  private Show currentShow;
  private int showSettingsIndex = -1;
  //private int showSettingsIndex = 2;
  private ShowSettings currentShowSettings = null;

  ShowManager() {
    settings = new Settings();
    window = new Window(settings);

    cX = int((width-settings.nX*settings.w)*0.5);
    cY = int((height-settings.nY*settings.h)*0.5);

    showList = new Show[5];

    showList[0] = new CheckerBoardShow(settings);
    showList[1] = new AppleShow(settings);
    showList[2] = new MurmurationShow(settings);
    showList[3] = new PictureShow(settings);
    showList[4] = new AnagramShow(settings);
    

    nextShow();
  }

  void keyPressed()
  {
    if (key == 's') {
      settings.save();
    }
    else if(key == 'n') {
        nextShow(); 
      }
    else if (key == CODED) {
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

    if (currentShowSettings != null && currentShow.loopCount >= currentShowSettings.duration) {
      println("Next show");
      nextShow();
    }

    currentShow.update();

    background(0);

    noStroke();
    pushMatrix();
    translate(cX, cY, 0);
    rotateY(settings.rotY);
    rotateX(settings.rotX);

    currentShow.draw();
    window.drawFrame();

    popMatrix();
  }
  
  void nextShow() {
    showSettingsIndex++;
    
    if(showSettingsIndex >= settings.showList.size()) {
       showSettingsIndex = 0;
    }
    
    currentShowSettings = settings.showList.get(showSettingsIndex);
    setShow(currentShowSettings.index); 
  }

  void setShow(int index) {
    if (index < 0 || index >= showList.length) {
      println("Invalid show", index);
      index = 0;
    } 

    currentShow = showList[index];
    currentShow.start();
    currentShow.resetLoops();
    println("SetShow", index);
  }
}
