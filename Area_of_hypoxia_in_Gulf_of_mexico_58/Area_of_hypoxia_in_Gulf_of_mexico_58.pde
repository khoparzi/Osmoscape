int[] selec = {1, -1};
void readData() {
  data = readCSV("../../data/2018/58_Area_of_hypoxia_in_Gulf_of_mexico.csv", selec);
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
  ellipseMode(CENTER);

  /* Write your drawing code here */
  if (data != null) {
    fill(200, 100); noStroke();
    for (int col=0; col < cols; col++) {
      String label = data.getSeriesLabel(col);
      int x = (col * (gap)) + margin;
      // vertex(x, mappedVal(col.getFloat(0)));
      values[col][0] = data.get(col).getFloat(0);
      float rad = mappedValR(values[col][0]);
      points[col][0] = new Vec2D(x, mappedVal(values[col][0]));
      ellipse(x, points[col][0].y, rad, rad);
      pushMatrix();
      rotate(radians(-90));
      translate(-800,0);
      text(label, -200, x + margin);
      popMatrix();
    }

    stroke(200); noFill();
    line(margin, fromOrigin(highY), width - margin, fromOrigin(highY));
    beginShape();
    for (int row=0; row < cols; row++) {
      vertex(points[row][0].x, points[row][0].y);
    }
    endShape();
  }
}

float mappedVal(float val) {
  return fromOrigin(map(val, 0, 9000, 0, highY));
}

float mappedValR(float val) {
  return map(val, 0, 9000, 0, pointSize);
}
