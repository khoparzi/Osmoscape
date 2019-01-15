void readData() {
  data = readCSV("../../data/2018/57_Global_garbage_patches.csv", -2, "divided");
  if (data != null) {
    println(data);
    rows = data.length();
    cols = data.seriesCount();
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
    labels = new String[rows];
    colors = tools.colorSpectrum(cols-1,0.6,0.9);
    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();
      points[0][row] = new Vec2D(((row)%2) * 600, ((row)/2) * 250);
      for (int col=1; col < cols; col++) {
        if (data.get(col).isNumeric()) values[col-1][row] = rowData.getFloat(col);
        else labels [row] = rowData.getString(col);
      }
    }
  }
}

void render() {
  background(50); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line
  ellipseMode(CENTER);

  /* Write your drawing code here */
  if (data != null) {
    textAlign(CENTER,CENTER); fill(200); noStroke();
    for (int col=1; col < cols-1; col++) {
      fill(200);
      text(data.getSeriesLabel(col+1), width*0.5, ((col-1)*100)+50, 150, 50);
      fill(colors.get(col-1), 100);
      ellipse(width*0.5, ((col-1)*100)+50, 20, 20);
    }

    // float x = margin - (width * 0.5) + (width*0.25);
    String[] loc = data.get(0).asStringArray();
    for (int row=0; row < rows; row++) {
      float x = points[0][row].x + 250;
      float y = points[0][row].y + 250;

      for(int col=1; col < cols; col++) {
        float val = 0;
        fill(colors.get(col-1), 100);
        if (col==1) {
          val = mappedVal(values[col][row]/100);
          ellipse(x, y, val, val);
          // ellipse(x, y, val*3, val);
        }
        else {
          val = mappedVal(values[col][row]);
          ellipse(x+random(-10,10), y+random(0,10), val, val);
          // ellipse(x+random(-10,10), y+random(0,10), val*3, val);
        }
      }
      fill(200);
      text(loc[row],x,y + 100);
    }
  }
}

float mappedVal(float val) {
  return map2(val, 0, 1000, 0, highY, easY, 2);
  // return map2(val, 0, highY, 0, highY, easY, 2);
}
