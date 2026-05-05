void musicLoad() {
  minim = new Minim(this);
  String absolutePath = sketchPath(); //To MAIN Program
  //println("Absolute Path:", absolutePath);
  String upArrow = "/../../../";
  String musicDirectory = "Dependancies/Music/"; //Hardcoded, always relative to the MAIN program
  String musicPathway = absolutePath + upArrow + musicDirectory;
  //println("Music Pathway:", musicPathway);
  //println(); //Note: space left, one method formatting CONSOLE
  //
  File musicFolder = new File(musicPathway); //Uses Java Library to create class (variables & code)
  //A class is like an .mp3 that has music and text information
  File[] filePathway_Name = musicFolder.listFiles(); //Uses built in class to list all files
  //println("Music Folder Pathway & File Names: ");
  //printArray(filePathway_Name);
  //
  String[] files = new String[filePathway_Name.length]; //convert File to String for minim.loadFile()
  numberOfSongs = filePathway_Name.length;
  currentSong = numberOfSongs-numberOfSongs;
  //int i=0;
  if ( filePathway_Name != null ) {
    //
    //Comment FOR out and use FOR-Each, rememeber comment-in i above
    for ( int i=currentSong; i<numberOfSongs; i++) {
      files[i] = musicPathway + filePathway_Name[i].getName(); //print fileNames.getName() Object to String
    } // End old FOR
    /*
    for ( File file : filePathway_Name ) { //FOR-EACH Loop, creates locate class
     files[i] = lessonDependanciesFolder + file.getName(); //print filePathway_Name.getName() Object toString
     //Note: getName() is built in code
     i++; //iteration necessary here, not in regular FOR
     }
     */
  }
  //printArray(files);
  //
  currentSong=0;
  playList = new AudioPlayer[numberOfSongs]; //sets the array length
  while ( currentSong < numberOfSongs ) {
    playList[ currentSong ] = minim.loadFile( files[ currentSong ] );
    currentSong++; //functions similar to FOR
  }
  currentSong=0;
  println("Loading currentSong Variable");
  randomStart = loadRandomStart();
  if ( randomStart==true ) {
    currentSong = int( random( numberOfSongs ) );
  } else {
    currentSong = loadCurrentSong();
  }
  println("Current Song is", currentSong+1, "of", numberOfSongs);
} //End Music Load
