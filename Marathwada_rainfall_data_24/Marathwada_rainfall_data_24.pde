void readData() {
  data = readCSV("../../data/2018/24_Marathwada_rainfall_data.csv", -2);
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
  ellipseMode(CENTER); textAlign(LEFT, CENTER);
  noStroke();

  /* Write your drawing code here */
  if (data != null) {
    // Draw legend
    int lRow = 1;
    for (DataRow rowData : data) {
      fill(colors.get(lRow-1)); noStroke();
      ellipse(margin, 60 + (lRow * 20), 10, 10);
      fill(200);
      text(rowData.getString(0), margin + 20, 57 + (lRow * 20));
      lRow++;
    }

    // Draw years
    for (int col=1; col < cols; col++) {
      int x = ((col-1) * (pointSize + gap)) + margin;
      pushMatrix();
      rotate(radians(-90));
      translate(-800,0);
      text(data.getSeriesLabel(col), -200, x);
      popMatrix();
      stroke(20);
      line(x,mappedVal(data.get(col).getFloat(rows - 1)) + 2.5,x, fromOrigin());
    }

    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();

      for (int col=1; col < cols; col++) {
        int x = ((col-1) * (pointSize + gap)) + margin;
        float val = rowData.getFloat(col);

        if (val < 10) {
          fill(colors.get(row)); noStroke();
        } else {
          stroke(colors.get(row)); noFill();
        }

        ellipse(x, mappedVal(val), pointSize, pointSize);
      }
    }

    noStroke();
    // Draw 10 year avg
    DataRow avgRow = data.getRow(rows - 1); float avgTot = 0;
    for (int col=1; col < cols; col++) {
      float val = avgRow.getFloat(col);
      if (col % 10 == 0) {
        int x = ((col-1) * (pointSize + gap)) + margin;
        float y = mappedVal(avgTot/10);
        stroke(0,200,0);
        line(x - 160, y, x, y);
        avgTot = 0;
      }
      avgTot = val + avgTot;
    }

    // Make markers
    textAlign(RIGHT, CENTER);
    for (int i=0; i < 20; i+=1) {
      float markVal = lerp(0, 15000, i * 0.05);
      fill(0); noStroke();
      ellipse(width - margin, mappedVal(markVal), 5, 5);
      fill(255);
      text(floor(markVal), width - margin - 10, mappedVal(markVal));
    }
    fill(0); noStroke();
    ellipse(width - margin, mappedVal(15000), 5, 5);
    fill(255);
    text(15000, width - margin - 10, mappedVal(15000));
  }
}

float mappedVal(float val) {
  return fromOrigin(map2(val, 0, 15000, 0, highY, easY, 2));
}
