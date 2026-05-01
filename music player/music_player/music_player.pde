//imported libraries
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// Variables for the music player UI
boolean showPlayer = false;
boolean isPlaying = false;
boolean showStop = false;
boolean showControlsBar = false;
boolean loopInfinite = false;
boolean shuffleOn = false;
int stopButtonTimer = 0;
int stopButtonDuration = 5000;
int pausePressTime = 0;
int longPressThreshold = 1000;
boolean isMuted = false;

// Sizes
float buttonSize = 50;
float controlButtonSize = 50;
float stopButtonW = 80;
float stopButtonH = 50;

// Arrays for positions and sizes
float[] toggleButtonPos = {50, 50}; // x, y
float toggleButtonSizeVal = 50;

float[] exitButtonPos = {60, 30}; // x, y
float[] exitButtonSizeVal = {60, 30};

// Music box size
float musicBoxW = 1000;
float musicBoxH = 900;

// Music Player lable box
float[] musicLabelBoxPos = {0, 100}; // will set in setup()
float[] musicLabelBoxSize = {500, 100};

// Progress bar
float progressBarYOffset = 200;
float progressBarW = 700;
float progressBarH = 10;

// Control toggle button offsets
float controlButtonXOffset = 150;
float controlButtonYOffset = 100;

// Control bar size
float controlBarW = 500;
float controlBarH = 60;

// Offsets for control bar elements
float[] controlBarOffsetsX = {-100, 0, 100, 200}; // loop, shuffle, next, prev


// Mute button position relative to control bar
float muteXOffset = -200;
float muteYOffset = 0;

// Images
PImage[] controlBarImages = new PImage[4]; // shuffle, next, prev, mute/unmute
PImage playImg, pauseImg, stopImg, rewind15sImg, skip15sImg, replayImg, muteImg, unmuteImg;

void setup() {
  fullScreen();
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  
  // Initialize "Music Player" label box position based on width
  musicLabelBoxPos[0] = width/2;

  // Load images
  playImg = loadImage("play.png");
  pauseImg = loadImage("pause.png");
  stopImg = loadImage("STOP.png");
  rewind15sImg = loadImage("rewind15s.png");
  skip15sImg = loadImage("skip15s.png");
  replayImg = loadImage("replay.png");
  muteImg = loadImage("mute.png");
  unmuteImg = loadImage("unmute.png");
  controlBarImages[0] = loadImage("shuffle.png");
  controlBarImages[1] = loadImage("next.png");
  controlBarImages[2] = loadImage("previous.png");
  controlBarImages[3] = loadImage("mute.png"); // default, will switch based on mute state
}

void draw() {
  background(255);

  // Draw the "Music Player" label box
  fill(180);
  rect(musicLabelBoxPos[0], musicLabelBoxPos[1], musicLabelBoxSize[0], musicLabelBoxSize[1]);
  fill(0);
  textSize(50);
  text("Music Player", musicLabelBoxPos[0], musicLabelBoxPos[1]);

  // Draw toggle button
  fill(200);
  rect(toggleButtonPos[0], height - toggleButtonPos[1], toggleButtonSizeVal, toggleButtonSizeVal);

  // Draw exit button
  fill(150);
  rect(exitButtonPos[0], exitButtonPos[1], exitButtonSizeVal[0], exitButtonSizeVal[1]);
  fill(255);
  textSize(12);
  text("Exit", exitButtonPos[0], exitButtonPos[1]);

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

// Draw Progress Bar
void drawProgressBar(float cx, float y) {
  fill(200);
  rect(cx, y, progressBarW, progressBarH);
}

// Draw Music Player UI
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

// Draw Control Bar
void drawControlsBar(float cx, float cy) {
  fill(50);
  rect(cx, cy, controlBarW, controlBarH);

  // Loop toggle (long press)
  fill(100);
  rect(cx + controlBarOffsetsX[0], cy, 80, 40);
  fill(255);
  String loopLabel = loopInfinite ? "Loop: Infinite" : "Loop: Normal";
  text(loopLabel, cx + controlBarOffsetsX[0], cy);

  // Shuffle Button
  fill(100);
  rect(cx + controlBarOffsetsX[1], cy, 80, 40);
  image(controlBarImages[0], cx + controlBarOffsetsX[1], cy, 40, 40);

  // Next Button
  fill(100);
  rect(cx + controlBarOffsetsX[2], cy, 80, 40);
  image(controlBarImages[1], cx + controlBarOffsetsX[2], cy, 40, 40);

  // Previous Button
  fill(100);
  rect(cx + controlBarOffsetsX[3], cy, 80, 40);
  image(controlBarImages[2], cx + controlBarOffsetsX[3], cy, 40, 40);

  // Mute/Unmute Button
  float muteX = cx + muteXOffset;
  float muteY = cy + muteYOffset;
  if (isMuted) {
    image(muteImg, muteX, muteY, buttonSize, buttonSize);
  } else {
    image(unmuteImg, muteX, muteY, buttonSize, buttonSize);
  }
}

// Mouse pressed logic
void mousePressed() {
  float cx = width / 2;
  float cy = height / 2;

  // Toggle main button
  if (mouseX > toggleButtonPos[0] - toggleButtonSizeVal / 2 && mouseX < toggleButtonPos[0] + toggleButtonSizeVal / 2 &&
      mouseY > height - toggleButtonPos[1] - toggleButtonSizeVal / 2 && mouseY < height - toggleButtonPos[1] + toggleButtonSizeVal / 2) {
    showPlayer = !showPlayer;
  }

  // Exit button
  if (mouseX > exitButtonPos[0] - exitButtonSizeVal[0] / 2 && mouseX < exitButtonPos[0] + exitButtonSizeVal[0] / 2 &&
      mouseY > exitButtonPos[1] - exitButtonSizeVal[1] / 2 && mouseY < exitButtonPos[1] + exitButtonSizeVal[1] / 2) {
    exit();
  }

  if (showPlayer) {
    // Play/Pause
    if (dist(mouseX, mouseY, cx, cy) < buttonSize / 2) {
      pausePressTime = millis();
    }

    // Rewind 15s
    if (mouseX > cx - 200 - buttonSize / 2 && mouseX < cx - 200 + buttonSize / 2 && abs(mouseY - cy) < buttonSize / 2) {
      println("Rewind 15 seconds");
    }

    // Skip 15s
    if (mouseX > cx + 200 - buttonSize / 2 && mouseX < cx + 200 + buttonSize / 2 && abs(mouseY - cy) < buttonSize / 2) {
      println("Skip 15 seconds");
    }

    // Replay
    if (mouseX > cx - buttonSize / 2 && mouseX < cx + buttonSize / 2 && abs(mouseY - (cy + 100)) < buttonSize / 2) {
      println("Replay");
    }

    // Toggle controls bar
    if (mouseX > cx + controlButtonXOffset - controlButtonSize / 2 && mouseX < cx + controlButtonXOffset + controlButtonSize / 2 &&
        mouseY > cy + controlButtonYOffset - controlButtonSize / 2 && mouseY < cy + controlButtonYOffset + controlButtonSize / 2) {
      showControlsBar = !showControlsBar;
    }

    // Controls bar buttons
    if (showControlsBar) {
      float ctrlY = cy + controlButtonYOffset + 100;

      // Loop toggle (long press)
      if (dist(mouseX, mouseY, cx + controlBarOffsetsX[0], ctrlY) < 40) {
        int duration = millis() - pausePressTime;
        if (duration > longPressThreshold) {
          loopInfinite = !loopInfinite;
          println("Loop mode: " + (loopInfinite ? "Infinite" : "Normal"));
        }
      }

      // Shuffle toggle (long press)
      if (dist(mouseX, mouseY, cx + controlBarOffsetsX[1], ctrlY) < 40) {
        int duration = millis() - pausePressTime;
        if (duration > longPressThreshold) {
          shuffleOn = !shuffleOn;
          println("Shuffle: " + (shuffleOn ? "On" : "Off"));
        }
      }

      // Next
      if (dist(mouseX, mouseY, cx + controlBarOffsetsX[2], ctrlY) < 40) {
        println("Next");
      }

      // Previous
      if (dist(mouseX, mouseY, cx + controlBarOffsetsX[3], ctrlY) < 40) {
        println("Previous");
      }
    }
  }
}

// Mouse released
void mouseReleased() {
  float cx = width / 2;
  float cy = height / 2;

  // Play/Pause toggle
  if (dist(mouseX, mouseY, cx, cy) < buttonSize / 2) {
    int duration = millis() - pausePressTime;
    if (duration > longPressThreshold) {
      showStop = true;
      stopButtonTimer = millis();
    } else {
      isPlaying = !isPlaying;
    }
  }
}
