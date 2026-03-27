void setup() {
 fullScreen(); 
}

void draw() {
  background(30); // Dark background for the HUD

  // title bar
  fill(50);
  rect(0, 0, width, 50);
  fill(255);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Music Player", width / 2, 25);

  // play/pause button
  fill(100);
  ellipse(width / 2, height - 100, 80, 80);
  fill(255);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Play", width / 2, height - 100);

  //  next and previous buttons
  fill(100);
  triangle(width / 2 - 120, height - 100, width / 2 - 140, height - 80, width / 2 - 140, height - 120); // Previous
  triangle(width / 2 + 120, height - 100, width / 2 + 140, height - 80, width / 2 + 140, height - 120); // Next

  // progress bar
  fill(100);
  rect(50, height - 200, width - 100, 10);
  fill(255, 0, 0);
 
  // exit box
   fill(100);
  rect(1850, -1, 70, 70); // Draw the box (x, y, width, height)
 

}

void mousePressed(){
// Check if the mouse is inside the button
  if (mouseX > 1850 && mouseX < -1 && mouseY > 150 && mouseY < 200) {
    exit(); // Exit the program
  }
}
