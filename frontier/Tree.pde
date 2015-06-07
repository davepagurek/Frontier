final int BRANCH_ROOT = 0,
          BRANCH_LEFT = -1,
          BRANCH_RIGHT = 1,
          
          BRANCH_MAX_LEVELS = 3;

class Tree {
  Branch root;
  
  Tree(float x, float y, float w, float h) {
    root = new Branch(x, y, w, h, BRANCH_ROOT, 1);
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
  ArrayList<Branch> branches;
  
  Branch(float x, float y, float w, float h, int side, int level) {
    rootX = x;
    rootY = y;
    
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
          branches.add(new Branch(branchX, branchY, w*0.6, h*0.5, branchDir, level+1));
        }
      }
    }
  }
  
  void drawLeaves() {
    noStroke();
    fill(#F2B7B5);
    ellipse(segmentX, segmentY, leafWidth, leafHeight);
    
    for (Branch b : branches) {
      b.drawLeaves();
    }
  }
  
  void drawBranches() {
    strokeWeight((rootY - segmentY)/20);
    stroke(#79504E);
    line(rootX, rootY, segmentX, segmentY);
    
    for (Branch b : branches) {
      b.drawBranches();
    }
  }
}
