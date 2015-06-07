class Sky {
  color sky, horizon;
  final int Y_AXIS = 1,
            X_AXIS = 2;
  
  Sky() {
    sky = #AAF7E1;
    horizon = #D3F7AA;
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
    }  
    else if (axis == X_AXIS) {  // Left to right gradient
      for (int i = x; i <= x+w; i++) {
        float inter = map(i, x, x+w, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(i, y, i, y+h);
      }
    }
  }
}
