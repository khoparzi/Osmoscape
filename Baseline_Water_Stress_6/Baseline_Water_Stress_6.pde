int[] colSel = {1, -3, 1};
void readData() {
  data = readCSV("../../data/2018/6_SHORTLISTED_Baseline_Water_Stress.csv", colSel);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    println(data);
    points = new Vec2D[cols-2][rows];
    values = new float[cols-2][rows];
    names = new String[rows]; labels = new String[4];
    colors = tools.colorSpectrum(cols - 2, 0.6, 0.9);
    int col = 0;
    for(String label : data.getSeriesLabels()) {
      DataSeries series = data.get(label);
      if (label.equals("River Basin")) {
        names = series.asStringArray();
      } else if (label.equals("2")) { continue; }
      else {
        values[col] = series.asFloatArray();
        labels[col] = label;
        col++;
      }
    }
  }
}

void render() {
  background(50); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line
  // Make labels
  for (int col=0; col < cols-2; col++) {
    fill(colors.get(col)); noStroke();
    ellipse(margin + 20, margin + (col*50) + 20, 20, 20);
    text(labels[col], margin + 70, margin + (col*50) + 20);
  }

  /* Write your drawing code here */
  if (data != null) {
    ellipseMode(CENTER);
    pushMatrix();
    translate(margin, margin + highY);
    for (int col=0; col < cols-2; col++) {
      for(int row=0; row < rows; row++) {
        float rad = map(values[col][row], 0, 5, 0, highY);
        translate(highY + gap, 0);
        stroke(20); strokeWeight(0.5); noFill();
        ellipse(0, 0, highY, highY);
        stroke(colors.get(col)); strokeWeight(1);
        // fill(colors.get(col), 100); noStroke();
        ellipse(randomGaussian(), randomGaussian(), rad, rad);
        fill(255);
        // text(row % 6,0,0);
        if (col==3) text(names[row], 0, 20);
        if ((row % 6)==5)
          translate((highY + gap) * -6, highY + yGap);
      }
      translate(0, (highY + yGap) * -5);
    }
    popMatrix();
  }
}
