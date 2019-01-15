void readData() {
  data = readCSV("../../data/2018/20_Water_use_for_Agriculture_DECIMAL.csv", -2);
  if (data != null) {
    println(data);
    rows = data.length();
    cols = data.seriesCount();
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
    colors = tools.colorSpectrum(cols,0.6,0.9);
    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();
      points[0][row] = new Vec2D(((row)%2) * 600, ((row)/2) * 250);
      for (int col=1; col < cols; col++) {
        values[col-1][row] = rowData.getFloat(col);
      }
    }
  }
}

void render() {
  background(50); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line
  rectMode(CENTER);

  /* Write your drawing code here */
  if (data != null) {
    textAlign(CENTER,CENTER); fill(200); noStroke();
    for (int col=1; col < cols; col++) {
      fill(200);
      text(data.getSeriesLabel(col), width*0.5, ((col-1)*100)+80, 150, 50);
      fill(colors.get(col), 100);
      ellipse(width*0.5, ((col-1)*100)+50, 20, 20);
    }

    String[] loc = data.get(0).asStringArray();
    for (int row=0; row < rows; row++) {
      float x = points[0][row].x + 150;
      float y = points[0][row].y + 200;

      for(int col=0; col < cols; col++) {
        float val = mappedVal(values[col][row]);
        fill(colors.get(col), 100);
        rect(x+random(-50,50), y+random(0,50), val*3, val);
      }
      fill(200);
      text(loc[row],x,y);
    }
  }
}

float mappedVal(float val) {
  return map2(val, 0, 70, 0, highY, easY, 2);
}
