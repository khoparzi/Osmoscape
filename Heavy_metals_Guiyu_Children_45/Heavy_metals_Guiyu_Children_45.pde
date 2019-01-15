void readData() {
  data = readCSV("../../data/2018/45_Heavy_metals_Guiyu_Children.csv", -2);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    points = new Vec2D[rows][cols];
    values = new float[rows][cols];
    labels = new String[rows];
    colors = tools.colorSpectrum(rows,0.6,0.9);
    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();
      int x = 0, y = 0;
      for (int col=0; col < cols; col++) {
        if (col==0)
          labels[row] = rowData.getString(col);
        else {
          x = (col%2==1) ? 0 : 500;
          y = (col%2==1) ? 0 : 500;
          y += (col<5) ? 0 : 1000;
          values[row][col] = rowData.getFloat(col);

          points[row][col] = new Vec2D(x, (col/2) * 500 - y);
        }
      }
    }
  }
}

void render() {
  background(50); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line
  noStroke();
  ellipseMode(CENTER);

  /* Write your drawing code here */
  if (data != null) {
    for (int row=0; row < rows; row++) {
      // Make legend
      fill(colors.get(row)); noStroke();
      ellipse(margin, (row*20) + 100, 10, 10);
      fill(200);
      text(labels[row], margin + 20, (row*20) + 100);

      for(int col=1; col < cols; col++) {
        float x = points[row][col].x + highY + random(10);
        float y = points[row][col].y + 200;
        noFill();
        float val = mappedVal(values[row][col]);
        if (col<5) stroke(colors.get(row));
        else stroke(colors.get(row), 100);
        ellipse(x, y, val, val);

        fill(200);
        if (row==0&&col<5)
          text(data.getSeriesLabel(col), x, y);
      }
    }
  }
}

float mappedVal(float val) {
  return map2(val, 0, 40, 0, highY, 0, 2);
}
