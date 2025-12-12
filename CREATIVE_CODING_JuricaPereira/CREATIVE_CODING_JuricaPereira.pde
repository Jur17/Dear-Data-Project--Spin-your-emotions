import processing.sound.*;

int day_number;

//initialising paramters for the layout of the screen
final int Width = 800; 
final int Height = 800;
final int Margin = 150;
final int L_Space = 200; //legend space

//creating an array to store my type of emotions which will be used later
String[] emotions = {"Joy","Excitement","Calm","Tiredness","Stress","Anxiety","Boredom"};
DearData[] dataTable;

//for the hovering and oinning where i first initialise this attributes
DearData hoveredData = null;
DearData pinnedData = null;

//tooltip or more like a pop up view of the displayed data
float Xtip = 0;
float Ytip =0;

//the sound setting
SoundFile song; //will use my favourite christmas song, cause why not.
float trackVol = 0.2;
float trackSpeed = 1;

void settings(){
  size(Width + L_Space,Height);
}

void setup(){
  background(30);
  colorMode(HSB, 360,100,100);
  
  //add song
  song = new SoundFile(this,"SantaBaby.mp3");
  song.loop(); //this loops the song and hence the continuous playback.
  song.amp(trackVol); //this is cause the song on a lower softer volumen base
  
  //load the csv table that i converted from my excel to my csv file
  Table table = loadTable("emotions_data_100.csv","header");
  if(table == null) exit();
  
  day_number = table.getRowCount();
  dataTable = new DearData[day_number];
  
  for (int i=0; i<day_number;i++){ //had to ask my friends help for this
    TableRow row = table.getRow(i);
    int d = row.getInt("Day");
    String e = row.getString("Primary Emotion");
    int level_intensity = row.getInt("Intensity");
    dataTable[i] = new DearData(d,e,level_intensity);
  }
}

void draw(){
  background(30);
  translate(Width/2, Height/2);
  float max_intensity = (Width/2)- Margin;
  hoveredData = null;
  
  //for the hover detection 
  for(int i =0; i<day_number; i++){
    DearData d = dataTable[i];
    //I've used map for direction and bar length to be mapped as it will have unique values
    float direction = map(d.day, 1, day_number,0 , 2 * PI);
    float vibrate = noise(frameCount * 0.01 + d.day *0.2) *15; //i didnt want the spinner to vibrate alot
    float intensity_bar = map(d.intensity, 1, 10, 10, max_intensity) + vibrate;
    
    if(isMouseOverBar(d, direction, intensity_bar)) hoveredData = d;
  }
  boolean focusLevel = (hoveredData !=null || pinnedData !=null);
  
  //for the spinners to be displayed
  
  for (int counter = 0; counter<day_number; counter++){
    DearData d = dataTable[counter];
    float direction = map(d.day , 1, day_number, 0, 2 * PI);
    float vibrate = noise(frameCount * 0.01+ d.day * 0.2) *15;
    float intensity_bar = map(d.intensity, 1, 10 , 10 , max_intensity) + vibrate;
    
    boolean x = (hoveredData == d);
    boolean pinned = (pinnedData ==d);
    
    float alphaMult = 1.0;
    if(focusLevel && !(x || pinned)) alphaMult = 0.25; //for transparency and well as it means 25% opacity
    float pulse = (x || pinned) ? (sin(frameCount * 0.15) * 2 + 2) : 0;
    pushMatrix();
    rotate(direction);
    
    color base = getColorForEmotion(d.emotion);
    float h = hue(base);
    float b = brightness(base) * alphaMult;
    float s = saturation(base);
    
    stroke(color(h, s, b));
    strokeWeight((x || pinned) ? 4+ pulse :3);
    line(0, 0, intensity_bar + pulse*3,0);
    
    noStroke();
    fill(color(h, s, b));
    float end = intensity_bar + pulse * 3;
    float dot_spinnerEnd = (x || pinned) ?  10 + pulse : 8;
    ellipse(end, 0, dot_spinnerEnd, dot_spinnerEnd);
    
    popMatrix();
    
  }
  
  //this is for the data shown within the tooltip when the mouse hovers over the spinner
  DearData shown = pinnedData != null? pinnedData : hoveredData;
  
  if(shown != null){
    float x1 = mouseX - Width/2;
    float y1 = mouseY - Height/2 -40;
    
    Xtip = Xtip +(x1-Xtip) *0.15;
    Ytip = Ytip + (y1-Ytip) *0.15;
    
    pushMatrix();
    translate(Xtip, Ytip);
    
    //colour and the rectangle box for the pop up tooltip
    color z = getColorForEmotion(shown.emotion);
    fill(z);
    stroke(0,0,100);
    rectMode(CENTER);
    rect(0,0,150,55,7);
    
    fill(0,0,0);
    textAlign(CENTER, CENTER);
    textSize(12);
    text("Day"+ shown.day + "\n" + shown.emotion + " (" +shown.intensity + ")", 0,0);
    popMatrix();
  }
  //LEGEND( checked on stackoverflow
  pushMatrix();
  translate(-Width/2, -Height/2);
  drawLegend();
  popMatrix();
  
  //this is where my sound is controlled within the project and where i was so excited about,
  //the sound depends on my emotion intensity.
  
  if(shown != null){
    //for low intensity emotions, there is a slight reduction in volume of the song 
    float targetVol = map(shown.intensity, 1, 10, 0.05, 1.0);
    trackVol = trackVol + (targetVol - trackVol)* 0.1;
    song.amp(trackVol);
    
    float targetSpeed = 1 + map(shown.intensity, 1, 10, 0 , 0.2);
    trackSpeed = trackSpeed + (targetSpeed - trackSpeed)* 0.1;
    song.rate(trackSpeed);
  }else{
    //if the user doesnot hover over the intensity of emotions , the volume would go back to the original softer volume
    trackVol = trackVol+(0.2 - trackVol)*0.05;
    song.amp(trackVol);
    
    trackSpeed = trackSpeed +( 1 - trackSpeed)* 0.05;
    song.rate(trackSpeed);
  }
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
    
    trackVol = 0.2;
    song.amp(trackVol);
    
    trackSpeed = 1;
    song.rate(trackSpeed);
   
  }
}


boolean isMouseOverBar(DearData d, float direction, float intensity_bar){
  float dx = mouseX - Width/2;
  float dy = mouseY - Height/2;
  float a = atan2(dy,dx); //used this because??
  if(a<0) a += 2 * PI;
  
  float distance = sqrt(dx*dx + dy *dy);
  float a1 = map(d.day - .5, 1 , day_number, 0, 2 *PI);
  float a2 = map(d.day + 0.5, 1, day_number, 0, 2 * PI);
  
  return (distance <= intensity_bar + 10 && a>= a1 && a<a2);
}

color getColorForEmotion(String e){
  if(e.equals("Joy")) return color(60,90,100);
  if(e.equals("Excitement")) return color(30,95,100);
  if(e.equals("Calm")) return color(200,70,95);
  if(e.equals("Tiredness")) return color(240,40,80);
  if(e.equals("Stress")) return color(0,95,100);
  if(e.equals("Sad")) return color(300,80,90);
  if(e.equals("Boredom")) return color(120,20,70);
  return color(0,0,70);
}

void drawLegend(){
  float x2 = Width + 25;
  float y2 = Margin;
  
  float swatch = 15;
  float spacing = 22;
  
  String EmotionFocusLevel = null;
  if(pinnedData != null) EmotionFocusLevel = pinnedData.emotion;
  else if (hoveredData != null) EmotionFocusLevel = hoveredData.emotion;
  
  fill(0,0,90);
  textSize(15);
  text("Emotion Key: ", x2, y2);
  y2 += spacing *1.5;
  
  for(String e:emotions){
    color c = getColorForEmotion(e);
    boolean focused = (EmotionFocusLevel != null && e.equals(EmotionFocusLevel));
    float pulse = focused ? (sin(frameCount * 0.15) * 3 + 4) : 0;
    //need to change values for here
    if(focused){
      noStroke();
      fill(hue(c), saturation(c), brightness(c),60);
      ellipse(x2+ swatch/2, y2 + swatch/2, swatch + 18 + pulse, swatch + 18 + pulse);
    }
    
    noStroke();
    fill(c);
    rect(x2, y2, swatch,swatch,3);
    
    fill(0,0,90);
    textSize(12);
    textAlign(LEFT,CENTER);
    text(e, x2+swatch +10, y2 + swatch/2);
    y2 += spacing;
    
  }
  
  y2 += spacing * 2;
  textSize(14);
  text("Intensity Key: ", x2, y2);
  y2 += spacing *1.5;
  
  textSize(12);
  text("Low (1)", x2,y2);
  stroke(0,0,90);
  line(x2+60 , y2, x2 + 60 + 15, y2);
  
  y2 += spacing;
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

    
    
  
  
  
  
  
    
    
    
    
    
    
    
    
  
