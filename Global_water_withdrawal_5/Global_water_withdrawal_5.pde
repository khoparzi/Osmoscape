void readData() {
  data = readCSV("../../data/2018/5_global_water_withdrawal.csv", -2);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
    colors = tools.colorSpectrum(cols,0.6,0.9);
  }
}

void render() {
  background(50); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line

  /* Write your drawing code here */
  pushMatrix();
  translate(margin, margin);

  if (data != null) {
    for(String label : data.getSeriesLabels()) {
      if (label.equals("Year")) continue;
      DataSeries column = data.get(label);
      if (column.isNumeric()) {
        if (!label.equals("1900")) translate(columnWidth + gap, 0);
        // Year label
        fill(255);
        text(label,0,fromOrigin(50));

        int numRuns = 0;
        for (int row=0; row < rows; row+=2) {
          if (row==0) translate(0,0);
          else {
            translate(0, highY + yGap); numRuns++;
          }

          float val2 = 0;
          if (row < rows - 1)
            val2 = column.getFloat(row+1);

          drawColumn(column.getFloat(row), val2);
          fill(255);
          text(column.getFloat(row), 0, highY + 20);
          fill(150, 0, 0);
          text(val2, columnWidth, highY + 40);
        }
        translate(0, -((highY + yGap) * numRuns));
      }
    }
  }

  popMatrix();
}

void drawColumn(float val1, float val2) {
  float valp1 = map2(val1, 0, 3130, 0, highY, eas, 2);
  float valp2 = map2(val2, 0, 3130, 0, highY, eas, 2);

  // Left line
  stroke(200); strokeWeight(0.5);
  line(0, 0, 0, highY);

  fill(200, 120); noStroke();
  // Triangle 1
  beginShape();
  vertex(0, (highY*0.5) + 10);
  vertex(columnWidth, 0);
  vertex(columnWidth, valp1);
  // text(valp1,columnWidth,valp1);
  endShape();

  fill(150, 0, 0, 200); noStroke();
  // Triangle 2
  beginShape();
  vertex(0, (highY*0.5) - 10);
  vertex(columnWidth, 0);
  vertex(columnWidth, valp2);
  // text(valp2,columnWidth,valp2);
  endShape();

  // Right line
  stroke(200); strokeWeight(0.5);
  line(columnWidth, 0, columnWidth, highY);
}
