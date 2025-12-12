import processing.sound.*; //imports the sound library for the audio play back or a audio loop

int day_number; //initialises the total number of days contained within the dataset

//initialising paramters for the layout of the screen
final int Width = 800; //width of the layout
final int Height = 800;//height of the layout visualisation
final int Margin = 150;//argin
final int L_Space = 200; //legend space for extra horizontal space

//creating an array to store my type of emotions which will be used later
String[] emotions = {"Joy","Excitement","Calm","Tiredness","Stress","Sad","Boredom"};
DearData[] dataTable;//Array storing emotions and it's emotions intensity of each day

//for the hovering and pinning where it is first initialise this attributes
DearData hoveredData = null;
DearData pinnedData = null;

//tooltip or more like a pop up view of the displayed data
float xTip = 0; 
float yTip =0;

//the sound setting
SoundFile song; //will use my favourite christmas song, cause why not.
float trackVol = 0.2;//current playback volume of the background
float trackSpeed = 1;//current playback speed of the audio

void settings(){
  size(Width + L_Space,Height);
}


void setup(){
  background(30);//background colour
  colorMode(HSB, 360,100,100); //use of hue,saturation and brightness for displaying colours
  
  //add song
  song = new SoundFile(this,"SantaBaby.mp3");
  song.loop(); //this loops the song and hence the continuous playback.
  song.amp(trackVol); //this is cause the song on a lower softer volumen base
  
  //load the csv table that i converted from my excel to my csv file
  Table table = loadTable("emotions_data_100.csv","header");
  if(table == null) exit();// if the cvs file doesn't link, the table would be empty hence exits
  
  day_number = table.getRowCount();  //gets the day number from the cvs file and gives the days its number depending on the data.
  dataTable = new DearData[day_number]; 
  
  for (int i=0; i<day_number;i++){ //loops from 0 upto day_number(exclusive)
    TableRow row = table.getRow(i); //gets the row of the table where the data is of the cvs file attached in data
    //this gets and reads the days from the row along with the other data such as the Primary data, level intensity.
    int d = row.getInt("Day");
    String e = row.getString("Primary Emotion");
    int level_intensity = row.getInt("Intensity");
    dataTable[i] = new DearData(d,e,level_intensity); //the dataTable is then updated  and the DearData object is created which then has data inputs of the day number, the Primary emotion and the intensity via the for loop that loops through each loop which is added to the array
  }
}

void draw(){
  background(30);
  translate(Width/2, Height/2);
  float max_intensity = (Width/2)- Margin; //the bar display 
  hoveredData = null; //when user doesn't have their mouse on the an spinners option, the hoveredData would be null with no information to provide.
  
  //for the hovering features displayed to the user
  for(int i =0; i<day_number; i++){
    DearData d = dataTable[i]; 
    float direction = map(d.day, 1, day_number,0 , 2 * PI); //and positions the day map between teh angles between 0 and 2 pi meaning around a circle as a spin a wheel layout
    float vibrate = noise(frameCount * 0.01 + d.day *0.2) *15; //generates viration offset based and changes over time and varies per day
    float intensity_bar = map(d.intensity, 1, 10, 10, max_intensity) + vibrate; //converts the intensity data into size ranges from 1-10 and then adds vibration depending on the intensity
    
    if(isMouseOverBar(d, direction, intensity_bar)) hoveredData = d;
  }
  boolean focusLevel = (hoveredData !=null || pinnedData !=null); //is false or true depending if the user has or hasn't pinned the bar
  
  //for the bars to be displayed
  
  for (int counter = 0; counter<day_number; counter++){
    DearData d = dataTable[counter];
    float direction = map(d.day , 1, day_number, 0, 2 * PI);//this computes angle
    float vibrate = noise(frameCount * 0.01+ d.day * 0.2) *15;//vibration
    float intensity_bar = map(d.intensity, 1, 10 , 10 , max_intensity) + vibrate;
    
    boolean x = (hoveredData == d); //it will be true when user hovers over the spinner pointers
    boolean pinned = (pinnedData ==d);
    
    float alphaMult = 1.0; //initialsed as fully opaque 
    //if in focus mode and the data is not pinned 
    if(focusLevel && !(x || pinned))
    alphaMult = 0.25; //for transparency and well as it means 25% opacity
    
    //if the spinner pointers are pinned or hovered, there is pulsing animation to the pointer sticks of the spinner
    float pulse = (x || pinned) ? (sin(frameCount * 0.15) * 2 + 2) : 0;
    pushMatrix(); //this saves the transormation display
    rotate(direction); //it makes sure the day number which are the spinner pointers are mapped in different angles
    
    color base = getColorForEmotion(d.emotion); //base colour for emotions
    float h = hue(base);//hue component of the colour 
    float b = brightness(base) * alphaMult;//this adjust teh brightness based on the transparency.
    float s = saturation(base); //the saturation component of the colour for the emotion
     
    stroke(color(h, s, b));//stroke colour
    strokeWeight((x || pinned) ? 4+ pulse :3);//thickeness of the stroke if the user howevers or pins the pointer stick
    line(0, 0, intensity_bar + pulse*3,0); //pulsing option with the main intensity bar
    
    noStroke();//no stroke lines
    fill(color(h, s, b));
    float end = intensity_bar + pulse * 3;
    float dot_spinnerEnd = (x || pinned) ?  10 + pulse : 8;
    ellipse(end, 0, dot_spinnerEnd, dot_spinnerEnd);//the end of the spinner pointer(intensity bar) has a ellipse shape
    

    popMatrix(); //restores the previous transformation
    
  }
  
  //this is for the data shown within the tooltip when the mouse hovers over the spinner
  DearData displays = pinnedData != null? pinnedData : hoveredData;
  
  if(displays != null){
    float x1 = mouseX - Width/2;
    float y1 = mouseY - Height/2 -40;
    
    xTip = xTip +(x1-xTip) *0.15;//interpolation of the toolTip x
    yTip = yTip + (y1-yTip) *0.15;//interpolation of the toolTip Y
    
    pushMatrix(); 
    translate(xTip, yTip);
    
    //colour and the rectangle box for the pop up tooltip
    color z = getColorForEmotion(displays.emotion);
    fill(z);
    stroke(0,0,100);
    rectMode(CENTER);
    rect(0,0,150,55,7);//draws the tooltip background
    
    fill(0,0,0);
    textAlign(CENTER, CENTER);
    textSize(12);
    //displays the tooltip infomation of the day and its emotion intensity
    text("Day "+ displays.day + "\n" + displays.emotion + " (" +displays.intensity + ")", 0,0);
    popMatrix();
  }
  //LEGEND( checked on stackoverflow
  pushMatrix();//save the current transdormation stae
  translate(-Width/2, -Height/2);//move the origin to the top-left corner
  drawLegend();//this calls the function to drae the legend on the screen
  popMatrix();//restores the previous transformation state to prevent confusion with other objects
  
  //this is where my sound is controlled within the project and where i was so excited about,
  //the sound depends on my emotion intensity.
  
  if(displays != null){//if user hovers over an emotion
    //for low intensity emotions, there is a slight reduction in volume of the song 
    float targetVol = map(displays.intensity, 1, 10, 0.05, 1.0); //this maps the emotion intensity to a target volume of the song( so low vol= low intensity, high intensity = higher pitch)
    trackVol = trackVol + (targetVol - trackVol)* 0.1; //graduale change
    song.amp(trackVol); //this sets the song's volume
    
    float targetSpeed = 1 + map(displays.intensity, 1, 10, 0 , 0.2);//this maps the intensity to the playback speed
    trackSpeed = trackSpeed + (targetSpeed - trackSpeed)* 0.1;
    song.rate(trackSpeed);
  }else{
    //if the user does not hover over the intensity of emotions , the volume would go back to the original softer base volume
    trackVol = trackVol+(0.2 - trackVol)*0.05;
    song.amp(trackVol);
    
    trackSpeed = trackSpeed +( 1 - trackSpeed)* 0.05;
    song.rate(trackSpeed);
  }
  
  
  
}
//when user presses a key, it saves the image
void keyPressed(){
  save("myImage.png");
}

void mousePressed(){
  if(hoveredData != null){
    //the user can choose to pin the bar to keep the volume at the level or to feel the emotions?
    if(pinnedData == hoveredData ) pinnedData = null;
    else pinnedData = hoveredData;
  }else{
    //if the mouse is clicked in the background and not on the spinners, the spinner would unpin and the volume would go back to a sifter level
    pinnedData = null;
    hoveredData = null;
    //if mouse isn't hovering/pinning over the bar, it returns to the base colume and speed of teh music
    
    trackVol = 0.2;
    song.amp(trackVol);
    
    trackSpeed = 1;
    song.rate(trackSpeed);
   
  }
}

boolean isMouseOverBar(DearData d, float direction, float intensity_bar){
  //calculates the distance of the mouse from the center of the layout canvas.
  float dx = mouseX - Width/2;
  float dy = mouseY - Height/2;
  
  float a = atan2(dy,dx); //the angle of the mouse is relative to the center. atan2() gives the angles between the positive x-axis and the distance(dx and dy) 
  if(a<0) a += 2 * PI; //converts negative angles to full range 0-2pi range
  float distance = sqrt(dx*dx + dy *dy);//displays the straight line distance from the center of the wheel
  //these map out the current day to the small range(at an angle) on the wheel, where a1 would be the start angle and the a2 would be the end angle of the day
  float a1 = map(d.day - .5, 1 , day_number, 0, 2 *PI);
  float a2 = map(d.day + 0.5, 1, day_number, 0, 2 * PI);
  
  return (distance <= intensity_bar + 10 && a>= a1 && a<a2);//returns true if mouse is within the intensity bar
}
//this returns the colour for the emotions for the spinner emotion intensity bar
color getColorForEmotion(String e){
 //displays colour of emotion depending on the hue, saturation and the brightess
if(e.equals("Joy")) return color(60,100,100);
  if(e.equals("Excitement")) return color(300,80,90);
  if(e.equals("Calm")) return color(30,95,110);
  if(e.equals("Tiredness")) return color(30,20,75);
  if(e.equals("Stress")) return color(0,95,100);
  if(e.equals("Sad")) return color(220,70,95);
  if(e.equals("Boredom")) return color(120,20,70);
  return color(0,0,70);
}

void drawLegend(){
  //the coordinates for the legend 
  float x2 = Width + 25;//x -position
  float y2 = Margin;//y position
  
  //this defines the size of the color swatches and the spaceBar
  float swatch = 15;
  float spaceBar = 22;
  
 //This determines the emotions to highlight based on the users interactions
  String EmotionFocusLevel = null;
  if(pinnedData != null)
  EmotionFocusLevel = pinnedData.emotion;//will depend on the pinned data 
  else if (hoveredData != null)
  EmotionFocusLevel = hoveredData.emotion;//else it will use the emotions from the hovered data
  
  fill(0,0,90);//text colour depending on the HSB (hue, saturation and Brightness)
  textSize(15);//font size
  textAlign(LEFT,CENTER);//text align to theleft and centered
  text("Emotion Key: ", x2, y2);//title at (x2,y2)
  y2 += spaceBar*1.5;//adds spaceBar after the title by moving Y position down 
  
  
  
  for(String e:emotions){
    color c = getColorForEmotion(e);//it gets the colours associated with the emotions
    boolean focused = (EmotionFocusLevel != null && e.equals(EmotionFocusLevel));//this checks if the emotion is cuirrenly focused
    float pulse = focused ? (sin(frameCount * 0.15) * 3 + 4) : 0;//calculation of the pulsing effect from the focused emotions
    
    if(focused){
      noStroke();
      fill(hue(c), saturation(c), brightness(c),60);//fills in with transparent hightlighed ellipse for focused emotion when user hovers or pins it
      ellipse(x2+ swatch/2-10, y2 + swatch/2-10, swatch + 18 + pulse, swatch + 18 + pulse);
    }
    
    noStroke();
    fill(c);
    
    rect(x2, y2, swatch,swatch);//rectangle containing the emotion's colour 
    
    fill(0,0,90);
    textSize(15);
    textAlign(LEFT,CENTER);
    text(e,x2+swatch+10, y2 + swatch/2-10); //display the emotion and where and how the text would be displayed
    y2 += spaceBar;//moves the position for the next emotion menu to be displayed 
    
  }
  //displays the menu describing the intensity level 
  
  y2 += spaceBar * 2;
  textSize(14);
  text("Intensity Key: ", x2, y2);
  y2 += spaceBar *1.5;
  
  textSize(12);
  text("Low (1)", x2,y2);
  stroke(0,0,90);
  line(x2+60 , y2, x2 + 60 + 15, y2);
  
  y2 += spaceBar;
  text("High(10)",x2,y2);
  line(x2 + 60,y2,x2 + 60 + 100,y2);
}

class DearData{
  int day;
  String emotion;
  int intensity;
  DearData(int d, String e, int i){
    day = d;
    emotion = e;
    intensity = i;
  }
}
