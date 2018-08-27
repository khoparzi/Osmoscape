int[] selec = {31, -3};

void readData() {
  data = readCSV("../../data/2018/2a_water_access_based_on_income.csv", -2);
  DataTable data2 = readCSV("../../data/2018/2c_Population_income_relation.csv", selec);
  popData = scaledCSV(data2, "divided");
  if (data != null) {
    rows = popData.length();
    cols = popData.seriesCount();
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
    colors = tools.colorSpectrum(rows,0.5,0.6);
    for (DataRow rowData : popData) {
      int row = rowData.getRowIndex();
      for(int col=0; col < cols - 1; col++) {
        values[col][row] = rowData.getFloat(col+1);
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
    fill(255);
    text(rows, width/2, margin+24);
    int maxWidth = width - margin;
    int step = maxWidth / cols;
    // Drawing the population circles
    for (int row=0; row < rows; row++) {
      fill(colors.get(row)); noStroke();
      for(int col=0; col < 26; col++) {
        Vec2D point = new Vec2D(step * (col+1), mappedVal(values[col][row]));
        points[col][row] = point;

        ellipse(point.x,point.y,pointSize,pointSize);
      }
    }
  }
}

float mappedVal(float input) {
  return map2(input, 0, 5500,
    height - margin - pointSize, // The lowest point
    margin + pointSize, // The highest point
    eas, 2);
}
