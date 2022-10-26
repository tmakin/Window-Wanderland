// color params consistent with processing HSB color picker
final int H_MAX = 355;
final int S_MAX = 100;
final int B_MAX = 100;

public void setColorMode(){
   colorMode(HSB, H_MAX, S_MAX, B_MAX); 
}

public color genColor() {
  int h = (int)random(H_MAX);
  int s = (int)random(S_MAX/2, S_MAX);
  return color(h, s, B_MAX);
} 
