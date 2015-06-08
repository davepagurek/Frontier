class Sky {
  color sky, horizon;
  final int Y_AXIS = 1,
            X_AXIS = 2;
  
  Sky(float time) {
    if (time < 0.5) {
      sky = lerpColor(#B9F7D5, #57C8F0, map(time, 0, 0.5, 0, 1));
      horizon = lerpColor(#FCED42, #E365ED, map(time, 0, 0.5, 0, 1));
    } else {
      sky = lerpColor(#C282E5, #1A285A, map(time, 0.5, 1, 0, 1));
      horizon = lerpColor(#82E3E5, #BFE1FC, map(time, 0.5, 1, 0, 1));
    }
  }
  
  void draw() {
   setGradient(0, 0, width, height, sky, horizon, Y_AXIS); 
  }
  
  private void setGradient(int x, int y, float w, float h, color c1, color c2, int axis) {
    noFill();
  
    if (axis == Y_AXIS) {  // Top to bottom gradient
      for (int i = y; i <= y+h; i++) {
        float inter = map(i, y, y+h, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(x, i, x+w, i);
      }
    } else if (axis == X_AXIS) {  // Left to right gradient
      for (int i = x; i <= x+w; i++) {
        float inter = map(i, x, x+w, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(i, y, i, y+h);
      }
    }
  }
}
