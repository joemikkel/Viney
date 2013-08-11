class leaf{
  
  float xPos, yPos, angle;
  float currAge, maxAge;
  
  float currLength, maxLength;
  
  float leafColor = color(10,255,5);    //the initial leaf color
  float GROWTH_FACTOR = 0.05;          
  
  float leafR, leafG, leafB;
  
  float ageFactor;
  
  float yVelocity, xVelocity;
  float rotateVelocity;
  
  PGraphics leafSpace;
  
  float a1x, a1y, a2x, a2y, c1x, c1y, c2x, c2y;
  
  float falling = 0;
  
  leaf(float xPos, float yPos, float maxLength, float angle, float maxAge, PGraphics leafSpace){
      this.xPos = xPos;
      this.yPos = yPos;
      
      this.maxLength = maxLength;
      this.angle = angle;
      
      this.maxAge = maxAge;
      currAge = 0;
      
      leafR = random(10,50);
      leafG = random(180,255);
      leafB = random(60,100);
      
      
      a1x = 0;
      a1y = 0;
      
      a2x = maxLength;
      a2y = random(-maxLength * 0.15, maxLength * 0.15);
      
      c1x = random(maxLength * 0.2, maxLength * 0.6);
      c1y = random(-maxLength * 0.5, -maxLength * 0.33);
     
      c2x = random(maxLength * 0.5, maxLength * 0.75);
      c2y = random(-maxLength * 0.25, -maxLength * 0.15); 
      
      this.leafSpace = leafSpace;
      
  }
  
  void animateLeaf(){
    ageFactor = currAge/maxAge;
    if(ageFactor > 1)
      ageFactor = 1;
      
    
    if(currAge/maxAge >= 3 && falling <= 0){
      yVelocity += random(0.1, 0.3);
      rotateVelocity += random(-0.01, 0.01);
      falling = 0.002;
    }
    
    if(falling > 0){
      yVelocity += 0.05;
      xVelocity = (noise(falling)*3 - 1.5);
      falling += 0.002;
    }
      
    
    if(currLength < maxLength){
      currLength += (maxLength - currLength)*GROWTH_FACTOR;
    }
    
    
    xPos += xVelocity;
    yPos += yVelocity;
    angle += rotateVelocity;
    currAge += 1;
  }
  void drawLeaf(){
    leafSpace.pushMatrix();
    
    leafSpace.translate(xPos, yPos);
    leafSpace.rotate(angle);
    
    leafSpace.fill(leafR * (1 + (ageFactor/1.5)),
                   leafG * (1 - (ageFactor/1.5)),
                   leafB * (1 - (ageFactor/1.5)));
                   
    leafSpace.stroke(leafR * (1 + (ageFactor/1.5)), 
                     leafG * (1 - (ageFactor/1.5)), 
                     leafB * (1 - (ageFactor/1.5)),
                     100);    
    leafSpace.strokeWeight(5);
    //leafSpace.ellipse(currLength/2,0,currLength,currLength/2);
    leafSpace.beginShape();
    leafSpace.vertex(a1x * ageFactor, a1y * ageFactor);
    leafSpace.bezierVertex(c1x * ageFactor, c1y * ageFactor, c2x * ageFactor, c2y * ageFactor, a2x * ageFactor, a2y * ageFactor);
    leafSpace.endShape();
    
    leafSpace.beginShape();
    leafSpace.vertex(a1x * ageFactor, a1y * ageFactor);
    leafSpace.bezierVertex(c1x * ageFactor, -c1y * ageFactor, c2x * ageFactor, -c2y * ageFactor, a2x * ageFactor, a2y * ageFactor);
    leafSpace.endShape();
    
    leafSpace.popMatrix();
  }
}
