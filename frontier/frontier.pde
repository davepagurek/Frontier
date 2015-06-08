void setup() {
  size(1280, 720);
  drawScene();
}

void draw() {
}

void mousePressed() {
  drawScene();
}

void drawScene() {
  background(255);
  
  float time = random(1);
  
  Sky sky = new Sky(time);
  sky.draw();
  
  Mountains mountains = new Mountains(height*0.2, height*0.7, time);
  mountains.draw();
}
