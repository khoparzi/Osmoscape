float maxVal = 0;
float level2, level3;

void readData() {
  data = readCSV("../../data/2018/26_Dams_Gandhi_Sagar.csv", -2);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
    colors = tools.colorSpectrum(cols,0.6,0.9);
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
      int x = (row * (pointSize + gap)) + margin;
      pushMatrix();
      rotate(radians(-90));
      translate(-800,0);
      text(rowData.getString(0), -200, x);
      popMatrix();

      // draw the points
      for (int col=1; col < cols; col++) {
        float val = rowData.getFloat(col);
        stroke(colors.get(col-1)); noFill();
        if (!Float.isNaN(val) && val > 0)
          drawPoint(row, val);
      }
    }

    // Make legend
    fill(200); int num = 0;
    for (String label : data.getSeriesLabels()) {
      if (num>0) {
        fill(colors.get(num-1)); noStroke();
        ellipse(margin + 20, 100 + margin + (num * 20), 10, 10);
        fill(200);
        text(label, margin + 40, 100 + margin + (num * 20));
      }
      num++;
    }
  }
}

void drawPoint(int index, float val) {
  // draw
  int x = margin + ((gap + pointSize) * index);
  float y = map(val, 0, maxVal, 0, highY);
  ellipse(x, fromOrigin(y), 10, 10);
  if (val > level2)
    ellipse(x, fromOrigin(y), 20, 20);
  if (val > level3)
    ellipse(x, fromOrigin(y), 30, 30);
}
