// Variables for the music player UI
boolean showPlayer = false;
boolean isPlaying = false;
boolean showStop = false;
boolean showControlsBar = false; // Show/hide the control bar
boolean loopInfinite = false; // Track loop mode
boolean shuffleOn = false; // Track shuffle mode
int stopButtonTimer = 0; // Timestamp when stop button appears
int stopButtonDuration = 5000; // Duration in milliseconds (5 seconds)
int pausePressTime = 0;
int longPressThreshold = 1000; // milliseconds

// Button size
float buttonSize = 50;

// Images for buttons
PImage playImg;
PImage pauseImg;
PImage stopImg;
PImage rewind20sImg;
PImage skip20sImg;
PImage replayImg;
PImage muteImg;    // Mute image
PImage unmuteImg;  // Unmute image
PImage shuffleImg; // Shuffle image
PImage nextImg;    // Next button image
PImage previousImg; // Previous button image

// Mute state variable
boolean isMuted = false; // Track mute status

void setup() {
  fullScreen();
  rectMode(CENTER);
  // Load images
  playImg = loadImage("play.png");
  pauseImg = loadImage("pause.png");
  stopImg = loadImage("STOP.png");
  rewind20sImg = loadImage("rewind30s.png");
  skip20sImg = loadImage("skip30s.png");
  replayImg = loadImage("replay.png");
  unmuteImg = loadImage("unmute.png");
  muteImg = loadImage("mute.png");
  shuffleImg = loadImage("shuffle.png");
  nextImg = loadImage("next.png");
  previousImg = loadImage("previous.png");
}

void draw() {
  background(255);
  
  // Toggle button
  fill(200);
  rect(50, height - 50, 50, 50);
  
  // Exit button
  fill(150);
  rect(width - 30, 30, 60, 30);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(12);
  text("Exit", width - 30, 30);
  
  if (showPlayer) {
    float cx = width/2;
    float cy = height/2;
    fill(0);
    rect(cx, cy, 800, 600);
    drawProgressBar(cx, cy - 250);
    drawMusicPlayer(cx, cy);
    if (showStop && millis() - stopButtonTimer > stopButtonDuration) {
      showStop = false;
    }
  }
}

void drawProgressBar(float cx, float y) {
  fill(200);
  rect(cx, y, 700, 10);
}

void drawMusicPlayer(float cx, float cy) {
  fill(0);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Music Player", cx, cy - 150);
  imageMode(CENTER);
  
  // Play/Pause
  PImage currentImg = isPlaying ? pauseImg : playImg;
  image(currentImg, cx, cy, buttonSize, buttonSize);
  
  // Rewind, skip, replay
  image(rewind20sImg, cx - 200, cy, buttonSize, buttonSize);
  image(skip20sImg, cx + 200, cy, buttonSize, buttonSize);
  image(replayImg, cx, cy + 100, buttonSize, buttonSize);
  
  // Toggle control button
  fill(100);
  rect(cx + 150, cy + 100, buttonSize, buttonSize);
  fill(255);
  text("☰", cx + 150, cy + 100);
  
  if (showControlsBar) {
    drawControlsBar(cx, cy + 200);
  }
  
  if (showStop) {
    fill(255, 0, 0);
    rect(cx, cy, 80, 50);
    fill(255);
    text("Stop", cx, cy + 2);
  }
}

void drawControlsBar(float cx, float cy) {
  fill(50);
  rect(cx, cy, 500, 60);
  
  // Loop toggle
  fill(100);
  rect(cx - 100, cy, 80, 40);
  fill(255);
  String loopLabel = loopInfinite ? "Loop: Infinite" : "Loop: Normal";
  text(loopLabel, cx - 100, cy);
  
  // Shuffle (image)
  fill(100);
  rect(cx, cy, 80, 40);
  image(shuffleImg, cx, cy, 40, 40);
  
  // Next (image)
  fill(100);
  rect(cx + 100, cy, 80, 40);
  image(nextImg, cx + 100, cy, 40, 40);
  
  // Previous (image)
  fill(100);
  rect(cx + 200, cy, 80, 40);
  image(previousImg, cx + 200, cy, 40, 40);
  
  // Mute/Unmute
  float muteX = cx - 200; // same as in drawMusicPlayer
  float muteY = cy;
  if (isMuted) {
    image(muteImg, muteX, muteY, buttonSize, buttonSize);
  } else {
    image(unmuteImg, muteX, muteY, buttonSize, buttonSize);
  }
}

void mousePressed() {
  // Exit button
  if (mouseX > width - 60 && mouseY < 40) {
    exit();
  }
  // Toggle main UI
  if (dist(mouseX, mouseY, 50, height - 50) < 25) {
    showPlayer = !showPlayer;
  }
  
  if (showPlayer) {
    float cx = width/2;
    float cy = height/2;

    // Play/Pause
    if (dist(mouseX, mouseY, cx, cy) < buttonSize/2) {
      pausePressTime = millis();
    }

    // Rewind, skip, replay
    if (dist(mouseX, mouseY, cx - 200, cy) < buttonSize/2) {
      println("Rewind 20 seconds");
    }
    if (dist(mouseX, mouseY, cx + 200, cy) < buttonSize/2) {
      println("Skip 20 seconds");
    }
    if (dist(mouseX, mouseY, cx, cy + 100) < buttonSize/2) {
      println("Replay");
    }

    // Toggle control bar
    if (abs(mouseX - (cx + 150)) < buttonSize/2 && abs(mouseY - (cy + 100)) < buttonSize/2) {
      showControlsBar = !showControlsBar;
    }

    if (showControlsBar) {
      float ctrlX = cx;
      float ctrlY = cy + 200;

      // Loop toggle (long press)
      if (abs(mouseX - (ctrlX - 100)) < 40 && abs(mouseY - ctrlY) < 20) {
        int duration = millis() - pausePressTime;
        if (duration > longPressThreshold) {
          loopInfinite = !loopInfinite;
          println("Loop: " + (loopInfinite ? "Infinite" : "Normal"));
        }
      }

      // Shuffle toggle (long press)
      if (abs(mouseX - ctrlX) < 40 && abs(mouseY - ctrlY) < 20) {
        int duration = millis() - pausePressTime;
        if (duration > longPressThreshold) {
          shuffleOn = !shuffleOn;
          println("Shuffle: " + (shuffleOn ? "On" : "Off"));
        }
      }

      // Next
      if (abs(mouseX - (ctrlX + 100)) < 40 && abs(mouseY - ctrlY) < 20) {
        println("Next");
      }

      // Previous
      if (abs(mouseX - (ctrlX + 200)) < 40 && abs(mouseY - ctrlY) < 20) {
        println("Previous");
      }
    }

    // Long press detection for Loop button
    float loopX = cx - 100;
    float loopY = cy + 200;
    if (abs(mouseX - loopX) < 40 && abs(mouseY - loopY) < 20) {
      int duration = millis() - pausePressTime;
      if (duration > longPressThreshold) {
        loopInfinite = !loopInfinite;
        println("Loop mode toggled to " + (loopInfinite ? "Infinite" : "Normal"));
      }
    }

    // Long press detection for Shuffle
    float shuffleX = cx;
    float shuffleY = cy + 200;
    if (abs(mouseX - shuffleX) < 40 && abs(mouseY - shuffleY) < 20) {
      int duration = millis() - pausePressTime;
      if (duration > longPressThreshold) {
        shuffleOn = !shuffleOn;
        println("Shuffle mode toggled to " + (shuffleOn ? "On" : "Off"));
      }
    }

    // Stop button
    if (showStop && abs(mouseX - cx) < 40 && abs(mouseY - (cy + 2)) < 25) {
      println("Stop");
      showStop = false;
    }
  }

  // Detect click on mute/unmute
  if (showPlayer && showControlsBar) {
    float cx = width/2;
    float cy = height/2;
    float muteX = cx - 200;
    float muteY = cy;
    if (abs(mouseX - muteX) < buttonSize/2 && abs(mouseY - muteY) < buttonSize/2) {
      isMuted = !isMuted;
      println("Mute toggled. Now: " + (isMuted ? "Muted" : "Unmuted"));
    }
  }
}

void mouseReleased() {
  if (showPlayer && dist(mouseX, mouseY, width/2, height/2) < buttonSize/2) {
    int pressDuration = millis() - pausePressTime;
    if (pressDuration > longPressThreshold) {
      showStop = true;
      stopButtonTimer = millis();
    } else {
      isPlaying = !isPlaying;
    }
  }
}
