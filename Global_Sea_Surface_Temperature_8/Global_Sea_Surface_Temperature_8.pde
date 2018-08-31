// int[] selec = {0, -2, 1};
float highR = height/2;

void readData() {
  data = readCSV("../../data/2018/8_Global_SST_NEW.csv", -2);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    labels = new String[rows];
    colors = tools.colorSpectrum(rows,0.6,0.9);
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

      // Make legend
      labels[row] = rowData.getString(0);
      int y = (row > 0) ? row * 20 : 0;
      fill(200); noStroke();
      text(labels[row], margin + 20, y + margin * 3);
      fill(currentColor);
      ellipse(margin, y + margin * 3, 10, 10);

      for (int col=1; col < cols; col++) {
        drawColumn(col, mappedVal(rowData.getFloat(col)));
      }
    }

    // Make year markers
    int num = 0; fill(255);
    pushMatrix();
    rotate(radians(-90));
    translate(-800,0);
    for (String year : data.getSeriesLabels()) {
      int x = margin + ((gap + pointSize) * (num - 1));
      if (num % 10 == 1) text(year, -205, x);
      num++;
    }
    popMatrix();

    // Make markers
    textAlign(RIGHT, CENTER);
    for (int i=0; i < 20; i+=1) {
      float markVal = lerp(-1, 1, i * 0.05);
      fill(0); noStroke();
      ellipse(width - margin, mappedVal(markVal), 5, 5);
      fill(255);
      text(markVal, width - margin - 10, mappedVal(markVal));
    }
    fill(0); noStroke();
    ellipse(width - margin, mappedVal(1), 5, 5);
    fill(255);
    text(1, width - margin - 10, mappedVal(1));
  }
}

float mappedVal(float val) {
  return map2(val, -1, 1, height - margin, margin, easY, 2);
}

void drawColumn(int index, float y) {
  // If its the first one there should be no gap
  int x = margin + ((gap + pointSize) * (index - 1));

  int levels = (y < height/2) ? -int(y-(height/2)) / yGap : int(y-(height/2))/yGap;

  float jit = randomGaussian();

  // Final line
  strokeWeight(1);
  stroke(currentColor);
  line(
    x, int(y + jit),
    x + pointSize, int(y + jit)
    );
  strokeWeight(0.6);
  // stroke(60);
  for (int level=0; level < levels; level++) {
    int sy = (y > height/2) ? (yGap * level) + height/2 : (yGap * level) + int(y) + yGap;
    line(
      x, sy + jit,
      x + pointSize, sy + jit
    );
  }
}
