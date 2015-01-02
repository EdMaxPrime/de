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
