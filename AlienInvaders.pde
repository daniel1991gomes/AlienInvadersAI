

Population pop;

int speed = 100;
float globalMutationRate = 0.1;
boolean showBest = false;
float targetLine;


void setup(){
  
  size(800, 800);
  pop = new Population(200);
  targetLine = height * 0.95;
  frameRate(speed);
}


void draw() {
  background(0);
  fill(255);
  rect(width * 0.05, targetLine, width*0.9, 3); 
  
  
  if (!pop.done()) {//if any players are alive then update them
      pop.updateAlive();
    } else {//all dead
      //genetic algorithm 
      pop.calculateFitness(); 
      pop.naturalSelection();
  }
  
  showScore();//display the score
}


void showScore() {
  
  if (showBest) {
    fill(255);
    textAlign(LEFT);
    text("Score: " + pop.ships[0].score, 80, 60);
    text("Gen: " + pop.gen, width-200, 60);
  }

}
