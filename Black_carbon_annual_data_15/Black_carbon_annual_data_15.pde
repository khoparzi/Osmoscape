int[] selec = {1, -2}; // Select columns to read
void readData() {
  data = readCSV("../../data/2018/15_black_carbon_dataset.csv", selec);
  println(data);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
  }
}

void render() {
  background(50); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line
  stroke(200); noFill();

  /* Write your drawing code here */
  if (data != null) {
    int colNum = 0;
    beginShape();
    for (String label : data.getSeriesLabels()) {
      DataSeries col = data.get(label);
      int x = (colNum * (pointSize + gap)) + margin;
      vertex(x, mappedVal(col.getFloat(0)));
      pushMatrix();
      rotate(radians(-90));
      translate(-800,0);
      text(label, -200, x + margin);
      popMatrix();
      colNum++;
    }
    endShape();

    line(margin, fromOrigin(highY), width - margin, fromOrigin(highY));
  }
}

float mappedVal(float val) {
  return fromOrigin(map(val, 0, 10, 0, highY));
}
