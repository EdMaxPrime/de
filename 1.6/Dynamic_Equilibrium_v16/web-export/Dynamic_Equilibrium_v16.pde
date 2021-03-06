/*@pjs font="Arial.ttf"*/
int counter;
int gridSize;
int redT = 0;
int redA = 0;
int blueT = 0;
int blueA = 0;
int greenT = 0;
int greenA = 0;
int redRange = 1;
int blueRange = 1;
int greenRange = 1;
int equalized = 0;
int released = 0;
int cpl = 50;
color selectedColor = color(128, 128, 128);
var clickSound = new Audio("http://mod.zlotskiy.com/EdMaxPrime/pjs/click.ogg");
var calmSound = new Audio("http://mod.zlotskiy.com/EdMaxPrime/pjs/exhale.ogg");
String place = "/help/instructions.rtf";
DPixel[][] grid; // The two dimensional array that has all the pixels in it
Brush brush; // The user's brush
PFont f;
PImage hueAndSat;
boolean paused;
boolean stats;
boolean info;
boolean debug;
boolean eqSoundPlayed = false;
float speed;

void setup() {  //setup function called initially, only once
  size(400, 400);
  background(255);  //set background white
  colorMode(RGB);   //set colors to Hue, Saturation, Brightness mode
  counter = 0;
  f = createFont("Arial.ttf",14,true);
  released = false;
  paused = true;
  stats = false;
  info = false;
  debug = false;
  brush = new Brush(128,128,128,1);
  colorMode(HSB, 360, 100, 100);
  hueAndSat = createImage(360, 100, RGB);
  for(int h = 0; h < hueAndSat.width; h++) {
    for(int s = 0; s < hueAndSat.height; s++) {
      color c = color(h, 100 - s, 100);
      hueAndSat.pixels[s * hueAndSat.width + h] = c;
    }
  }
  colorMode(RGB, 256, 256, 256);
}

void draw() {  //draw function loops
  released++;
  if(place.equals("/help/instructions.rtf")){
    background(250);
    textFont(f);
    text("    Welcome to Dynamic Equilibrium. This is a visualization of the concept. In nature things tend to reach a balance. On the screen you can create colored pixels and borders. When you run the simulation all of the pixels will try to balance out their colors with their neighbors. The borders will not allow colors to be transfered to them. This allows you to create interesting chain reactions.\n    Click here to start.",5,20,width-12,200);
    //text("version 1.6",5,height);
    renderText("version 1.6 <rgb 255 0 0>BETA", 5, height);
    button("Play","style(width:" + ofWidth("2/5") + ";Go(/game/create",ofWidth("3/10"),ofHeight("1/2"));
    button("Help","style(width:" + ofWidth("2/5") + ";Go(/help/keys.rtf",ofWidth("3/10"),ofHeight("3/5"));
    button("More","style(width:" + ofWidth("2/5") + ";Go(/game/versions",ofWidth("3/10"),ofHeight("7/10"));
  }
  else if(place.equals("/game/create")) {
    background(250);
    text("Choose the dimensions of the simulation:",2,20);
    button("5x5","grid(5;Go(/game/menu",ofWidth("3/10"),24+ofHeight("1/10"));
    button("10x10","grid(10;Go(/game/menu",ofWidth("3/10"),24+2*(height/10));
    button("25x25","grid(25;Go(/game/menu",ofWidth("3/10"),24+3*(height/10));
    button("40x40","grid(40;Go(/game/menu",ofWidth("3/10"),24+4*(height/10));
    button("50x50","grid(50;Go(/game/menu",ofWidth("3/10"),24+5*(height/10));
    button("65x65","grid(65;Go(/game/menu",ofWidth("3/10"),24+6*(height/10));
    button("80x80","grid(80;Go(/game/menu",ofWidth("3/10"),24+7*(height/10));
    button("100x100","grid(100;Go(/game/menu",ofWidth("1/2"),24+ofHeight("1/10"));
    button("115x115","grid(115;Go(/game/menu",ofWidth("1/2"),24+2*(height/10));
    button("125x125","grid(125;Go(/game/menu",ofWidth("1/2"),24+3*(height/10));
    button("140x140","grid(140;Go(/game/menu",ofWidth("1/2"),24+4*(height/10));
    button("150x150","grid(150;Go(/game/menu",ofWidth("1/2"),24+5*(height/10));
    button("175x175","grid(175;Go(/game/menu",ofWidth("1/2"),24+6*(height/10));
    button("200x200","grid(200;GO(/game/menu",ofWidth("1/2"),24+7*(height/10));
    button("Back", "Go(/help/instructions.rtf",5,24+8*(height/10));
    //text("recommended",(width/5)+4,2*(height/10)+38); 25x25
    //text("slow",(width/5)+4,4*(height/10)+38); 50x50
    //text("very slow",(width/5)+4,5*(height/10)+38); 100x100
    //text("just no",(width/5)+4,6*(height/10)+38); 200x200
  }
  else if(place.equals("/game/grid")) {
   redT=0; blueT=0; greenT=0;
   for(int x = 0; x < grid[0].length; x++) {
     for(int y = 0; y < grid[0].length; y++) {
       grid[x][y].displer();
       fill(255);
       if(paused==false) {grid[x][y].chooseNeighbor();}
       redT += grid[x][y].red;
       blueT += grid[x][y].blue;
       greenT += grid[x][y].green;
     }
   }
   text(str(frameCount)+" "+strToggle(toggle(paused))+" "+round(100*(equalized/(gridSize*gridSize)))+"%",5,20);
   if(equalized >= 3*(gridSize*gridSize)/4 && eqSoundPlayed == false) { calmSound.play(); eqSoundPlayed=true; }
   brush.paint();
   redA = redT/(grid[0].length*grid[0].length);
   blueA = blueT/(grid[0].length*grid[0].length);
   greenA = greenT/(grid[0].length*grid[0].length);
   showStats();
  }
  else if(place.equals("/game/menu")) {
    background(250);
    fill(0);
    button("Play","Go(/game/grid;pause(false",5, 5);
    button("Main menu", "Go(/help/instructions.rtf", 5, 5 + ofHeight("1/10"));
    text("The game is " + booleanToString(paused, "") + " paused. Press:",ofWidth("1/5") + 5,20);
    renderText("<rgb 0 0 200>m <rgb 64 64 64>to switch between the game and this menu\n" +
               "<rgb 0 0 200>p <rgb 64 64 64>to toggle pause during the simulation\n" +
               "<rgb 0 0 200>r <rgb 64 64 64>to make a new grid with these settings\n" +
               "<rgb 0 0 200>s <rgb 64 64 64>to show statistics during the simulation\n" +
               "<rgb 0 0 200>i <rgb 64 64 64>to inspect individual pixels\n",
    ofWidth("1/5") + 5, 40);
    fill(0);
    colorPicker(5, ofHeight("3/10"), "brush($r,$b,$g", color(brush.red, brush.green, brush.blue));
    String temp = ",width:" + ofWidth("4/5");
    slider(width/10+10, ofHeight("15/20"), "style(text:Red Range is $v" + temp + ";set(rRange,$v", redRange, 30);
    slider(width/10+10, ofHeight("17/20"), "style(text:Green Range is $v" + temp + ";set(gRange,$v", greenRange, 30);
    slider(width/10+10, ofHeight("19/20"), "style(text:Blue Range is $v" + temp + ";set(bRange,$v", blueRange, 30);
  }
  else if(place.equals("/help/keys.rtf")) {
    background(250);
    fill(0);
    text("These are the key bindings, they only work when you are on the grid.\nThey might not work on mobile devices.", 5, 20);
    stroke(0);
    line(width/10, height/5, 9*(width/10), height/5);
    text("Press M to go to the game menu", width/5, height/5+15);
    line(width/10, height/5+20, 9*(width/10), height/5+20);
    text("Press P to toggle pause", width/5, height/5+35);
    line(width/10, height/5+40, 9*(width/10), height/5+40);
    text("Press I to toggle the info tooltip", width/5, height/5+55);
    line(width/10, height/5+60, 9*(width/10), height/5+60);
    text("Press S to toggle the statistics box", width/5, height/5+75);
    line(width/10, height/5+80, 9*(width/10), height/5+80);
    text("Press R to generate a new grid while in the game", width/5, height/5+95);
    line(width/10, height/5+100, 9*(width/10), height/5+100);
    
    button("Main menu","Go(/help/instructions.rtf", 5, height-(height/10));
    button("Next =>>","Go(/help/1.5", width-(width/5), height-(height/10));
  }
  else if(place.equals("/help/1.5")) {
    background(250);
    fill(0);
    text("    A range is the maximum difference between one pixel\'s color and its neighbor\'s color. There is a range for each color(red, green, blue) that you can customize.\n    The grid is generated randomly, which would explain why the average color usually falls around 128.",5,20,width-5,200);
    
    
    button("Main menu","Go(/help/instructions.rtf", 5, height-(height/10));
    button("<<= Back","Go(/help/keys.rtf", width-(width/5), height-(height/10));
  }
  else if(place.equals("/help/change")) {
    background(250);
    
    button("Main menu","Go(/help/instructions.rtf", 5, 9*(height/10));
    button("Play", "Go(/game/create", 2*(width/5), 9*(height/10));
    button("Help", "Go(/help/keys.rtf", 4*(width/5), 9*(height/10));
  }
  else{ //Unknown location
    paused = true;
    background(250);
    fill(0);
    text("Something went wrong \n There is a chance that your grid still exists \n If it exists then it has been paused",5,20);
    button("Go Back","Go(/game/grid",5,200);
    button("Home","Go(/help/instructions.rtf",width-5-(width/5),200);
  }
}
void button(String t, String action, int x, int y) { //A regular button
  int h = (height/10)-4;
  int w = (width/5)-4;
  String hoverT = t;
  if(action.indexOf("style(") > -1) {
    String[] params = split(split(action.substring(action.indexOf("style("), action.length), ";")[0], "(");
    String[] pairs = split(params[1], ",");
    for(int i = 0; i < pairs.length; i++) {
      String name = split(pairs[i], ":")[0];
      String value = split(pairs[i], ":")[1];
      if(name.equals("hover-text")) hoverT = value;
      else if(name.equals("width")) w = int(value);
      else if(name.equals("height")) h = int(value);
    }
  }
  fill(240);
  if(mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
      fill(200);
      t = hoverT;
      if(released < 3) {
        clickSound.play();
        String[] actions = split(action, ";");
        for(int i = 0; i < actions.length; i++) {
          doAction(actions[i]);
        }
        released++;
      }
  }
  stroke(0);
  rectMode(CORNER);
  rect(x,y,w,h); //A rectangle
  fill(0);
  textFont(f);
  text(t,centerX(t,w,x),centerY(t,h,y));
}
void holdme(String t, String action, int x, int y) { //Activates while you press the button
  int h = (height/10)-4;
  int w = (width/5)-4;
  fill(240);
  if(mousePressed && mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h) {
    fill(200);
    if(action.indexOf(";") != -1) {
          doAction(action.substring(0,action.indexOf(";")));
          background(0);
          action = action.substring(action.indexOf(";")+1,action.length);}
        doAction(action);
  }
  stroke(0);
  rectMode(CORNER);
  rect(x,y,w,h); //A rectangle
  fill(0);
  textFont(f);
  text(t,centerX(t,w,x),centerY(t,h,y));
}
void renderText(String t, int x, int y) { /*Added in 1.6*/
  String[] texts = splitTokens(t,"<>");
  int nextX = x;
  int nextY = y;
  int currentHeight = 14;
  color currentColor = color(0, 0, 0);
  PFont currentFont = f;
  for(int i = 0; i < texts.length; i++) {
    if(texts[i].indexOf("rgb") == 0) {
      String[] params = split(texts[i], " ");
      currentColor = color(int(params[1]), int(params[2]), int(params[3]));
    }
    else {
      fill(currentColor);
      textFont(currentFont);
      text(texts[i], nextX, nextY);
      String[] lines = split(texts[i], "\n");
      if(lines.length == 1) nextX += textWidth(texts[i]);
      else nextX = x + textWidth(lines[lines.length - 1]);
      nextY += (currentHeight + 5) * count(texts[i], "\n");
    }
  }
  textFont(f);
}
void colorPicker(int x, int y, String action) {
  stroke(0);
  image(hueAndSat, x, y, ofWidth("2/5"), ofWidth("2/5"));
  fill(0, 0, 0, map(cpl, 0, 99, 0, 255));
  rect(x - 1, y - 1, ofWidth("2/5") + 1, ofWidth("2/5") + 1);
  fill(0);
  slider(x + ofWidth("17/40"), y, "style(vertical:true,min:1;light($v", cpl, 100);
  if(mouseX >= x && mouseX <= x + ofWidth("2/5") && mouseY >= y && mouseY <= y + ofWidth("2/5") && mousePressed) {
    selectedColor = get(mouseX, mouseY);
  }
  noFill();
  int ex = map(hue(selectedColor), 0, 255, 0, ofWidth("2/5"));
  int ey = map(255 - saturation(selectedColor), 0, 255, 0, ofWidth("2/5"));
  ellipse(x + ex, y + ey, 5, 5);
  fill(selectedColor);
  rect(x + ofWidth("1/2"),y,ofWidth("1/10"),ofHeight("1/10"));
  fill(0);
  text("R: " + floor(red(selectedColor)) +
  "\nG: " + floor(green(selectedColor)) +
  "\nB: " + floor(blue(selectedColor)) +
  "\nH: " + floor(hue(selectedColor)) +
  "\nS: " + floor(saturation(selectedColor)) +
  "\nB: " + floor(brightness(selectedColor)),
  x + ofWidth("1/2"), y + ofHeight("1/10") + 14);
  String[] actions = split(action, ";");
  for(int i = 0; i < actions.length; i++) {
    actions[i] = actions[i].replace("$r",red(selectedColor)).replace("$g",green(selectedColor)).replace("$b",blue(selectedColor));
    actions[i] = actions[i].replace("$h",hue(selectedColor)).replace("$s",saturation(selectedColor)).replace("$l",brightness(selectedColor));
    doAction(actions[i].replace("$e", "$"));
  }
  /*button("border "+strToggle(brush.border),"toggle(brdbrush",width/10+10+2*(width/5),(height/2)+(height/10));
  button("random "+strToggle(brush.random),"toggle(rndbrush",width/10+10+3*(width/5),(height/2)+(height/10));*/
}
void strColor(color c) { return "(" + floor(red(c)) + ", " + floor(green(c)) + "," + floor(blue(c)) + ")"; }
int count(String body, String search) { /*Added in 1.6*/
  return split(body, search).length - 1;
}
int centerX(String t, int w, int x) { //This method returns the x position of horizontally aligned text
  return ((w-textWidth(t))/2)+x;
}
int centerY(String t, int h, int y) { //This method returns the y position of vertically aligned text
  return (h/2)+y+3;
}
int ofWidth(String fraction) { /*New in 1.6*/
  int numerator = int(split(fraction, "/")[0]);
  int denominator = int(split(fraction, "/")[1]);
  return width * (numerator/denominator);
}
int ofHeight(String fraction) { /*New in 1.6*/
  int numerator = int(split(fraction, "/")[0]);
  int denominator = int(split(fraction, "/")[1]);
  return height * (numerator/denominator);
}
boolean toggle(boolean b) {
  if(b) {return false;}
  else {return true;}
}
String strToggle(boolean b) {
  if(b) {return "off";}
  else {return "on";}
}
void mouseReleased() { //Runs when the mouse is released
  released = 0;
}
void doAction(String action) { //Interprets general action script, specifically for DE
  //This bit seperates the method name from the parameters
  String[] a = split(action, "(");
  if(a[0].equals("Go")) { // Go(location
    place = a[1];
  }
  else if(a[0].equals("grid")) { // grid(side
    grid = new DPixel[int(a[1])][int(a[1])];
    for(int x = 0; x < int(a[1]); x++) { //Makes all of the pixels
      for(int y = 0; y < int(a[1]); y++) {
        grid[x][y] = new DPixel(x,y,int(floor(random(256))),int(floor(random(256))),int(floor(random(256))),int(a[1]));
      }
    }
    gridSize = int(a[1]);
    brush.max = int(a[1]);
    place = "/game/grid";
    equalized = 0;
  }
  else if(a[0].equals("red")) {brush.red += int(a[1]); brush.border = false; brush.random = false;}
  else if(a[0].equals("green")) {brush.green += int(a[1]); brush.border = false; brush.random = false;}
  else if(a[0].equals("blue")) {brush.blue += int(a[1]); brush.border = false; brush.random = false;}
  else if(a[0].equals("border")) {brush.border = boolean(a[1]);}
  else if(a[0].equals("pause")) {paused = boolean(a[1]);}
  else if(a[0].equals("toggle")) {
    if(a[1].equals("brdbrush")) {brush.border=toggle(brush.border); brush.random = false;}
    else if(a[1].equals("rndbrush")) {brush.random=toggle(brush.random); brush.border = false;}
  }
  else if(a[0].equals("error")) {
    error(a[1]);
  }
  else if(a[0].equals("set")) { /*Added in 1.6*/
    String name = split(a[1], ",")[0];
    String value = split(a[1], ",")[1];
    if(name.equals("rRange")) {redRange = int(value);}
    else if(name.equals("gRange")) { greenRange = int(value); }
    else if(name.equals("bRange")) { blueRange = int(value); }
  }
  else if(a[0].equals("brush")) { /*Added in 1.6*/
    String[] c = split(a[1], ",");
    brush.red = int(c[0]);
    brush.green = int(c[1]);
    brush.blue = int(c[2]);
  }
  else if(a[0].equals("light")) {/*Added in 1.6*/
    cpl = int(a[1]);
  }
}
int rng(int[] nums) { //Random integer generator
  return nums[int(floor(random(0,nums.length())))];
}
int getIntValue(String value) {
  if(value.equals("redRange")) { return redRange; }
  else if(value.equals("greenRange")) { return greenRange; }
  else if(value.equals("blueRange")) { return blueRange; }
}
void setIntValue(String value, int amount) {
  if(value.equals("redRange")) {redRange = amount;}
  else if(value.equals("greenRange")) { greenRange = amount; }
  else if(value.equals("blueRange")) { blueRange = amount; }
}
int slider(int x, int y, String action, int current, int range) {
  int w = ofWidth("2/5");
  int h = ofHeight("1/40");
  String t = "$v";
  int textX = (x+2*(width/5)-textWidth(t.replace("$v", current)))/2;
  int textY = y + 16 + h;
  color dragger = color(200);
  color dragColor = color(100);
  int minValue = 1;
  boolean vertical = false;
  if(action.indexOf("style(") > -1) {
    String[] params = split(split(action.substring(action.indexOf("style("), action.length), ";")[0], "(");
    String[] pairs = split(params[1], ",");
    for(int i = 0; i < pairs.length; i++) {
      String name = split(pairs[i], ":")[0];
      String value = split(pairs[i], ":")[1];
      if(name.equals("vertical")) {vertical = true; w = ofWidth("1/40"); h = ofHeight("2/5");}
      else if(name.equals("width")) w = int(value);
      else if(name.equals("height")) h = int(value);
      else if(name.equals("min")) {minValue = int(value); current = Math.max(minValue, current); current = Math.min(minValue + range - 1, current);}
      else if(name.equals("text")) t = value;
      else if(name.equals("d")) {String[] d = split(value, "|"); dragger = color(int(d[0]), int(d[1]), int(d[2]));}
      else if(name.equals("d-h")) {String[] d = split(value, "|"); dragColor = color(int(d[0]), int(d[1]), int(d[2]));}
    }
  }
  int interval = vertical? Math.round(h/range) : Math.round(w/range);
  rectMode(CORNER);
  fill(230);
  stroke(0);
  rect(x, y, w, h, 5);
  fill(dragger);
  if(mousePressed && mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h) {
    if(vertical == false) {
      current = Math.min(Math.round((mouseX - x)/interval) + minValue, minValue + range);
    } else {
      current = Math.min(Math.round(map(mouseY - y, 0, h, minValue, minValue + range)), minValue + range); //Math.round((mouseY - y)/interval) + minValue;
    }
    String[] actions = split(action, ";");
    for(int i = 0; i < actions.length; i++) { //escape $v with $e
      doAction(actions[i].replace("$v", current).replace("$e", "$"));
    }
    fill(dragColor);
  }
  if(vertical == false) {
    rect(x + ((current - minValue) * interval), y, Math.min(w, h), Math.min(w, h));
  } else {
    rect(x, y + (current - minValue) * (h/range), Math.min(w, h), Math.min(w, h));
  }
  fill(0);
  if(vertical == false) {
    textX = (x + ofWidth("2/5") - textWidth(t.replace("$v", current)))/2;
    textY = y + 16 + h;
  } else {
    textX = x + w + 4;
    textY = y + current * (h/range) + 12;
  }
  text(t.replace("$v", current), textX, textY);
  return current;
}
void showStats() { //Shows the stats
 if(stats) {
  fill(0,0,0,128);
  rect(0,0,(width/4)+(width/8),3*(height/10));
  fill(255);
  text("Average Red:"+int(redA),5,40);
  text("Average Blue:"+int(blueA),5,60);
  text("Average Green:"+int(greenA),5,80);
  }
  if(info) {
  stroke(224, 210, 54);
  fill(255, 64);
  int x = int(floor(mouseX / (width/gridSize)));
  int y = int(floor(mouseY / (height/gridSize))); 
  rect((width/gridSize)*x, (height/gridSize)*y, width/gridSize, height/gridSize);
    if(mouseX < width/2) {
      stroke(64, 128, 230);
      strokeWeight(2);
      fill(0);
      rect(mouseX+width/gridSize, (height/gridSize)*y, textWidth("x:00 y:00 rgb:000,000,000"), 20, 5);
      fill(255);
      text("x:"+x+" y:"+y+" rgb:"+grid[x][y].red+","+grid[x][y].green+","+grid[x][y].blue, mouseX+width/gridSize, (height/gridSize)*y+16);
      strokeWeight(1);
    } else {
      stroke(64, 128, 230);
      strokeWeight(2);
      fill(0);
      rect(mouseX-width/gridSize-textWidth("x:00 y:00 rgb:000,000,000"), (height/gridSize)*y, textWidth("x:00 y:00 rgb:000,000,000"), 20, 5);
      fill(255);
      text("x:"+x+" y:"+y+" rgb:"+grid[x][y].red+","+grid[x][y].green+","+grid[x][y].blue, mouseX-width/gridSize-textWidth("x:"+x+" y:"+y+" rgb:"+grid[x][y].red+","+grid[x][y].green+","+grid[x][y].blue), (height/gridSize)*y+16);
      strokeWeight(1);
    }
 }
}
boolean withinRange(int num, int compare, int range) {
  if(num >= compare-range && num <= compare+range) { 
    return true;
  } else {
    return false;
  }
}
String booleanToString(boolean b, String type) { /*Added in 1.6*/
  if(type.indexOf("!") != -1) { b = toggle(b); type = type.substring(1, type.length); }
  if(type.equals("is")) return b? "is" : "is not"
  if(type.equals("are")) return b? "are" : "are not"
  if(type.equals("on")) return b? "on" : "off";
  if(type.equals("")) return b? "" : "not";
  if(type.equals("no")) return b? "" : "no";
  if(type.equals("yn")) return b? "yes" : "no";
}
void keyReleased() {
  if(key != CODED) {
    if(key == 'p' || key == 'P') {
      if(place.equals("/game/grid")) paused = toggle(paused);
    } //P
    else if(key == 'r' || key == 'P') {
      doAction("grid(" + gridSize);
    }
    else if(key == 'm' || key == 'M') {
      paused = true;
      if(place.equals("/game/grid")) place = "/game/menu";
      else if(place.equals("/game/menu")) place = "/game/grid";
    }
    else if(key == 's' || key == 'S') {
      stats = toggle(stats);
    }
    else if(key == 'i' || key == 'I') {
      info = toggle(info);
    }
    else if(key == 'd' || key == 'D') {
      debug = toggle(debug);
    }
  } else {
    
  }
}

class Brush{
  int red;
  int green;
  int blue;
  int max;
  boolean border;
  boolean random;
  Brush(int r, int g, int b, int m) {
    red = r;
    green = g;
    blue = b;
    max = m;
    border = false;
    random = false;
  }
  void setColor(int r, int g, int b) {red = r; green = g; blue = b;}
  void paint() {
    if(red < 0) {red = 0;}
    if(green < 0) {green = 0;}
    if(blue < 0) {blue = 0;}
    if(red > 255) {red = 255;}
    if(green > 255) {green = 255;}
    if(blue > 255) {blue = 255;}
    if(mousePressed && mouseX >= 0 && mouseX <= width && mouseY >= 0 && mouseY <= height) {
      int x = int(floor(mouseX / (width/max)));
      int y = int(floor(mouseY / (height/max)));
      if(border) {
        grid[x][y].red = 224;
        grid[x][y].green = 210;
        grid[x][y].blue = 54;
        grid[x][y].border = true;
      } 
      else if(random) {
        int[] randomRanges = {0, 50, 100, 150, 200, 255};
        grid[x][y].red = rng(randomRanges);
        grid[x][y].green = rng(randomRanges);
        grid[x][y].blue = rng(randomRanges);
        grid[x][y].border = false;
      } else {
        grid[x][y].red = this.red;
        grid[x][y].green = this.green;
        grid[x][y].blue = this.blue;
        grid[x][y].border = false;
      }
    }
  }
}
void error(String msg) {
  alert(msg);
}
class DPixel{ //Dynamic pixel class
  int xindex;
  int yindex;
  int red;
  int green;
  int blue;
  int size;
  int max;
  int rate;
  boolean border;
  boolean steady;
  DPixel(int x, int y, int r, int g, int b, int m) {//The constructor of this class
    xindex = x; //The x coordinate in the array
    yindex = y; //The y coordinate in the array
    red = r; //How much red the pixel has
    green = g; //How much green the pixel has
    blue = b; //How much blue the pixel has
    max = m; //The maximum amount of pixels in each row or column
    size = width/m; //The size of each pixel
    border = false; //If border is true then it will not update its neighbors and others can't update it either
    steady = false;
  }
  void chooseNeighbor() {
    /* The pixels are as follows:
    | 1 | 2 | 3 |
    | 8 |YOU| 4 |
    | 7 | 6 | 5 |
    */
    if(border == false) {
    if(xindex == 0 && yindex == 0) { //Upper left corner
      int client = int(floor(random(4,7)));
      balanceNeighbor(getPixel(client));
    }
    else if(xindex == 0 && yindex == max-1) { //Lower left corner
      int client = int(floor(random(2,5)));
      balanceNeighbor(getPixel(client));
    }
    else if(xindex == 0 && yindex != 0 && yindex != max-1) { //Left side
      int client = int(floor(random(2,7)));
      balanceNeighbor(getPixel(client));
    }
    else if(xindex == max-1 && yindex == 0) { //Upper right hand corner
      int client = int(floor(random(6,9)));
      balanceNeighbor(getPixel(client));
    }
    else if(xindex == max-1 && yindex == max-1) { //Lower right hand corner
      int client = rng(new int[]{8,1,2});
      balanceNeighbor(getPixel(client));
    }
    else if(xindex == max-1 && yindex != 0 && yindex != max-1) { //The right side
      int client = rng(new int[]{6,7,8,1,2});
      balanceNeighbor(getPixel(client));
    }
    else if(yindex == 0 && xindex != 0 && xindex != max-1) { //The top
      int client = int(floor(random(4,9)));
      balanceNeighbor(getPixel(client));
    }
    else if(yindex == max-1 && xindex != 0 && xindex != max-1) { //The bottom
      int client = rng(new int[]{8,1,2,3,4});
      balanceNeighbor(getPixel(client));
    }
    else { //The middle
      int client = int(floor(random(1,9)));
      balanceNeighbor(getPixel(client));
    }
    }
  }
  DPixel getPixel(int c) {
    switch(c) {
      case 1:
      return grid[xindex-1][yindex-1];
      break;
      case 2:
      return grid[xindex][yindex-1];
      break;
      case 3:
      return grid[xindex+1][yindex-1];
      break;
      case 4:
      return grid[xindex+1][yindex];
      break;
      case 5:
      return grid[xindex+1][yindex+1];
      break;
      case 6:
      return grid[xindex][yindex+1];
      break;
      case 7:
      return grid[xindex-1][yindex+1];
      break;
      case 8:
      return grid[xindex-1][yindex];
      break;
      default:
      return this;
      break;
    }
  }
  void balanceNeighbor(DPixel d) {
    int r = this.red - d.red;
    int b = this.blue - d.blue;
    int g = this.green - d.green;
    if(Math.max(r, g, b) == r && r >= redRange) {
      if(r < 8) { d.red++; this.red--; }
      else if(r < 16) { d.red+=2; this.red-=2; }
      else if(r < 32) { d.red+=3; this.red-=3; }
      else if(r < 64) { d.red+=4; this.red-=4; }
      else if(r < 128) { d.red+=5; this.red-=5; }
      else if(r < 256) { d.red+=6; this.red-=6; }
    } else if(Math.max(r, g, b) == b && b >= blueRange) {
      if(b < 8) { d.blue++; this.blue--; }
      else if(b < 16) { d.blue+=2; this.blue-=2; }
      else if(b < 32) { d.blue+=3; this.blue-=3; }
      else if(b < 64) { d.blue+=4; this.blue-=4; }
      else if(b < 128) { d.blue+=5; this.blue-=5; }
      else if(b < 256) { d.blue+=6; this.blue-=6; }
    } else if(Math.max(r, g, b) == g && g >= greenRange) {
      if(g < 8) { d.green++; this.green--; }
      else if(g < 16) { d.green+=2; this.green-=2; }
      else if(g < 32) { d.green+=3; this.green-=3; }
      else if(g < 64) { d.green+=4; this.green-=4; }
      else if(g < 128) { d.green+=5; this.green-=5; }
      else if(g < 256) { d.green+=6; this.green-=6; }
    }
    if(withinRange(r,redRange,1)&&withinRange(g,greenRange,1)
        &&withinRange(b,blueRange,1) && steady == false) {
      equalized++; steady = true;
    }
  }
  void displer() {
    rectMode(CORNER);
    fill(red,green,blue);
    noStroke();
    rect(xindex*size,yindex*size,size,size);
    if(steady && debug) { fill(250); rect(xindex*size, yindex*size,size,size); }
  }
}
interface Generator {
  DPixel[][] generate();
}

