// color params consistent with processing HSB color picker
final int H_MAX = 355;
final int S_MAX = 100;
final int B_MAX = 100;

public void setColorMode(){
   colorMode(HSB, H_MAX, S_MAX, B_MAX); 
}

public color genColor() {
  int h = (int)random(H_MAX);
  h = 0;
  int s = (int)random(S_MAX/2, S_MAX);
  int b = (int)random(0, B_MAX/2);
  return color(h, s, b);
} 
