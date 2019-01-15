void readData() {
  data = readCSV("../../data/2018/52_Xenoestrogen_in_Sperm.csv", -2);
  if (data != null) {
    println(data);
    rows = data.length();
    cols = data.seriesCount();
    points = new Vec2D[rows][cols];
    values = new float[rows][cols];
    colors = tools.colorSpectrum(rows,0.6,0.9);
    labels = data.get(0).asStringArray();

    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();
      int maxVal = 30;
      for (int col=1; col < cols; col++) {
        values[row][col] = map(
          rowData.getFloat(col), 0, maxVal, 0, highY);
      }
    }
  }
}

void render() {
  background(50); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line
  ellipseMode(CENTER);

  /* Write your drawing code here */
  if (data != null) {
    // Make legend
    noStroke(); textAlign(LEFT, CENTER);
    for (int l=0; l < labels.length; l++) {
      fill(colors.get(l));
      ellipse(margin + 10, (l*40) + 100, 20, 20);
      fill(0);
      text(labels[l], margin + 30, (l*40) + 100);
    }

    for (int row=0; row < rows; row++) {

      for(int col=1; col < cols; col++) {
        points[row][col] = new Vec2D((col * gap) - ((col % 4) * gap) + 200, (col%4) * (highY + yGap) + 150);
        fill(colors.get(row), 50);// noFill();
        ellipse(
          points[row][col].x+random(-10,10), points[row][col].y+random(0,10),
          values[row][col], values[row][col]
        );

        if (row<1) {
          fill(200);
          text(data.getSeriesLabel(col), points[row][col].x, points[row][col].y + 100);
          text(data.get(col).getInt(0), points[row][col].x, points[row][col].y); // Sample size
        }
      }
    }
  }
}
