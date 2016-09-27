// Run this program only in the Java mode inside the IDE,
//import libraries
import processing.video.*;

//create Capture
Capture cam;
Capture screenshotCam;
float comparVal = 50;
private int[] screenshotImage;

void setup() {
  //size(1260,960);
  fullScreen();
  cam = new Capture(this,width,height);
  cam.start();
  screenshotCam = new Capture(this,width,height);
  screenshotCam.start();
  screenshotImage = new int[width*height];
  loadPixels();
}

void draw() {
  if(cam.available()) {
    cam.read();
      //fill array of pixel values pixels[]
  cam.loadPixels();
  
    int movesum = 0;
    for (int i = 0; i < width*height; i++) {
       color currentColor = cam.pixels[i];
       color screenshotColor = screenshotImage[i];
       
       float currR = red(currentColor);
       float currG = green(currentColor);
       float currB = blue(currentColor);

       float normCurrR = currR / (currR + currG + currB);
       float normCurrG = currG / (currR + currG + currB);
       
       float screenshotR = red(screenshotColor);
       float screenshotG = green(screenshotColor);
       float screenshotB = blue(screenshotColor);
       
       float normScrR = screenshotR / (screenshotR + screenshotG + screenshotB);
       float normScrG = screenshotG / (screenshotR + screenshotG + screenshotB);
       
       float diffR = abs(currR - screenshotR);
       float diffG = abs(currG - screenshotG);
       float diffB = int(abs(currB - screenshotB));
       
       float normDiffR = abs(normCurrR - normScrR) * 255;
       float normDiffG = abs(normCurrG - normScrG) * 255;

       movesum += diffR + diffG + diffB;
       
       float currIntensity = currR * 0.3 + currG * 0.59 + currB * 0.11;
       float screenshotIntensity = screenshotR * 0.3 + screenshotG * 0.59 + screenshotB * 0.11;
       
       float diffIntensity = abs(currIntensity - screenshotIntensity);
       pixels[i] = color(diffR,diffG,diffB);
         
       //pixels[i] = color(diffR,diffG,diffB);

       if ((normDiffR + normDiffG) / 2 > comparVal) {
         pixels[i] = color(255,100,255);
       } else {
         pixels[i] = color(0,0,0);
       }
    }
    
      updatePixels();
  }
}

void mouseClicked() {
    for(int x = 0; x < width*height; x++){
      screenshotImage[x] = cam.pixels[x];
    }
}

void keyPressed() {
  if (key == 'u') {
    comparVal += 10;
  } else {
    comparVal -= 10;
  }
}