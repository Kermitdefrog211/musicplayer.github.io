// Global Variables
int numberOfDIVs = 8; // Count of rect()
int numberOfParameters = 4; // Parameters per rectangle
float divs[] = new float[numberOfDIVs * numberOfParameters]; // Array for rectangle parameters

// Declare appWidth and appHeight as global variables
int appWidth;
int appHeight;

// Variables for buttons
float buttonWidth, buttonHeight;
float playButtonX, rewindButtonX, skipButtonX, replayButtonX;
float buttonsY;

void setup() {
  fullScreen(); // Use full display
  // Assign display dimensions to global variables
  appWidth = displayWidth;
  appHeight = displayHeight;
  divs(); // Compute rectangles
}

void draw() {
  // Optionally, draw the buttons here
  // Draw the existing UI rectangles
  for (int j = 0; j < divs.length; j += 4) {
    rectDIV(divs[j], divs[j + 1], divs[j + 2], divs[j + 3]);
  }

  // Draw control buttons
  fill(200); // Light gray fill
  rect(playButtonX, buttonsY, buttonWidth, buttonHeight);
  rect(rewindButtonX, buttonsY, buttonWidth, buttonHeight);
  rect(skipButtonX, buttonsY, buttonWidth, buttonHeight);
  rect(replayButtonX, buttonsY, buttonWidth, buttonHeight);

}

void divs() {
 //
  divs[0] = appWidth * 1.0f / 4.0f;
  divs[1] = appHeight * 1.0f / 4.0f;
  divs[2] = appWidth * 1.0f / 2.0f;
  divs[3] = appHeight * 1.0f / 2.0f; // Set initial height

  float referent = divs[2] / 13.0f;
  float column1 = divs[0] + referent;
  float row1 = divs[1] + referent;
  float textWidth = referent * 5.0f;
  float textHeight = referent * 3.0f;
  float column2 = column1 + referent;
  float column3 = column2 + referent;
  float column4 = column3 + referent;
  float column5 = column4 + referent;
  float column6 = column5 + referent * 2.0f;
  float row2 = row1 + textHeight + referent * 0.5f;
  float row3 = row2 + referent + referent * 0.5f;

  // Adjust height if needed
  float testHeight = referent * 2.5f + textHeight * 2.0f;
  float errorIncrease = referent * 0.5f;
  while (divs[3] < testHeight) {
    divs[1] -= errorIncrease;
    row1 = divs[1] + referent;
    row2 = row1 + textHeight + referent * 0.5f;
    divs[3] += errorIncrease;
  }

  int i = 4;
  // Rectangles: 4-11
  divs[i++] = appWidth - referent;
  divs[i++] = 0;
  divs[i++] = referent;
  divs[i++] = referent;

  // Song Title: 12-15
  divs[i++] = column1;
  divs[i++] = row1;
  divs[i++] = textWidth;
  divs[i++] = textHeight;

  // Music Buttons: 16-35
  divs[i++] = column1;
  divs[i++] = row2;
  divs[i++] = textWidth;
  divs[i++] = referent;

  // Add more rectangles as needed following the pattern

  // Calculate button sizes and positions
  buttonWidth = referent * 2; // Example size
  buttonHeight = referent;    // Example height
  float gap = referent * 0.5f; // Space between buttons

  // Set the y position for buttons (e.g., below the main UI)
  buttonsY = appHeight - buttonHeight - gap;

  // Set X positions for each button
  replayButtonX = appWidth - (buttonWidth + gap);
  skipButtonX = replayButtonX - (buttonWidth + gap);
  rewindButtonX = skipButtonX - (buttonWidth + gap);
  playButtonX = rewindButtonX - (buttonWidth + gap);
}

void rectDIV(float x, float y, float w, float h) {
  rect(x, y, w, h);
}
