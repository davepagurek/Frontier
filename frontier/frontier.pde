void setup() {
  size(900, 500);
  drawScene();
}

void draw() {
}

void mousePressed() {
  drawScene();
}

void drawScene() {
  background(255);
  
  Sky sky = new Sky();
  sky.draw();
  
  Mountains mountains = new Mountains(height*0.2, height*0.7, #D36F6F, #AD1515);
  mountains.draw();
  
  //Tree tree = new Tree(width/2, height, width/2, height*0.75);
  //tree.draw();
}
