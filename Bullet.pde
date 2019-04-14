class Bullet{

PVector pos;
PVector vel;
int lifespan = round(height * 0.1);  
float speed = 10;
boolean off = false;
  
Bullet(PVector startPos){
    pos = startPos.copy();
    vel = new PVector(0, -speed);
}

void move(){
  lifespan --;
  if (lifespan < 0) {
    off = true;
  } else {
    pos.add(vel);
  }
}

void show(){
  if (!off){   
    fill(255);
    rect(pos.x, pos.y, 5, 5);
  }
}

}
