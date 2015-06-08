final int BRANCH_ROOT = 0,
          BRANCH_LEFT = -1,
          BRANCH_RIGHT = 1,
          
          BRANCH_MAX_LEVELS = 3;

class Tree {
  Branch root;
  
  Tree(float x, float y, float w, float h, float time) {
    root = new Branch(x, y, w, h, BRANCH_ROOT, 1, time);
  }
  
  void draw() {
    root.drawLeaves();
    root.drawBranches();
  }
}

class Branch {
  float segmentX = 0, segmentY = 0;
  float leafWidth = 0, leafHeight = 0;
  float rootX = 0, rootY = 0;
  float time;
  ArrayList<Branch> branches;
  
  Branch(float x, float y, float w, float h, int side, int level, float t) {
    rootX = x;
    rootY = y;
    
    time = t;
    
    branches = new ArrayList<Branch>();
    
    if (side == BRANCH_ROOT) {
      segmentX = x+(random(w*0.6)-w*0.3);
      segmentY = y-h*0.75+(random(h*0.3)-h*0.15);
    } else if (side == BRANCH_LEFT) {
      segmentX = x-random(w*0.3);
      segmentY = y-h*0.75+(random(h*0.3)-h*0.15);
    } else if (side == BRANCH_RIGHT) {
      segmentX = x+random(w*0.3);
      segmentY = y-h*0.75+(random(h*0.3)-h*0.15);
    }
    
    leafWidth = random(w*0.6)+w*0.3;
    leafHeight = random(h*0.6)+h*0.3;
    
    if (level < 3) {
      for (int i=0; i<BRANCH_MAX_LEVELS; i++) {
        if (random(10) >= 7) {
          float branchY = random(segmentY, y);
          float branchX = x + ((segmentX - x)/(segmentY - y)) * (branchY - y);
          int branchDir = random(10) > 5 ? BRANCH_LEFT : BRANCH_RIGHT;
          branches.add(new Branch(branchX, branchY, w*0.6, h*0.5, branchDir, level+1, time));
        }
      }
    }
  }
  
  void drawLeaves() {
    noStroke();
    color leafColor;
    if (time < 0.5) {
      leafColor = lerpColor(#FFD1D1, #F2C975, map(time, 0, 0.5, 0, 1));
    } else {
      leafColor = lerpColor(#D5BCE0, #56627C, map(time, 0.5, 1, 0, 1));
    }
    fill(leafColor);
    ellipse(segmentX, segmentY, leafWidth, leafHeight);
    
    for (Branch b : branches) {
      b.drawLeaves();
    }
  }
  
  void drawBranches() {
    color branchColor;
    if (time < 0.5) {
      branchColor = lerpColor(#79504E, #866A59, map(time, 0, 0.5, 0, 1));
    } else {
      branchColor = lerpColor(#635774, #635774, map(time, 0.5, 1, 0, 1));
    }
    
    strokeWeight((rootY - segmentY)/20);
    stroke(branchColor);
    line(rootX, rootY, segmentX, segmentY);
    
    for (Branch b : branches) {
      b.drawBranches();
    }
  }
}
