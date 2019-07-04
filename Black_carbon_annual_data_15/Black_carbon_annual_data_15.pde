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

    // Make markers
    textAlign(RIGHT, CENTER);
    for (int i=0; i < 10; i+=1) {
      float markVal = lerp(0, maxVal, i * 0.1);
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

float mappedVal(float val) {
  return fromOrigin(map(val, 0, maxVal, 0, highY));
}
