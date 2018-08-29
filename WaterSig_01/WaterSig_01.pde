void readData() {
  data = readCSV("../../data/2018/1_water_in_space.csv", -2);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
    colors = tools.colorSpectrum(cols,0.6,0.9);
  }
}

void render() {
  // makeGrid();
  background(200); // To clear BG before next render
  ellipseMode(CENTER);
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line

  /* Write your drawing code here */
  stroke(200); strokeWeight(2); noFill();
  textAlign(RIGHT);
  sector = (TWO_PI - gap)/rows;

  for (int col=1; col < cols; col++) {
    stroke(colors.get(col-1));
    if (data.get(col).isNumeric()) {
      float[] column = data.get(col).asFloatArray();
      // println(column);
      for(int row=0; row < rows; row++) {
        float val = map(int(column[row]), 3200, 3600, lowY, highY);
        // int val = int(column[row]);
        points[col][row] = new Vec2D(val, row * sector)
          .toCartesian().add(width/2,height/2);

        // text(column[row], col * 80, fromOrigin(row * 20));
      }
    } else println(data.get(col));

    Spline2D spline=new Spline2D(points[col],null,tight);

    // sample the curve at a higher resolution
    // so that we get extra points between each original pair of points
    LineStrip2D vertices = spline.toLineStrip2D(32);

    // Make labels
    fill(colors.get(col-1)); textAlign(RIGHT);
    ellipse(width - margin - pointSize, margin + (col * 50), pointSize/2, pointSize/2);
    text(data.getSeriesLabel(col), width-margin - pointSize - 20, margin + (col * 50));

    // draw the smoothened curve
    noFill();
    beginShape();
    for(Vec2D v : vertices) {
      vertex(v.x,v.y);
    }
    endShape();


  // Marker
  stroke(255, 50, 50); strokeWeight(0.4);
  Vec2D lowMark = new Vec2D(highY - 200, highRow * sector).toCartesian().add(width/2,height/2);
  Vec2D highMark = new Vec2D(highY, highRow * sector).toCartesian().add(width/2,height/2);
  line(lowMark.x,lowMark.y,highMark.x,highMark.y);
}
