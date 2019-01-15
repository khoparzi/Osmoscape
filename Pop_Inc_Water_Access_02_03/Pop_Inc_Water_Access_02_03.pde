// Select columns to be read
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
    textSize(12);
    textAlign(LEFT);
    // Make labels
    for( DataRow row : data) {
      int num = row.getRowIndex();
      fill(colors.get(num)); noStroke();
      ellipse(margin + 20, num * 30 + (margin*2), 20, 20);
      text(row.getString(0), margin + 40, num * 30 + (margin*2));
    }

    int maxWidth = width - margin;
    int step = maxWidth / rows;

    fill(200);
    // Make year labels
    int labelNum = 0;
    for (String label : popData.getSeriesLabels()) {
      if (labelNum > 0) {
        // if we need to skip anything check if this row needs to be skipped
        if (skips > 1 && labelNum % skips == 1)
          text(label, (step * (labelNum - 1)) + 15, height - 15);
        // else make sure we don't need to skip
        else if (skips == 1)
          text(label, (step * (labelNum - 1)) + 15, height - 15);
      }
      labelNum++;
    }

    // Drawing the population circles
    for (int row=0; row < rows; row++) {
      // Get the water data for current row
      DataRow waterRow = data.getRow(row);

      for(int col=0; col < 26; col+=skips) {
        Vec2D point = new Vec2D((step * (row)) + margin, height*0.5);
        points[col][row] = point;

        float rad = mappedVal(values[col][row], true);
        float waterVal = waterRow.getFloat(col+1);
        float percent = rad * (waterVal/100);
        // The water circle
        stroke(colors.get(row), 50); noFill();
        ellipse(point.x,point.y, percent, percent);
        fill(255);
      }
    }
  }
}

float mappedVal(float input) {
  return map2(input, 0, 5500,
    height - margin, // The lowest point
    margin + highY, // The highest point
    easY, 2);
}

float mappedVal(float input, boolean rad) {
  return map2(input, 0, 5500,
    0, // The smallest point
    300, // The largest point
    easR, 2);
}
