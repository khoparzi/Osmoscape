void readData() {
  data = readCSV("../../data/2018/21_Global_Cotton_Production (2012-2016).csv", -1);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount() - 1;
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
    colors = tools.colorSpectrum(rows,0.6,0.9);
  }
}

void render() {
  background(50); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line
  textAlign(LEFT, CENTER); ellipseMode(CENTER);

  /* Write your drawing code here */
  if (data != null) {
    // Draw legend
    int lRow = 1;
    for (DataRow rowData : data) {
      fill(colors.get(lRow-1)); noStroke();
      ellipse(margin, 100 + (lRow * 20), 10, 10);
      fill(200);
      text(rowData.getString(0), margin + 20, 100 + (lRow * 20));
      lRow++;
    }

    textAlign(CENTER, CENTER);
    int xStep = (width - margin) / cols;
    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();
      for (int col=1; col <= cols; col++) {
        int x = ((col-1) * (xStep + gap)) + margin + pointSize;
        // Draw years
        if (row==0) {
          fill(200);
          text(data.getSeriesLabel(col), x + margin + pointSize, height - 50);
        }

        float val = mappedVal(rowData.getFloat(col));
        fill(colors.get(row));
        ellipse(x + margin + pointSize, 100 + ((row+1) * pointSize), val, val);
      }
    }
  }
}

float mappedVal(float val) {
  return map(val, 0, maxVal, 0, pointSize);
}
