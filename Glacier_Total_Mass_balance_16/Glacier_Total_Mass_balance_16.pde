void readData() {
  data = readCSV("../../data/2018/16_Glacier_Total_Mass_balance.csv", -2);
  println(data);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
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
  textAlign(LEFT, CENTER);

  /* Write your drawing code here */
  if (data != null) {
    int lRow = 1;
    for (DataRow rowData : data) {
      fill(colors.get(lRow-1)); noStroke();
      ellipse(margin, 100 + (lRow * 20), 10, 10);
      fill(200);
      text(rowData.getString(0), margin + 20, 97 + (lRow * 20));
      lRow++;
    }

    for (int col=1; col < cols; col++) {
      int x = ((col-1) * (pointSize + gap)) + margin;
      pushMatrix();
      rotate(radians(-90));
      translate(-800,0);
      text(data.getSeriesLabel(col), -200, x + margin);
      popMatrix();
    }

    noFill();
    for (DataRow row : data) {
      stroke(colors.get(row.getRowIndex()));
      beginShape();
      for (int col=1; col < cols; col++) {
        int x = ((col-1) * (pointSize + gap)) + margin;
        vertex(x, mappedVal(row.getFloat(col)));
      }
      endShape();
    }

    // line(margin, fromOrigin(highY), width - margin, fromOrigin(highY));
  }
}

float mappedVal(float val) {
  return fromOrigin(map(val, -40, 0, 0, highY));
}
