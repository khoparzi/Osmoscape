int maxVal = 6000;
void readData() {
  data = readCSV("../../data/2018/56_Plastic_in_rivers_global.csv", -2);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    points = new Vec2D[rows][cols-2];
    values = new float[rows][cols-2];
    colors = tools.colorSpectrum(cols-2,0.6,0.9);
    labels = new String[rows];
    labels = data.get(0).asStringArray();
    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();
      for (int col=2; col < cols; col++) {
        values[row][col-2] = rowData.getFloat(col);
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

  /* Write your drawing code here */
  if (data != null) {
    int x = margin;
    for (int row=0; row < rows; row++) {
      x += (row>0) ? pointSize + gap : 0;
      fill(200);
      text(labels[row], x, height-10);
      for(int col=0; col < cols-2; col++) {
        x += pointSize * col;
        fill(colors.get(col));
        rect(x, fromOrigin(), pointSize, -mappedVal(values[row][col]));
      }
    }

    // Make legend
    fill(200); text("Total catchment surface area (Km^2)",margin + 20, 100);
    fill(colors.get(0)); ellipse(margin, 100, 10, 10);
    fill(200); text("Yearly average discharge (m^3 per second)",margin + 20, 140);
    fill(colors.get(1)); ellipse(margin, 140, 10, 10);

    // Make markers
    textAlign(RIGHT, CENTER);
    for (int i=0; i < 20; i+=1) {
      float markVal = lerp(0, maxVal, i * 0.05);
      fill(0); noStroke();
      ellipse(width - margin, fromOrigin(mappedVal(markVal)), 5, 5);
      fill(255);
      text(floor(markVal), width - margin - 10, fromOrigin(mappedVal(markVal)));
    }
    fill(0); noStroke();
    ellipse(width - margin, fromOrigin(mappedVal(maxVal)), 5, 5);
    fill(255);
    text(maxVal, width - margin - 10, fromOrigin(mappedVal(maxVal)));
  }
}

float mappedVal(float val) {
  return map2(val, 0, maxVal, 0, highY, easY, 2);
}
