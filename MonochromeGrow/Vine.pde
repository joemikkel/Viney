class vine{
  float xPos, yPos;
  float angle;
  float setVelocity, currentVelocity;
  
  int vineColor;
  
  float noiseSeed, noiseX, noiseY;
  
  float noiseR, noiseG, noiseB;
  
  float framesSinceLastSplit = 0;
  float framesSinceLastLeaf = 0;
  
  float maxAge, currentAge;
  float ageFactor;
  PGraphics vineSpace;
  
  //-------------CONFIG
  float SWIRL_FACTOR = 0.5;  //how 'swirly' the vines are
  float COLOR_ALPHA = 255;  //opacity of the vines (0 - 255)
  
  vine(float xPos, float yPos, float angle, float velocity, float noiseSeed, PGraphics vineSpace){
    this.xPos = xPos;
    this.yPos = yPos;
    this.angle = angle;
    this.setVelocity = velocity;
    this.currentVelocity = velocity;
    this.noiseSeed = noiseSeed;
    this.vineSpace = vineSpace;
    
    maxAge = random(300, 1000);
    
    
    
    noiseR = random(0,100);
    noiseG = random(0,100);
    noiseB = random(0,100);
    
  }
  
  void updatePos(){
    xPos = getTargetPosX();
    yPos = getTargetPosY();
    currentAge++;
    ageFactor = currentAge/maxAge;
  }
  
  void randomizeColor(){
    noiseSeed((long)noiseSeed);
    vineColor = color(80 * noise(noiseR),
                      255 * noise(noiseG),  
                      30 * noise(noiseB),
                      COLOR_ALPHA);
    noiseR += 0.01;
    noiseG += 0.01;
    noiseB += 0.01; 
  }
  
  void randomize(){
    noiseSeed((long)noiseSeed);
    angle = ((noise(noiseX) * SWIRL_FACTOR) - (SWIRL_FACTOR/2)) + angle;
    noiseX += 0.01;
    
    currentVelocity = setVelocity * (noise(noiseY)*2);
    noiseY += 0.01;
  }
  
  float getTargetPosX(){
    return xPos + (currentVelocity * cos(angle));
  }
  
  float getTargetPosY(){
    return yPos + (currentVelocity * sin(angle));
  }

  boolean leafReady(){
    if(framesSinceLastLeaf > 70){
      if(random(3) < 1){
        framesSinceLastLeaf = 0;
        return true;
      }
    }
    framesSinceLastLeaf++;
    return false;
  }
      
  boolean readyToSplit(){
    if(framesSinceLastSplit < 50){
      framesSinceLastSplit++;
      return false;
    }
    
    if(currentVelocity / setVelocity < 0.1)
      return false;
    
    if(random(100) < 99)
      return false;
    return true;
  }
    
  void debugDraw(){
    vineSpace.noStroke();
    vineSpace.fill(vineColor);
    
    float ageFactor = 1.1 - (currentAge/maxAge);
    
    vineSpace.ellipse(xPos, yPos, ageFactor*4, ageFactor*4);
    
    vineSpace.strokeWeight(ageFactor * 4);
    vineSpace.stroke(vineColor);
    vineSpace.line(xPos, yPos, getTargetPosX(), getTargetPosY());
    
    //fill(0,255,0);
    //ellipse(getTargetPosX(), getTargetPosY(), 5, 5);
  }
  
  void debugPrint(){
    println("------------------");
    println("Angle : " + angle);
    println("Velocity : " + currentVelocity);
    println("Target X : " + getTargetPosX());
    println("Target Y : " + getTargetPosY());
  } 
  
  
}
