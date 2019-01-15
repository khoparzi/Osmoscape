// int[] selec = {0, -2};
void readData() {
  data = readCSV("../../data/2018/23_depleting_ground_water_levels_Maharastra.csv", -2);
  println(data);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    points = new Vec2D[cols-1][rows];
    colors = tools.colorSpectrum(cols,0.6,0.9);

    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();
      for (int col=1; col < cols; col++) {
        float x = (row * (pointSize + gap)) + margin;
        points[col-1][row] = new Vec2D(x, mappedVal(rowData.getFloat(col)));
      }
    }
  }
}

void render() {
  background(50); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line
  textAlign(LEFT, CENTER); ellipseMode(CENTER);

  /* Write your drawing code here */
  if (data != null) {
    // Draw legend
    int lRow = 1;
    for (DataRow rowData : data) {
      int x = ((lRow-1) * (pointSize + gap)) + margin;
      pushMatrix();
      rotate(radians(-90));
      translate(-800,0);
      text(rowData.getString(0), -200, x + margin);
      popMatrix();
      lRow++;
    }

    // Draw years
    for (int col=1; col < cols; col++) {
      fill(colors.get(col-1)); noStroke();
      ellipse(margin, 100 + (col * 20), 10, 10);
      fill(200);
      text(data.getSeriesLabel(col), margin + 20, 97 + (col * 20));

      stroke(colors.get(col-1)); noFill();
      Spline2D spline=new Spline2D(points[col-1],null,tight);
      LineStrip2D vertices = spline.toLineStrip2D(32);
      // draw the smoothened curve
      beginShape();
      for(Vec2D v : vertices) {
        vertex(v.x,v.y);
      }
      endShape();
    }

    // Make markers
    textAlign(RIGHT, CENTER);
    for (int i=0; i < 20; i+=1) {
      float markVal = lerp(-5, 11, i * 0.05);
      fill(0); noStroke();
      ellipse(width - margin, mappedVal(markVal), 5, 5);
      fill(255);
      text(floor(markVal), width - margin - 10, mappedVal(markVal));
    }
    fill(0); noStroke();
    ellipse(width - margin, mappedVal(11), 5, 5);
    fill(255);
    text(11, width - margin - 10, mappedVal(11));
  }
}

float mappedVal(float val) {
  return fromOrigin(map(val, -5, 11, 0, highY));
}
