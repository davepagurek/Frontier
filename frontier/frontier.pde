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
  
  //Mountains mountains = new Mountains(height*0.2, height*0.7, #D36F6F, #AD1515);
  color start = lerpColor(#F7ABA2, #A2F1F7, random(0, 1));
  color end = lerpColor(#F53E6F, #1B0BB4, random(0, 1));
  Mountains mountains = new Mountains(height*0.2, height*0.7, start, end);
  mountains.draw();
  
  //Building building = new Building(width/2, height, width/3, height/2);
  //building.draw();
}
