//imported libraries
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// UI variables
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

// Positions
float[] toggleButtonPos = {50, 50}; // x, y
float toggleButtonSizeVal = 50;
float[] exitButtonPos = {60, 30};
float[] exitButtonSizeVal = {60, 30};
float musicBoxW = 1000;
float musicBoxH = 900;
float[] musicLabelBoxPos = {0, 100};
float[] musicLabelBoxSize = {500, 100};
float progressBarYOffset = 200;
float progressBarW = 700;
float progressBarH = 10;
float controlButtonXOffset = 150;
float controlButtonYOffset = 100;
float controlBarW = 500;
float controlBarH = 60;
float[] controlBarOffsetsX = {-100, 0, 100, 200};
float muteXOffset = -200;
float muteYOffset = 0;

// Images
PImage[] controlBarImages = new PImage[4]; // shuffle, next, prev, mute/unmute
PImage playImg, pauseImg, stopImg, rewind15sImg, skip15sImg, replayImg, muteImg, unmuteImg;

// Audio
Minim minim;
AudioPlayer currentAudio; // Current track
AudioPlayer[] playlist; // Playlist array
int currentSongIndex = 0;

// List of song filenames
String[] songPaths = {
  "Cycles.mp3",
  "Eureka.mp3",
  "Ghost_Walk.mp3",
  "groove.mp3",
  "Newsroom.mp3",
  "Pong World.mp3"
};

void setup() {
  fullScreen();
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
  
  // Set label box position
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

  // Initialize Minim and load playlist
  minim = new Minim(this);
  playlist = new AudioPlayer[songPaths.length];
  for (int i=0; i < songPaths.length; i++) {
    playlist[i] = minim.loadFile(songPaths[i]);
  }
  // Start with first song
  currentSongIndex = 0;
  currentAudio = playlist[currentSongIndex];
}

void draw() {
  background(255);

  // Draw "Music Player" label box
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
    float cx = width/2;
    float cy = height/2;

    fill(0);
    rect(cx, cy, musicBoxW, musicBoxH);
    drawProgressBar(cx, cy + progressBarYOffset);
    drawMusicPlayer(cx, cy);
    if (showStop && millis() - stopButtonTimer > stopButtonDuration) {
      showStop = false;
    }
  }
}

void drawProgressBar(float cx, float y) {
  fill(200);
  rect(cx, y, progressBarW, progressBarH);
}

void drawMusicPlayer(float cx, float cy) {
  fill(0);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Music Player", cx, cy - 150);
  imageMode(CENTER);

  // Play/Pause Button
  PImage currentImg = isPlaying ? pauseImg : playImg;
  image(currentImg, cx, cy, buttonSize, buttonSize);

  // Rewind, Skip, Replay
  image(rewind15sImg, cx - 200, cy, buttonSize, buttonSize);
  image(skip15sImg, cx + 200, cy, buttonSize, buttonSize);
  image(replayImg, cx, cy + 100, buttonSize, buttonSize);

  // Control toggle button
  fill(100);
  rect(cx + controlButtonXOffset, cy + controlButtonYOffset, controlButtonSize, controlButtonSize);
  fill(255);
  text("x", cx + controlButtonXOffset, cy + controlButtonYOffset);

  // Controls bar
  if (showControlsBar) {
    drawControlsBar(cx, cy + controlButtonYOffset + 100);
  }

  // Stop button
  if (showStop) {
    fill(255,0,0);
    rect(cx, cy, stopButtonW, stopButtonH);
    fill(255);
    text("Stop", cx, cy+2);
  }
}

void drawControlsBar(float cx, float cy) {
  fill(50);
  rect(cx, cy, controlBarW, controlBarH);

  // Loop toggle (long press)
  fill(100);
  rect(cx + controlBarOffsetsX[0], cy, 80, 40);
  fill(255);
  String loopLabel = loopInfinite ? "Loop: Infinite" : "Loop: Normal";
  text(loopLabel, cx + controlBarOffsetsX[0], cy);

  // Shuffle button
  fill(100);
  rect(cx + controlBarOffsetsX[1], cy, 80, 40);
  image(controlBarImages[0], cx + controlBarOffsetsX[1], cy, 40, 40);

  // Next button
  fill(100);
  rect(cx + controlBarOffsetsX[2], cy, 80, 40);
  image(controlBarImages[1], cx + controlBarOffsetsX[2], cy, 40, 40);

  // Previous button
  fill(100);
  rect(cx + controlBarOffsetsX[3], cy, 80, 40);
  image(controlBarImages[2], cx + controlBarOffsetsX[3], cy, 40, 40);

  // Mute/Unmute button
  float muteX = cx + muteXOffset;
  float muteY = cy + muteYOffset;
  if (isMuted) {
    image(muteImg, muteX, muteY, buttonSize, buttonSize);
  } else {
    image(unmuteImg, muteX, muteY, buttonSize, buttonSize);
  }
}

void mousePressed() {
  float cx = width/2;
  float cy = height/2;

  // Toggle main button
  if (mouseX > toggleButtonPos[0] - toggleButtonSizeVal/2 && mouseX < toggleButtonPos[0] + toggleButtonSizeVal/2 &&
      mouseY > height - toggleButtonPos[1] - toggleButtonSizeVal/2 && mouseY < height - toggleButtonPos[1] + toggleButtonSizeVal/2) {
    showPlayer = !showPlayer;
  }

  // Exit button
  if (mouseX > exitButtonPos[0] - exitButtonSizeVal[0]/2 && mouseX < exitButtonPos[0] + exitButtonSizeVal[0]/2 &&
      mouseY > exitButtonPos[1] - exitButtonSizeVal[1]/2 && mouseY < exitButtonPos[1] + exitButtonSizeVal[1]) {
    exit();
  }

  if (showPlayer) {
    // Play/Pause
    if (dist(mouseX, mouseY, cx, cy) < buttonSize/2) {
      pausePressTime = millis();
    }

    // Rewind 15s
    if (mouseX > cx - 200 - buttonSize/2 && mouseX < cx - 200 + buttonSize/2 && abs(mouseY - cy) < buttonSize/2) {
      if (currentAudio != null && currentAudio.isPlaying()) {
        currentAudio.cue(max(0, currentAudio.position() - 15000));
      }
    }

    // Skip 15s
    if (mouseX > cx + 200 - buttonSize/2 && mouseX < cx + 200 + buttonSize/2 && abs(mouseY - cy) < buttonSize/2) {
      if (currentAudio != null) {
        currentAudio.cue(min(currentAudio.length(), currentAudio.position() + 15000));
      }
    }

    // Replay
    if (mouseX > cx - buttonSize/2 && mouseX < cx + buttonSize/2 && abs(mouseY - (cy + 100)) < buttonSize/2) {
      if (currentAudio != null) {
        currentAudio.rewind();
        currentAudio.play();
        isPlaying = true;
      }
    }

    // Toggle controls bar
    if (mouseX > cx + controlButtonXOffset - controlButtonSize/2 && mouseX < cx + controlButtonXOffset + controlButtonSize/2 &&
        mouseY > cy + controlButtonYOffset - controlButtonSize/2 && mouseY < cy + controlButtonYOffset + controlButtonSize/2) {
      showControlsBar = !showControlsBar;
    }

    // Controls bar buttons
    if (showControlsBar) {
      float ctrlY = cy + controlButtonYOffset + 100;

      // Loop toggle (long press)
      if (dist(mouseX, mouseY, cx + controlBarOffsetsX[0], ctrlY) < 40) {
        if (millis() - pausePressTime > longPressThreshold) {
          loopInfinite = !loopInfinite;
        }
      }

      // Shuffle toggle (long press)
      if (dist(mouseX, mouseY, cx + controlBarOffsetsX[1], ctrlY) < 40) {
        if (millis() - pausePressTime > longPressThreshold) {
          shuffleOn = !shuffleOn;
        }
      }

      // Next
      if (dist(mouseX, mouseY, cx + controlBarOffsetsX[2], ctrlY) < 40) {
        nextSong();
      }

      // Previous
      if (dist(mouseX, mouseY, cx + controlBarOffsetsX[3], ctrlY) < 40) {
        previousSong();
      }
    }
  }
}

void mouseReleased() {
  float cx = width/2;
  float cy = height/2;

  // Play/Pause toggle
  if (dist(mouseX, mouseY, cx, cy) < buttonSize/2) {
    int duration = millis() - pausePressTime;
    if (duration > longPressThreshold) {
      showStop = true;
      stopButtonTimer = millis();
    } else {
      // Play/Pause toggle
      if (currentAudio != null) {
        if (currentAudio.isPlaying()) {
          currentAudio.pause();
          isPlaying = false;
        } else {
          currentAudio.play();
          isPlaying = true;
        }
      }
    }
  }
}

// Proper track switching
void nextSong() {
  if (currentAudio != null && currentAudio.isPlaying()) {
    currentAudio.pause(); // pause current track
    currentAudio.rewind(); // reset position
  }
  currentSongIndex = (currentSongIndex + 1) % playlist.length;
  currentAudio = playlist[currentSongIndex];
  currentAudio.rewind();
  currentAudio.play();
  isPlaying = true;
}

void previousSong() {
  if (currentAudio != null && currentAudio.isPlaying()) {
    currentAudio.pause(); // pause current track
    currentAudio.rewind(); // reset position
  }
  currentSongIndex = (currentSongIndex - 1 + playlist.length) % playlist.length;
  currentAudio = playlist[currentSongIndex];
  currentAudio.rewind();
  currentAudio.play();
  isPlaying = true;
}

// When closing the sketch, release resources
void stop() {
  if (currentAudio != null) {
    currentAudio.pause();
    currentAudio.rewind();
    currentAudio.close();
  }
  minim.stop();
  super.stop();
}
