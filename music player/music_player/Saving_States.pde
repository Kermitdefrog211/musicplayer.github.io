int loadCurrentSong() {
  String[] number = loadStrings(saveTxtPath_currentSong); //written as a string
  if (number != null && number.length > 0) {
    println("Loaded current song: " + number[0]);
    return int(number[0]);
  }
  return 0; // Default to the first song if no file exists
}
//
Boolean loadRandomStart() {
  String[] dataString = loadStrings(saveTxtPath_randomStart);
  Boolean dataBoolean;
  if (dataString != null && dataString.length > 0) {
    println("Loaded random start: " + dataString[0]);
    try {
      dataBoolean = Boolean.parseBoolean(dataString[0]);
    }
    catch (Exception e) {
      println("Error parsing boolean value: " + e);
      dataBoolean = false; // default value
    }
  } else {
    println("File is empty.");
    dataBoolean = false; // default value
    return dataBoolean;
  }
  return dataBoolean;
}//End Random Start Boolean
//
