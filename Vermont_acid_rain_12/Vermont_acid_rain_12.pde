void readData() {
  data = readCSV(
    "../../data/2018/"+
    "12_Vermont_acid_rain_AK_June_2019.csv", -2);
  println(data);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
    // colors = tools.colorSpectrum(cols,0.6,0.9);
  }
}

void render() {
  background(50); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line
  ellipseMode(CENTER); noStroke();

  // Make legend
  textAlign(LEFT);
  fill(120, 240, 230);
  ellipse(margin + 20, 200, 20, 20);
  fill(255); text(5.5, margin + 40, 200);

  fill(255, 220, 100);
  ellipse(margin + 20, 250, 20, 20);
  fill(255); text(5, margin + 40, 250);

  float five = mappedVal(5);
  float fivehalf = mappedVal(5.5);

  /* Write your drawing code here */
  if (data != null) {
    // text(maxVal, width/2, height/2);
    int lastX = margin;
    DataSeries col = data.get(1);
    for (int row=0; row < rows; row++) {
      int x = (row * (pointSize + gap)) + margin;
      fill(200); noStroke();
      ellipse(x, mappedVal(col.getFloat(row)), pointSize, pointSize);
      stroke(20);
      line(x,mappedVal(col.getFloat(row)) + 2.5,x,height - margin);
      lastX = x;
    }
    noFill(); stroke(255, 220, 100);
    line(margin, five, lastX, five);
    noFill(); stroke(120, 240, 230);
    line(margin, fivehalf, lastX, fivehalf);

    // Draw years
    pushMatrix();
    rotate(radians(-90));
    translate(-300,0);
    String[] ycol = data.get(0).asStringArray();
    for (int row=0; row < rows; row++) {
      int x = (row * (pointSize + gap)) + margin;
      text(ycol[row], -680, x);
    }
    popMatrix();

    // Make markers
    textAlign(RIGHT, CENTER);
    for (int i=0; i < 10; i+=1) {
      float markVal = lerp(0, 6.3, i * 0.1);
      fill(0); noStroke();
      ellipse(margin, mappedVal(markVal), 5, 5);
      fill(255);
      text(markVal, margin - 10, mappedVal(markVal));
    }
  }
}

float mappedVal(float val) {
  return fromOrigin(map(val, 0, 6.3, 0, highY));
}
