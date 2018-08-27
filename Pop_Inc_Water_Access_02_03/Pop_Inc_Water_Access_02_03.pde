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
      // Get the water data for current row
      DataRow waterRow = data.getRow(row);

      for(int col=0; col < 26; col+=skips) {
        Vec2D point = new Vec2D(step * (col+1), mappedVal(values[col][row]));
        points[col][row] = point;

        float rad = mappedVal(values[col][row], true);
        float waterVal = waterRow.getFloat(col+1);
        float percent = rad * (waterVal/100);
        // The population circle
        stroke(colors.get(row)); noFill();
        ellipse(point.x,point.y,rad,rad);
        // The water circle
        fill(colors.get(row)); noStroke();
        ellipse(point.x,point.y, percent, percent);
        fill(255);
      }
    }
  }
}

float mappedVal(float input) {
  return map2(input, 0, 5500,
    height - margin,// - pointSize, // The lowest point
    margin + highY, // The highest point
    easY, 2);
}

float mappedVal(float input, boolean rad) {
  return map2(input, 0, 5500,
    0, // The smallest point
    pointSize, // The largest point
    easR, 2);
}
