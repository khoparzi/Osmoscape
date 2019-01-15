void readData() {
  data = readCSV("../../data/2018/14_Ice_core_carbon_emission_data.csv", -2);
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
    beginShape(); int xCount = 0;
    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();
      // int x = (row * (pointSize + gap)) + margin;
      if (row % xSkip == 0) {
        int x = (xCount * (pointSize + gap)) + margin;
        vertex(x, mappedVal(rowData.getFloat(1)));
        pushMatrix();
        rotate(radians(-90));
        translate(-800,0);
        text(rowData.getString(0), -200, x + margin);
        popMatrix();
        xCount++;
      }
    }
    endShape();

    line(margin, fromOrigin(highY), width - margin, fromOrigin(highY));
    text(400, width - margin, highY);
  }
}

float mappedVal(float val) {
  return fromOrigin(map(val, 0, 400, 0, highY));
}
