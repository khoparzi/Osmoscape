void readData() {
  data = readCSV("../../data/2018/2a_water_access_based_on_income.csv", -2);
  DataTable data2 = readCSV("../../data/2018/4_GDP_water_access_to_improved_source.csv", -3);
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
    int step = maxWidth / cols;

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
        Vec2D point = new Vec2D(step * (col+1), mappedVal(values[col][row]));
        points[col][row] = point;

        float rad = mappedVal(values[col][row], true);
        float waterVal = waterRow.getFloat(col+1);
        float percent = rad * (waterVal/100);
        // The population circle
        stroke(colors.get(row)); noFill();
        ellipse(point.x,point.y,rad,rad);
        // The water circle
        fill(colors.get(row), 50); noStroke();
        ellipse(point.x,point.y, percent, percent);
        fill(255);
      }
    }

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

float mappedVal(float input) {
  return map2(input, 0, maxVal,
    height - margin, // The lowest point
    margin + highY, // The highest point
    easY, 2);
}

float mappedVal(float input, boolean rad) {
  return map2(input, 0, maxVal,
    0, // The smallest point
    pointSize, // The largest point
    easR, 2);
}
