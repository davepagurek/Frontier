final int BUILDING_TOP = 0,
          BUILDING_LEFT = -1,
          BUILDING_RIGHT = 1,
          BUILDING_MAX_LEVELS = 2;

class Building {
  ArrayList<BuildingUnit> units;
  
  Building(float x, float y, float w, float h) {
    units = new ArrayList<BuildingUnit>();
    
    int numUnits = int(random(1, 2));
    for (int i = 0; i < numUnits; i++) {
      float unitWidth = random(0.5, 1.5)*(w/numUnits);
      units.add(new BuildingUnit(
        x - w/2 + i*(w/numUnits) - unitWidth/2,
        y,
        unitWidth,
        random(h*0.2, h),
        BUILDING_TOP,
        1
      ));
    }
  }
  
  void draw() {
    for (BuildingUnit b: units) {
      b.draw();
    }
  }
}

class BuildingUnit {
  float unitX = 0,
        unitY = 0,
        unitWidth = 0,
        unitHeight = 0,
        offsetLeft = 0,
        offsetRight = 0,
        offsetRoof = 0,
        stiltLength = 0;
  int unitLevel = 0,
      unitSide = 0;
  ArrayList<BuildingUnit> units;
  
  BuildingUnit(float x, float y, float w, float h, int side, int level) {
    units = new ArrayList<BuildingUnit>();
    unitX = x;
    unitY = y;
    unitWidth = w;
    unitHeight = h;
    unitSide = side;
    offsetLeft = random(-0.1*w, 0.1*w);
    offsetRight = random(-0.1*w, 0.1*w);
    offsetRoof = random(0.1*w, 0.3*w);
    unitLevel = level;
    if (level > 1) {
      stiltLength = random(h * 0.2, h * 0.5);
    }
    
    if (level < 3) {
      for (int i=0; i<BUILDING_MAX_LEVELS; i++) {
        if (random(10) >= 5) {
          float branchWidth = random(0.2*unitWidth, 0.8*unitWidth);
          float branchHeight = random(0.2*unitHeight, 0.8*unitHeight);
          float branchX = 0;
          float branchY = 0;
          
          int branchSide = int(random(-2, 2));
          if (branchSide == BUILDING_TOP) {
            branchX = random(x - w/2 + branchWidth/2, x + w/2 - branchWidth/2);
            branchY = y - h;
          } else if (branchSide == BUILDING_LEFT) {
            branchX = x - w/2 - branchWidth/2 + w*0.2;
            branchY = random(y - 0.2*h, y - 0.8*h);
          } else if (branchSide == BUILDING_RIGHT) {
            branchX = x + w/2 + branchWidth/2 - w*0.2;
            branchY = random(y - 0.2*h, y - 0.8*h);
          } else {
            return;
          }
          
          units.add(new BuildingUnit(branchX, branchY, branchWidth, branchHeight, branchSide, level+1));
        }
      }
    }
  }
  
  void draw() {
    for (BuildingUnit b: units) {
      b.draw();
    }
    
    if (stiltLength > 0) {
      strokeWeight(unitWidth/20);
      stroke(#776F7E);
      if (unitSide == BUILDING_TOP) {
        line(unitX - unitWidth*0.3, unitY, unitX - unitWidth*0.3, unitY - stiltLength);
        line(unitX + unitWidth*0.3, unitY, unitX + unitWidth*0.3, unitY - stiltLength);
      } else if (unitSide == BUILDING_LEFT) {
        line(unitX - unitWidth*0.4, unitY - stiltLength, unitX + unitWidth/2, unitY);
      } else if (unitSide == BUILDING_RIGHT) {
        line(unitX + unitWidth*0.4, unitY - stiltLength, unitX - unitWidth/2, unitY);
      } 
    }
    
    noStroke();
    
    //Main building
    fill(unitLevel % 2 == 0 ? #AD9592 : #BFABA9);
    beginShape();
    vertex(unitX - unitWidth/2, unitY - stiltLength);
    vertex(unitX + unitWidth/2, unitY - stiltLength);
    vertex(unitX + unitWidth/2 + offsetRight, unitY - unitHeight * 0.85);
    vertex(unitX - unitWidth/2 + offsetLeft, unitY - unitHeight * 0.85);
    endShape(CLOSE);
    
    //Roof
    fill(#685D71);
    beginShape();
    vertex(unitX - unitWidth/2 + offsetLeft - offsetRoof, unitY - unitHeight * 0.85);
    vertex(unitX + unitWidth/2 + offsetRight + offsetRoof, unitY - unitHeight * 0.85);
    vertex(unitX + unitWidth/2 + offsetRight, unitY - unitHeight);
    vertex(unitX - unitWidth/2 + offsetLeft, unitY - unitHeight);
    endShape(CLOSE);
  }
}
