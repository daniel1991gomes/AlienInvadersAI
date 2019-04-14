class Ship {

PVector pos; 
PVector vel;
PVector acc;
int sizeX = 20;
int sizeY = 20;
NeuralNet brain;
int score = 1;
boolean dead;
int lifespan = 0;
boolean canShoot = true;
int shootCount = 0;
int maxShootCount = 100;

ArrayList<Bullet> bullets = new ArrayList<Bullet>(); //the bullets currently on screen
ArrayList<Enemy> enemies = new ArrayList<Enemy>(); //the enemies currently on screen

int immortalCount = 0;

float[] decision = new float[3];

int shotsFired = 0;
int shotsHit = 0;

float[] vision = new float[8];

float fitness = 10.0;
int lives = 1;

boolean replay = false;//whether the player is being replayed 
//since enemies are spawned randomly when replaying the ship we need to use a random seed to repeat the same randomness
long SeedUsed; //the random seed used to intiate the asteroids
ArrayList<Long> seedsUsed = new ArrayList<Long>();//seeds used for all the spawned enemies
int upToSeedNo = 0;//which position in the arrayList 
  
int enemyCount = 200;
  
float enemyPosX;
float enemyPosY = 30;
  
Ship(){

  
  
  pos = new PVector(width / 2, height * 0.9);
  vel = new PVector(0,0);
  acc = new PVector(0,0);
  
  SeedUsed = floor(random(1000000000));//create and store a seed
  randomSeed(SeedUsed);

  //generate asteroids
  enemies.add(new Enemy(random(50, 750), enemyPosY));
  
  brain = new NeuralNet(9, 16, 3);
}  


Ship(long seed) {
  replay = true;//is replaying
  pos = new PVector(width / 2, height * 0.9);
  vel = new PVector(0,0);
  acc = new PVector(0,0);
  SeedUsed = seed;//use the parameter seed to set the enemies at the same position as the last one
  randomSeed(SeedUsed);

  enemyPosX = random(50, 750);
  enemyPosY = 30.0;
  enemies.add(new Enemy(enemyPosX, enemyPosY));
  enemyPosX = random(50, 750);
  enemyPosY = 30.0;
  enemies.add(new Enemy(enemyPosX, enemyPosY));
  

}


void show() {
  if (!dead) {
    for (int i = 0; i < bullets.size(); i++) {//show bullets
      bullets.get(i).show();
    }
    pushMatrix();
    fill(255);
    stroke(255);
    rect(pos.x, pos.y, sizeX, sizeY);
    
    popMatrix();
  
  }
  for (int i = 0; i < enemies.size(); i++) {//show enemies
    enemies.get(i).show();
  }
}



void update() {
  for (int i = 0; i < bullets.size(); i++) {//if any bullets expires remove it
    if (bullets.get(i).off) {
      bullets.remove(i);
      i--;
    }
  }    
  move();//move everything
  checkPositions();//check if anything has been shot or hit
}
  

void checkPositions() {
//check if any bullets have hit any enemies
  for (int j = 0; j < enemies.size(); j++) {
    if (enemies.get(j).pos.y >= targetLine) {
        enemyPassed();
        enemies.remove(j);
    } else {
      for (int i = 0; i < bullets.size(); i++) {
        
        if (enemies.get(j).checkIfHit(bullets.get(i).pos)) {
          shotsHit ++;
          bullets.remove(i);//remove bullet
          enemies.remove(j);
          score +=1;
          break;
        } 
      }
    }
  }

}
  
  
  
void move(){
  checkTimers();
  
  vel.add(acc);
  vel.limit(5); 
  if (pos.x + sizeX < width && pos.x > 0) {
    pos.add(vel);
  }

  for (int i=0; i< bullets.size(); i++){
    bullets.get(i).move();
  }
  for (int i=0; i< enemies.size(); i++){
    enemies.get(i).move();
  }

}
  
void shoot(){
  if(shootCount <= 0 ) { 
    bullets.add(new Bullet(pos));
    shootCount = maxShootCount;
    shotsFired++;
    canShoot = false;
  }
}
  
 void mutate() {
  brain.mutate(globalMutationRate);
}

Ship clone() {
  Ship clone = new Ship();
  clone.brain = brain.clone();
  return clone;
}
//returns a clone of this player with the same brian and same random seeds used so all of the asteroids will be in  the same positions
Ship cloneForReplay() {
  Ship clone = new Ship(SeedUsed);
  clone.brain = brain.clone();
  clone.seedsUsed = (ArrayList)seedsUsed.clone();
  return clone;
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------  
Ship crossover(Ship parent2) {
  Ship child = new Ship();
  child.brain = brain.crossover(parent2.brain);
  return child;
}
  
  
void calculateFitness() {
  float hitRate = (float)shotsHit/(float)shotsFired;
  fitness = (score+1)*10;
  fitness *= lifespan;
  fitness *= hitRate*hitRate;//includes hitrate to encourage aiming
}

void checkTimers() {
    lifespan +=1;
    
    shootCount--;
    enemyCount--;
    if (enemyCount<=0) {//spawn asteorid

      if (replay) {//if replaying use the seeds from the arrayList
        randomSeed(seedsUsed.get(upToSeedNo));
        upToSeedNo ++;
      } else {//if not generate the seeds and then save them
        long seed = floor(random(1000000));
        seedsUsed.add(seed);
        randomSeed(seed);
      }
      //aim the asteroid at the player to encourage movement

      enemies.add(new Enemy(random(50, 750), enemyPosY));
      enemyCount = 200;
    }
    
    if (shootCount <=0) {
      canShoot = true;
    }
    
  }




void look() {
  vision = new float[9];
  //look left
  PVector direction;
  for (int i = 0; i< vision.length; i++) {
    direction = new PVector(i, 0);
    direction.mult(100);
    direction.add(50, 0, 0);
    vision[i] = lookInDirection(direction);
  }
  
  if (canShoot && vision[0] !=0) {
    vision[8] = 1;
  } else {
    vision[8] =0;
  }
  
}


float lookInDirection(PVector direction) {

  PVector position = new PVector(0, pos.y);//the position where we are currently looking for 
  float distance = 0;
  //move once in the desired direction before starting 
  position.add(direction);
  distance +=1;

  //look in the direction until you reach a wall
  while (distance< 400) {//!(position.x < 400 || position.y < 0 || position.x >= 800 || position.y >= 400)) {

    for (Enemy e : enemies) {
      if (e.lookForHit(position) ) {
        return  1/distance;
      }
    }

    position.add(direction);

    distance +=1;
  }
  return 0;
}

void think() {
  //get the output of the neural networkprintln(vision);
  decision = brain.output(vision);

  if (decision[1] > 0.8) {//output 1 is turn left
    acc = new PVector(-2, 0);
  } else {//cant turn right and left at the same time 
    if (decision[2] > 0.8) {//output 2 is turn right
      acc = new PVector(2, 0);
    } else {//if neither then dont turn
      acc = new PVector(0, 0);
    }
  }
  //shooting
  if (decision[0] > 0.8) {//output 3 is shooting
    shoot();
  }
}



void enemyPassed() {
  if (lives == 0) {//if no lives left
    dead = true;
  } else {//remove a life and reset positions
    lives -=1;
    //immortalCount = 100;
    resetPositions();
  }
}

//returns player to center
void resetPositions() {
  /*
  pos = new PVector(width/2, height/2);
  vel = new PVector();
  acc = new PVector();  
  bullets = new ArrayList<Bullet>();
  */
}


}
