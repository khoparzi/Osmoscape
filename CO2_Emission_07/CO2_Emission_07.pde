int[] selec = {0, -2, 1};
float maxVal = 0;

void readData() {
  data = readCSV("../../data/2018/7_CO2_emissions_1850_to_2012.csv", selec);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    labels = new String[rows];
    // cp5.getController("pointSize").setValue((width - (margin*2)) / cols);
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
  background(100); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line
  ellipseMode(CENTER); textAlign(LEFT, CENTER);

  /* Write your drawing code here */
  if (data != null) {
    int row = 0;
    // Reading code
    for (DataRow rowData : data) {
      row = rowData.getRowIndex();

      currentColor = colors.get(row);

      // Make country legend
      labels[row] = rowData.getString("Country");
      int y = (row > 0) ? row * 20 : 0;
      fill(200);
      text(labels[row], margin + 20, y + margin * 3);
      fill(currentColor);
      ellipse(margin, y + margin * 3, 10, 10);

      for (int col=2; col < cols; col++) {
        float val = map2(rowData.getFloat(col),
          0, maxVal, 0, highY, easY, 2);
        drawColumn(col, val);
      }
    }

    // Make year markers
    int num = 0;
    pushMatrix();
    rotate(radians(-90));
    translate(-800,0);
    for (String year : data.getSeriesLabels()) {
      int x = (num > 1) ? (num * (pointSize + gap)) + 5 : 0;
      if (num > 1 && num % 10 == 0) text(year, -205, x);
      num++;
    }
    popMatrix();

    // Make markers
    textAlign(RIGHT, CENTER);
    for (int i=0; i < 20; i+=1) {
      float markVal = lerp(0, maxVal, i * 0.05);
      fill(0); noStroke();
      ellipse(width - margin, mappedVal(markVal), 5, 5);
      fill(255);
      text(floor(markVal), width - margin - 10, mappedVal(markVal));
    }
    fill(0); noStroke();
    ellipse(width - margin, mappedVal(maxVal), 5, 5);
    fill(255);
    text(maxVal, width - margin - 10, mappedVal(maxVal));
  }
}

float mappedVal(float val) {
  return map2(val, 0, maxVal, fromOrigin(), fromOrigin((int)highY), easY, 2);
}

void drawColumn(int index, float y) {
  // If its the first one there should be no gap
  int x = (index > 1) ? index * (pointSize + gap) : 0;

  int levels = int(y) / yGap;

  float jit = randomGaussian();

  // Final line
  strokeWeight(1);
  stroke(currentColor);
  line(
    x, fromOrigin(int(y + jit)),
    x + pointSize, fromOrigin(int(y + jit))
    );

  strokeWeight(0.6);
  for (int level=0; level < levels; level++) {
    int sy = fromOrigin(yGap * level);
    line(
      x, sy + jit,
      x + pointSize, sy + jit
    );
  }
}
