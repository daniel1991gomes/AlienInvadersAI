class Enemy {
  
PVector pos; 
PVector vel;
PVector acc;
boolean movingDown = false;
int w = 100;
int h = 30;
  
Enemy(float posX, float posY){
  
  
  pos = new PVector(posX , posY);
  vel = new PVector(2,0);

}  
  
void show(){
  noFill();
  stroke(255);
  rect(pos.x, pos.y, w, h);
}

 void polygon(float x, float y, float radius, int npoints) {
    float angle = TWO_PI / npoints;//set the angle between vertexes
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {//draw each vertex of the polygon
      float sx = x + cos(a) * radius;//math
      float sy = y + sin(a) * radius;//math
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
  
void move(){
    vel = new PVector(0, 2);
    vel.limit(5); 
    pos.add(vel);
    
  
  /* sideways and down and sideways and down...
  if ( pos.x > width - 10 - w && !movingDown){
    vel = new PVector(0, 10);
    vel.limit(5); 
    pos.add(vel);
    vel = new PVector(-2, 0);
    movingDown = true;
  } else if (pos.x < 10 + w && !movingDown){
    vel = new PVector(0, 10);
    vel.limit(5); 
    pos.add(vel);
    vel = new PVector(2, 0);
    movingDown = true;
  } else {
    pos.add(vel);
    movingDown = false;
  }
  */
}

boolean checkIfHit(PVector bulletPos) {
  if (bulletPos.x >= pos.x && bulletPos.y >= pos.y && bulletPos.x <= (pos.x + w) && bulletPos.y <= (pos.y +h)) {
    isHit();
    return true;
  }
  return false;
}


boolean lookForHit(PVector bulletPos) {
  if (bulletPos.x >= pos.x && bulletPos.y >= pos.y && bulletPos.x <= (pos.x + w) && bulletPos.y <= (pos.y +h)) {
    return true;
  }
  return false;
  
}

  
void isHit(){
  return;
}
    
  


}
