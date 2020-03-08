class Rect {
  int Left, Top;
  int Width, Height;
  int Bottom, Right;
  
  PVector center;
  
  public Rect(int left, int top, int boxWidth, int boxHeight) {
    Left = left;
    Top = top;
    Width = boxWidth;
    Height = boxHeight;
    
    Bottom = Top + Height;
    Right = Left + Width;
    
    center = new PVector((left+Right)*0.5, (top+Bottom)*0.5);
  }
 
  
  void display() {
     rect(Left, Top, Width, Height);
  }
  
  Boolean contains(float x, float y) {
    return x >= Left && x <= Right && y >= Top && y <= Bottom; 
  }
}
