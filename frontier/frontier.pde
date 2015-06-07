

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
  Sky sky = new Sky();
  sky.draw();
  
  Tree tree = new Tree(width/2, height, width/2, height*0.75);
  tree.draw();
}
