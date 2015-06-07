int Y_AXIS = 1;
int X_AXIS = 2;

int BRANCH_ROOT = 0;
int BRANCH_LEFT = 1;
int BRANCH_RIGHT = -1;

void setup() {
  size(640, 360);
  drawScene();
}

void draw() {
}

void mousePressed() {
  drawScene();
}

void drawScene() {
  setBackground();
  drawTree(width/2, height, width/2, height*0.75);
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {
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

void setBackground() {
  setGradient(0, 0, width, height, #AAF7E1, #D3F7AA, Y_AXIS);
}

void drawTree(float x, float y, float w, float h) {
  drawBranch(x, y, w, h, BRANCH_ROOT, 1);
}

void drawBranch(float x, float y, float w, float h, float side, int level) {

  //int segments = random(3);
  float segmentX, segmentY;
  if (side == BRANCH_ROOT) {
    segmentX = x+(random(w*0.6)-w*0.3);
    segmentY = y-h*0.75+(random(h*0.3)-h*0.15);
  } else if (side == BRANCH_LEFT) {
    segmentX = x-random(w*0.3);
    segmentY = y-h*0.75+(random(h*0.3)-h*0.15);
  } else if (side == BRANCH_RIGHT) {
    segmentX = x+random(w*0.3);
    segmentY = y-h*0.75+(random(h*0.3)-h*0.15);
  } else {
    return;
  }
  
  noStroke();
  fill(#F2B7B5);
  ellipse(segmentX, segmentY, random(w*0.6)+w*0.3, random(h*0.6)+h*0.3);
  
  if (level < 3) {
    for (int i=0; i<3; i++) {
      if (random(10) >= 7) {
        float branchY = random(segmentY, y);
        float branchX = x + ((segmentX - x)/(segmentY - y)) * (branchY - y);
        int branchDir = random(10) > 5 ? BRANCH_LEFT : BRANCH_RIGHT;
        drawBranch(branchX, branchY, w*0.6, h*0.5, branchDir, level+1);
      }
    }
  }
  
  strokeWeight(h/20);
  stroke(#79504E);
  line(x, y, segmentX, segmentY);
}
