int[] selec = {1, -2, 1};
void readData() {
  data = readCSV("../../data/2018/50_Antibiotic_resistant_bacteria_in_water.csv", selec);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    labels = new String[rows];
    // cp5.getController("pointSize").setValue((width - (margin*2)) / cols);
    colors = tools.colorSpectrum(cols-2,0.6,0.9);
  }
}

void render() {
  background(100); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line
  ellipseMode(CENTER);
  rectMode(CENTER);

  /* Write your drawing code here */
  if (data != null) {
    int row = 0; fill(200);
    // Reading code

    // Make legend
    int num = 0; noStroke(); textAlign(LEFT, CENTER);
    for (String name : data.getSeriesLabels()) {
      if (num > 1) {
        int y = (num > 2) ? (num-2) * 20 : 0;
        fill(200);
        text(name, margin + 20, y + margin * 3);
        fill(colors.get(num-2));
        ellipse(margin, y + (margin * 3), 10, 10);
      }
      num++;
    }

    fill(200); textAlign(LEFT, TOP);
    for (DataRow rowData : data) {
      row = rowData.getRowIndex();

      labels[row] = rowData.getString("Sewage dumping Source");
      int x = (row * (pointSize*10)) + margin;

      for (int col=2; col < cols; col++) {
        stroke(colors.get(col-2));
        float val = rowData.getFloat(col);
        if (val>0)
          drawColumn(row, col, mappedVal(val));
      }

      // X axis markers
      fill(200);
      text(labels[row], x + (pointSize*6), fromOrigin() + 10, pointSize*10, 80);
      stroke(0);
      line(x, fromOrigin(), x, fromOrigin(300));
    }

    // Make markers
    textAlign(RIGHT, CENTER);
    for (int i=0; i < 20; i+=1) {
      float markVal = lerp(0, 1, i * 0.05);
      fill(0); noStroke();
      ellipse(width - margin, fromOrigin(mappedVal(markVal)), 5, 5);
      fill(255);
      text(markVal, width - margin - 10, fromOrigin(mappedVal(markVal)));
    }
    fill(0); noStroke();
    ellipse(width - margin, fromOrigin(mappedVal(1)), 5, 5);
    fill(255);
    text(1, width - margin - 10, fromOrigin(mappedVal(1)));
  }
}

float mappedVal(float val) {
  return map2(val, 0, 1, 0, highY, easY, 2);
}

void drawColumn(int row, int col, float y) {
  col = col - 2;
  int x = (row * (pointSize*10));
  x += col * pointSize;
  x += margin + pointSize;

  int levels = int(y) / yGap;

  // Final line
  // strokeWeight(1);
  fill(colors.get(col)); noStroke();
  // line(
  //   x, fromOrigin(int(y)),
  //   x + pointSize, fromOrigin(int(y))
  //   );
  ellipse(x,fromOrigin(y),pointSize,pointSize);

  // stroke(colors.get(col)); noFill(); strokeWeight(0.6);
  for (int level=0; level < levels; level++) {
    int sy = fromOrigin(yGap * level);
    ellipse(x,sy,pointSize,pointSize);
    // line(
    //   x, sy,
    //   x + pointSize, sy
    // );
  }
}
