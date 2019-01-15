void readData() {
  data = readCSV("../../data/2018/59_Fukushima_Food_Radioactivity.csv", -2);
  if (data != null) {
    println(data);
    rows = data.length();
    cols = data.seriesCount() - 1;
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
    colors = tools.colorSpectrum(rows,0.6,0.9);

    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();
      for (int col=1; col <= cols; col++) {
        values[col-1][row] = rowData.getFloat(col);
        if (row==0)
          points[col-1][0] = new Vec2D(((col-1)%4) * 250, ((col-1)/4) * 250);
      }
    }
  }
}

void render() {
  background(50); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line
  noStroke(); rectMode(CENTER);

  /* Write your drawing code here */
  if (data != null) {
    textAlign(RIGHT, CENTER);
    String[] markers = data.get(0).asStringArray();
    for (int row=0; row < rows; row++) {
      // Make legend
      fill(colors.get(row), 100); noStroke();
      rect(width - margin, (row*20) + 850, 10, 10);
      fill(200);
      text(markers[row], width - 40, (row*20) + 850);
    }
    textAlign(CENTER,CENTER);
    for (int row=0; row < rows; row++) {
      for(int col=0; col < cols; col++) {
        float x = points[col][0].x + 100;
        float y = points[col][0].y + 100;
        fill(colors.get(row), 100); noStroke();
        float val = mappedVal(values[col][row]);
        rect(x+random(-50,50), y+random(0,50), val, val);
        // text(values[col][row], x, y + 20);
        fill(200);
        if (row == rows - 1)
          text(data.getSeriesLabel(col+1), x, y + 20);
      }
    }
  }
}

float mappedVal(float val) {
  return map2(val, 0, 75, 0, highY, easY, 2);
}
