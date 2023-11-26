class Rect {
  int Left, Top;
  int Width, Height;
  int Bottom, Right;

  PVector center;
  PVector origin;

  public Rect(int left, int top, int boxWidth, int boxHeight) {
    Width = boxWidth;
    Height = boxHeight;

    setPos(left, top);
  }

  void setPos(int left, int top) {

    Left = left;
    Top = top;

    Bottom = Top + Height;
    Right = Left + Width;

    center = new PVector((left+Right)*0.5, (top+Bottom)*0.5);
    origin = new PVector(left, top);
  }

  void drawRect() {
    rectMode(PConstants.CORNER);
    rect(Left, Top, Width, Height);
  }

  Boolean contains(float x, float y) {
    return x >= Left && x <= Right && y >= Top && y <= Bottom;
  }

  Boolean contains(PVector p) {
    return contains(p.x, p.y);
  }

  PVector getPoint(float sX, float sY) {
    return new PVector(Left + sX*Width, Top + sY*Height);
  }
  
  PVector getRandomPoint() {
    return getPoint(random(1), random(1));
  }

  Rect clone() {
    return new Rect(Left, Top, Width, Height);
  }
}
