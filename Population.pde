class Population {

Ship[] ships;

float fitnessSum;
int bestScore = 0;
int gen = 0;
int highestScore = 0;
int bestShipNo;
Ship bestShip;

Population (int size){
  ships = new Ship[size];
  for (int i= 0; i< size; i++){
    ships[i] = new Ship();
  }
}

boolean done() {
  for (int i = 0; i< ships.length; i++) {
    if (!ships[i].dead) {
      return false;
    }
  }
  return true;
}

void show(){
  for (int i=0; i < ships.length; i++){
    ships[i].show();
  }
}


void updateAlive() {

    for (int i = 0; i< ships.length; i++) {
      if (!ships[i].dead) {
        ships[i].look();//get inputs for brain 
        ships[i].think();//use outputs from neural network
        ships[i].update();//move the player according to the outputs from the neural network
        if (!showBest || i ==0) {//dont show dead players
          ships[i].show();
        }
      }
    }
  }



void getHighestScore(){
  for (int i=0; i < ships.length; i++){
    if (ships[i].score > highestScore){
      highestScore = ships[i].score;
    }
  }
}


void naturalSelection() {


  Ship[] newShips = new Ship[ships.length];//Create new players array for the next generation

  setBestShip();//set which player is the best

  newShips[0] = ships[bestShipNo].cloneForReplay();//add the best player of this generation to the next generation without mutation
  for (int i = 1; i<ships.length; i++) {
    //for each remaining spot in the next generation
    if (i<ships.length/2) {
      newShips[i] = selectShip().clone();//select a random player(based on fitness) and clone it
    } else {
      newShips[i] = selectShip().crossover(selectShip());
    }
    newShips[i].mutate(); //mutate it
  }

  ships = newShips.clone();
  gen+=1;
}



Ship selectShip() {
  //this function works by randomly choosing a value between 0 and the sum of all the fitnesses
  //then go through all the players and add their fitness to a running sum and if that sum is greater than the random value generated that player is chosen
  //since players with a higher fitness function add more to the running sum then they have a higher chance of being chosen


  //calculate the sum of all the fitnesses
  long fitnessSum = 0;
  for (int i =0; i<ships.length; i++) {
    fitnessSum += ships[i].fitness;
  }
  int rand = floor(random(fitnessSum));
  //summy is the current fitness sum
  int runningSum = 0;

  for (int i = 0; i< ships.length; i++) {
    runningSum += ships[i].fitness; 
    if (runningSum > rand) {
      return ships[i];
    }
  }
  //unreachable code to make the parser happy
  return ships[0];
}





//sets the best player globally and for this gen
  void setBestShip() {
    //get max fitness
    float max =0;
    int maxIndex = 0;
    for (int i =0; i<ships.length; i++) {
      if (ships[i].fitness > max) {
        max = ships[i].fitness;
        maxIndex = i;
      }
    }

    bestShipNo = maxIndex;
    //if best this gen is better than the global best score then set the global best as the best this gen

    if (ships[bestShipNo].score > bestScore) {
      bestScore = ships[bestShipNo].score;
      bestShip = ships[bestShipNo].cloneForReplay();
    }
  }










Ship selectParent(){
  float rand = random(fitnessSum);
  float runningSum = 0;
  
  for (int i=0; i < ships.length; i++){
    runningSum += ships[i].fitness;
    if (runningSum > rand) {
      return ships[i];
    }
  }
  //shoudn't get here
  println("BUT IT DIIIIID");
  return null;

}

void calculateFitness(){
    for (int i=0; i < ships.length; i++){
      ships[i].calculateFitness(); 
    }
}

void mutate(){
  for (int i=0; i < ships.length; i++){
    ships[i].mutate();
  
  }
}




}
