// int[] selec = {0, -2};
void readData() {
  data = readCSV("../../data/2018/17_Aral_sea_river_dynamics.csv", -2);
  println(data);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    points = new Vec2D[rows][cols-1];
    colors = tools.colorSpectrum(rows,0.6,0.9);
  }
}

void render() {
  background(50); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line
  textAlign(LEFT, CENTER);

  /* Write your drawing code here */
  if (data != null) {
    // Draw legend
    int lRow = 1;
    for (DataRow rowData : data) {
      fill(colors.get(lRow-1)); noStroke();
      ellipse(margin, 100 + (lRow * 20), 10, 10);
      fill(200);
      text(rowData.getString(0), margin + 20, 97 + (lRow * 20));
      lRow++;
    }

    // Draw years
    for (int col=1; col < cols; col++) {
      int x = ((col-1) * (pointSize + gap)) + margin;
      pushMatrix();
      rotate(radians(-90));
      translate(-800,0);
      text(data.getSeriesLabel(col), -200, x + margin);
      popMatrix();
    }

    noFill();
    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();
      stroke(colors.get(row));
      for (int col=1; col < cols; col++) {
        float x = ((col-1) * (pointSize + gap)) + margin;
        points[row][col-1] = new Vec2D(x, mappedVal(rowData.getFloat(col)));
      }

      Spline2D spline=new Spline2D(points[row],null,tight);
      LineStrip2D vertices = spline.toLineStrip2D(32);
      // draw the smoothened curve
      beginShape();
      for(Vec2D v : vertices) {
        vertex(v.x,v.y);
      }
      endShape();
    }

    // line(margin, fromOrigin(highY), width - margin, fromOrigin(highY));
  }
}

float mappedVal(float val) {
  return fromOrigin(map(val, -30, 60, 0, highY));
}
