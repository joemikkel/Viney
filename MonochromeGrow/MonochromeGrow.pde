import java.util.*;
//import java.time.*;

ArrayList<vine> vines;
ArrayList<leaf> leaves;

int fadeCount = 0;    
int fadeLimit = 5;    //CONFIG : higher = slower fade, should be above 1

PGraphics leafSpace;
PGraphics vineSpace;

long avgA, avgB, avgC;
long countA, countB, countC;

void setup(){
  size(displayWidth,displayHeight);
  //size(1024,800);
  smooth(16);
  background(0);
  
  vineSpace = createGraphics(width, height);
  //vineSpace = this.g;
  vines = new ArrayList<vine>();
  vines.add(new vine(width/2,height/2,0,2, random(100), vineSpace));
  
  
  leafSpace = createGraphics(width, height);
  leaves = new ArrayList<leaf>();
  
}

void draw(){
  
  background(0);
  
  long tA, tB, tC;
  
  processVines();
  
  //fade(vineSpace);
  
  processLeaves();
  
  text(Float.toString(frameRate), 10, 10);

}


void fade(PGraphics graphics){
  if(fadeCount > fadeLimit){
    graphics.loadPixels();
    for(int i = 0; i < graphics.width * graphics.height; i++)
      graphics.pixels[i] = color(
                            red(graphics.pixels[i])/* - 1*/,
                            green(graphics.pixels[i]) - 1,
                            blue(graphics.pixels[i]) - 1
                           );
    graphics.updatePixels();
    fadeCount = 0;
  }
  fadeCount++;
}
void processLeaves(){
  
  //println("Leaves : " + leaves.size());
  ListIterator<leaf> iter = leaves.listIterator();
  leafSpace.beginDraw();
  leafSpace.clear();
  while(iter.hasNext()){
    leaf nextLeaf = iter.next();
    if(nextLeaf.xPos > width + nextLeaf.currLength || 
       nextLeaf.xPos < -nextLeaf.currLength ||
       nextLeaf.yPos > height + nextLeaf.currLength){
      iter.remove();
      continue;
    }
    
    nextLeaf.animateLeaf();
    nextLeaf.drawLeaf();
  }
  leafSpace.endDraw();
  image(leafSpace, 0, 0);
}

void mousePressed(){
  vines.add(new vine(mouseX, mouseY, random(TWO_PI), random(1,3), random(100), vineSpace));  
}

void processVines(){
  //println("Vines : " + vines.size());
  
  ListIterator<vine> iter = vines.listIterator();
  vineSpace.beginDraw();
  while(iter.hasNext()){
    vine nextVine = iter.next();
    
    if(nextVine.xPos > width || nextVine.xPos < 0 ||
       nextVine.yPos > height|| nextVine.yPos < 0 ||
       nextVine.currentAge > nextVine.maxAge){
      iter.remove();
      continue;
    }

    if(nextVine.readyToSplit() && vines.size() < 30){
      nextVine.framesSinceLastSplit = 0;
      vine newVine = new vine(nextVine.xPos, nextVine.yPos, nextVine.angle, nextVine.setVelocity, random(100), vineSpace);
      iter.add(newVine);
    }
    if(nextVine.leafReady() && leaves.size() < 100){
      leaves.add(new leaf(nextVine.xPos, nextVine.yPos, (1 - nextVine.ageFactor) * random(10,50), random(TWO_PI), random(300,1000), leafSpace));
    }
    
    nextVine.updatePos();
    nextVine.randomize();
    nextVine.randomizeColor();
    nextVine.debugDraw();
  }
  vineSpace.endDraw();
  image(vineSpace,0,0);

}
      
