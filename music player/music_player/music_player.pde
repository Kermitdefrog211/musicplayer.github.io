// Variables for the music player UI
boolean showPlayer = false;
boolean isPlaying = false;
boolean showStop = false;
boolean showControlsBar = false; //Show/hide control bar
boolean loopInfinite = false; //loop mode
boolean shuffleOn = false; //shuffle mode
int stopButtonTimer = 0; //stop button appears
int stopButtonDuration = 5000; //5ms
int pausePressTime = 0;
int longPressThreshold = 1000;
boolean isMuted = false; // Mute status

// Sizes
float buttonSize = 50;
float controlButtonSize = 50;
float stopButtonW = 80;
float stopButtonH = 50;

//main toggle and exit button
float toggleButtonX = 50;
float toggleButtonY = 0;
float toggleButtonSize = 50;

float exitButtonX = 60;
float exitButtonY = 30;
float exitButtonW = 60;
float exitButtonH = 30;

// Positions for music player UI
float musicBoxW = 1000;
float musicBoxH = 900;

float progressBarYOffset = -250;
float progressBarW = 700;
float progressBarH = 10;

// Positions for control toggle button
float controlButtonXOffset = 150;
float controlButtonYOffset = 100;

// Positions for control bar elements
float controlBarW = 500;
float controlBarH = 60;

// Offsets for control bar elements
float loopToggleXOffset = -100;
float shuffleXOffset = 0;
float nextXOffset = 100;
float prevXOffset = 200;

// Mute button position
float muteXOffset = -200;
float muteYOffset = 0;

//images for buttons
PImage playImg;
PImage pauseImg;
PImage stopImg;
PImage rewind15sImg;
PImage skip15sImg;
PImage replayImg;
PImage muteImg;
PImage unmuteImg;
PImage shuffleImg;
PImage nextImg;
PImage previousImg;

void setup() {
  fullScreen();
  rectMode(CENTER);
  //images
  playImg = loadImage("play.png");
  pauseImg = loadImage("pause.png");
  stopImg = loadImage("STOP.png");
  rewind15sImg = loadImage("rewind15s.png");
  skip15sImg = loadImage("skip15s.png");
  replayImg = loadImage("replay.png");
  unmuteImg = loadImage("unmute.png");
  muteImg = loadImage("mute.png");
  shuffleImg = loadImage("shuffle.png");
  nextImg = loadImage("next.png");
  previousImg = loadImage("previous.png");
}

void draw() {
  background(255);

  // Draw toggle button
  fill(200);
  rect(toggleButtonX, height - toggleButtonY, toggleButtonSize, toggleButtonSize);

  // Draw exit button
  fill(150);
  rect(exitButtonX, exitButtonY, exitButtonW, exitButtonH);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(12);
  text("Exit", exitButtonX, exitButtonY);

  if (showPlayer) {
    float cx = width / 2;
    float cy = height / 2;
    fill(0);
    rect(cx, cy, musicBoxW, musicBoxH);
    drawProgressBar(cx, cy + progressBarYOffset);
    drawMusicPlayer(cx, cy);
    if (showStop && millis() - stopButtonTimer > stopButtonDuration) {
      showStop = false;
    }
  }
}

/* --- Draw Progress Bar --- */
void drawProgressBar(float cx, float y) {
  fill(200);
  rect(cx, y, progressBarW, progressBarH);
}

/* --- Draw Music Player UI --- */
void drawMusicPlayer(float cx, float cy) {
  fill(0);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Music Player", cx, cy - 150);
  imageMode(CENTER);

  // Play/Pause Button
  PImage currentImg = isPlaying ? pauseImg : playImg;
  image(currentImg, cx, cy, buttonSize, buttonSize);

  // Rewind, Skip, Replay Buttons
  image(rewind15sImg, cx - 200, cy, buttonSize, buttonSize);
  image(skip15sImg, cx + 200, cy, buttonSize, buttonSize);
  image(replayImg, cx, cy + 100, buttonSize, buttonSize);

  // Control Toggle Button
  fill(100);
  rect(cx + controlButtonXOffset, cy + controlButtonYOffset, controlButtonSize, controlButtonSize);
  fill(255);
  text("x", cx + controlButtonXOffset, cy + controlButtonYOffset);

  // Control Bar
  if (showControlsBar) {
    drawControlsBar(cx, cy + controlButtonYOffset + 100);
  }

  // Stop Button
  if (showStop) {
    fill(255, 0, 0);
    rect(cx, cy, stopButtonW, stopButtonH);
    fill(255);
    text("Stop", cx, cy + 2);
  }
}

//Draw Control Bar
void drawControlsBar(float cx, float cy) {
  fill(50);
  rect(cx, cy, controlBarW, controlBarH);

  // Loop toggle
  fill(100);
  rect(cx + loopToggleXOffset, cy, 80, 40);
  fill(255);
  String loopLabel = loopInfinite ? "Loop: Infinite" : "Loop: Normal";
  text(loopLabel, cx + loopToggleXOffset, cy);

  // Shuffle Button
  fill(100);
  rect(cx + shuffleXOffset, cy, 80, 40);
  image(shuffleImg, cx + shuffleXOffset, cy, 40, 40);

  // Next Button
  fill(100);
  rect(cx + nextXOffset, cy, 80, 40);
  image(nextImg, cx + nextXOffset, cy, 40, 40);

  // Previous Button
  fill(100);
  rect(cx + prevXOffset, cy, 80, 40);
  image(previousImg, cx + prevXOffset, cy, 40, 40);

  // Mute/Unmute Button
  float muteX = cx + muteXOffset;
  float muteY = cy + muteYOffset;
  if (isMuted) {
    image(muteImg, muteX, muteY, buttonSize, buttonSize);
  } else {
    image(unmuteImg, muteX, muteY, buttonSize, buttonSize);
  }
}

/* --- Mouse Pressed Logic --- */
void mousePressed() {
  float cx = width / 2;
  float cy = height / 2;

  // Main toggle button
  if (mouseX > toggleButtonX - toggleButtonSize / 2 && mouseX < toggleButtonX + toggleButtonSize / 2 &&
      mouseY > height - toggleButtonY - toggleButtonSize / 2 && mouseY < height - toggleButtonY + toggleButtonSize / 2) {
    showPlayer = !showPlayer;
  }

  // Exit button
  if (mouseX > exitButtonX - exitButtonW / 2 && mouseX < exitButtonX + exitButtonW / 2 &&
      mouseY > exitButtonY - exitButtonH / 2 && mouseY < exitButtonY + exitButtonH / 2) {
    exit();
  }

  if (showPlayer) {
    // Play/Pause
    if (mouseX > cx - buttonSize / 2 && mouseX < cx + buttonSize / 2 &&
        mouseY > cy - buttonSize / 2 && mouseY < cy + buttonSize / 2) {
      pausePressTime = millis();
    }

    // Rewind 15s
    if (mouseX > cx - 200 - buttonSize / 2 && mouseX < cx - 200 + buttonSize / 2 &&
        mouseY > cy - buttonSize / 2 && mouseY < cy + buttonSize / 2) {
      println("Rewind 15 seconds");
    }

    // Skip 15s
    if (mouseX > cx + 200 - buttonSize / 2 && mouseX < cx + 200 + buttonSize / 2 &&
        mouseY > cy - buttonSize / 2 && mouseY < cy + buttonSize / 2) {
      println("Skip 15 seconds");
    }

    // Replay
    if (mouseX > cx - buttonSize / 2 && mouseX < cx + buttonSize / 2 &&
        mouseY > cy + 100 - buttonSize / 2 && mouseY < cy + 100 + buttonSize / 2) {
      println("Replay");
    }

    // Toggle controls bar
    if (mouseX > cx + controlButtonXOffset - controlButtonSize / 2 && mouseX < cx + controlButtonXOffset + controlButtonSize / 2 &&
        mouseY > cy + controlButtonYOffset - controlButtonSize / 2 && mouseY < cy + controlButtonYOffset + controlButtonSize / 2) {
      showControlsBar = !showControlsBar;
    }

    // Controls bar buttons
    if (showControlsBar) {
      float ctrlX = cx;
      float ctrlY = cy + controlButtonYOffset + 100;

      // Shuffle toggle (long press)
      if (mouseX > ctrlX - 40 && mouseX < ctrlX + 40 && mouseY > ctrlY - 20 && mouseY < ctrlY + 20) {
        int duration = millis() - pausePressTime;
        if (duration > longPressThreshold) {
          shuffleOn = !shuffleOn;
          println("Shuffle: " + (shuffleOn ? "On" : "Off"));
        }
      }

      // Next button
      if (mouseX > ctrlX + nextXOffset - 40 && mouseX < ctrlX + nextXOffset + 40 && mouseY > ctrlY - 20 && mouseY < ctrlY + 20) {
        println("Next");
      }

      // Previous button
      if (mouseX > ctrlX + prevXOffset - 40 && mouseX < ctrlX + prevXOffset + 40 && mouseY > ctrlY - 20 && mouseY < ctrlY + 20) {
        println("Previous");
      }
    }

    // Long press for loop toggle
    float loopX = cx + loopToggleXOffset;
    float loopY = cy + controlButtonYOffset + 200;
    if (mouseX > loopX - 40 && mouseX < loopX + 40 && mouseY > loopY - 20 && mouseY < loopY + 20) {
      int duration = millis() - pausePressTime;
      if (duration > longPressThreshold) {
        loopInfinite = !loopInfinite;
        println("Loop mode toggled to " + (loopInfinite ? "Infinite" : "Normal"));
      }
    }

    // Stop button
    float stopX = cx;
    float stopY = cy;
    if (showStop && mouseX > stopX - stopButtonW / 2 && mouseX < stopX + stopButtonW / 2 &&
        mouseY > stopY - stopButtonH / 2 && mouseY < stopY + stopButtonH / 2) {
      println("Stop");
      showStop = false;
    }
  }
}

// Mouse Released 
void mouseReleased() {
  float cx = width / 2;
  float cy = height / 2;

  // Play/Pause toggle (circle area)
  if (mouseX > cx - buttonSize / 2 && mouseX < cx + buttonSize / 2 &&
      mouseY > cy - buttonSize / 2 && mouseY < cy + buttonSize / 2) {
    int duration = millis() - pausePressTime;
    if (duration > longPressThreshold) {
      showStop = true;
      stopButtonTimer = millis();
    } else {
      isPlaying = !isPlaying;
    }
  }
}
