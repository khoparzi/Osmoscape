float maxVal = 0;
float level2, level3;

void readData() {
  data = readCSV("../../data/2018/10_Global_increase_in_severe_category_storms.csv", -2);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
    colors = tools.colorSpectrum(rows,0.6,0.9);
    for (int col=0; col < cols; col++) {
      if (data.get(col).isNumeric()) {
        float max = data.get(col).max().getFloat();
        if (maxVal < max) maxVal = max;
      }
    }
  }
}

void render() {
  background(50); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line

  /* Write your drawing code here */
  if (data != null) {
    textAlign(LEFT, CENTER); ellipseMode(CENTER);
    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();

      // Make legend
      fill(colors.get(row)); noStroke();
      ellipse(margin + 20, 100 + margin + (row * 20), 10, 10);
      fill(200);
      text(rowData.getString(0), margin + 40, 100 + margin + (row * 20));

      stroke(colors.get(row)); noFill();
      // draw the points
      for (int col=1; col < cols; col++) {
        float val = rowData.getFloat(col);
        if (!Float.isNaN(val) && val > 0)
          drawPoint(col, val);
      }
    }

    // Make year markers
    fill(200); int num = 0;
    for (String label : data.getSeriesLabels()) {
      // int x = (num > 0) ? (num - 1) * pointSize : 0;
      int x = ((gap + pointSize) * (num-1));
      if (num>0) text(label, x + margin, fromOrigin() + 10);
      num++;
    }
  }
}

void drawPoint(int index, float val) {
  // draw
  int x = margin + ((gap + pointSize) * (index - 1));
  float y = map(val, 0, maxVal, 0, highY);
  // int x = (index > 0) ? (index - 1) * gap : 0;
  ellipse(x, fromOrigin(y), 10, 10);
  if (val > level2)
    ellipse(x, fromOrigin(y), 20, 20);
  if (val > level3)
    ellipse(x, fromOrigin(y), 30, 30);
}
