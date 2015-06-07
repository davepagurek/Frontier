class Mountains {
  int layers = 0;
  float heightUnit = 0;
  color start, end;
  ArrayList<MountainRange> ranges;
  
  Mountains(float top, float bottom, color s, color e) {
    start = s;
    end = e;
    layers = int(random(2, 5));
    heightUnit = (bottom - top)/(layers+1);
    
    ranges = new ArrayList<MountainRange>();
    
    for (int l = 0; l < layers; l++) {
      float y = top + random(heightUnit*l, heightUnit*(l+1));
      float spread = random(2, 4)*heightUnit;
      ranges.add(new MountainRange(y, spread, lerpColor(start, end, float(l)/layers), float(l+1)/layers));
    }
  }
  
  void draw() {
    for (MountainRange range : ranges) {
      range.draw();
    }
  }
}

class MountainRange {
  ArrayList<Float> elevation;
  ArrayList<Tree> trees;
  ArrayList<Building> buildings;
  float rangeY = 0;
  color rangeColor;
  
  MountainRange(float y, float spread, color c, float foreground) {
    rangeY = y;
    rangeColor = c;
    elevation = new ArrayList<Float>();
    trees = new ArrayList<Tree>();
    buildings = new ArrayList<Building>();
    
    float noiseElevation = random(1, 100);
    //float spikiness = random(20, 50);
    float spikiness = random(1, 5);
    
    for (int x = 0; x < 80; x++) {
      elevation.add(map(noise(float(x)/spikiness, noiseElevation), 0, 1, -1, 1) * spread);
    }
    
    int numTrees = int(random(1, map(1.0/foreground, 1, 100, 5, 40)));
    for (int i = 0; i < numTrees; i++) {
      int location = int(random(elevation.size()));
      trees.add(new Tree(
        (float(location)/(elevation.size()-1))*width,
        rangeY + elevation.get(location),
        foreground*100,
        foreground*80
      ));
    }
    
    int numBuildings = int(random(1, map(1.0/foreground, 1, 100, 0, 10)));
    for (int i = 0; i < numTrees; i++) {
      int location = int(random(elevation.size()));
      buildings.add(new Building(
        (float(location)/(elevation.size()-1))*width,
        rangeY + elevation.get(location) + spread*0.2,
        foreground*100,
        foreground*150
      ));
    }
  }
  
  void draw() {
    for (Building building : buildings) {
      building.draw();
    }
    
    noStroke();
    fill(rangeColor);
    beginShape();
    for (int i = 0; i < elevation.size(); i++) {
      vertex((float(i)/(elevation.size()-1))*width, rangeY + elevation.get(i));
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
    
    for (Tree tree : trees) {
      tree.draw();
    }
  }
}
