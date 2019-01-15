void readData() {
  data = readCSV("../../data/2018/22_Crop_Water_requirements.csv", -2);
  println(data);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
    colors = new int[3];
    colors[0] = color(0,200,0);
    colors[1] = color(120,150,235);
    colors[2] = color(100);
  }
}

void render() {
  background(50); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line
  ellipseMode(CENTER); textAlign(LEFT, CENTER);
  noStroke(); rectMode(CENTER);

  /* Write your drawing code here */
  if (data != null) {
    // Draw crop
    String[] crops = data.get(0).asStringArray();
    for (int row=0; row < rows; row++) {
      int x = (row * 100) + margin;
      pushMatrix();
      rotate(radians(-90));
      translate(-800,0);
      text(crops[row], -170, x + 5, 60, 38);
      popMatrix();
    }

    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();

      for (int col=1; col < cols - 1; col++) {
        int x = ((col-1) * (pointSize + gap)) + margin;
        x += (row * 100);
        float val = rowData.getFloat(col);

        if (val < 10) {
          fill(colors[col-1]); noStroke();
        } else {
          stroke(colors[col-1]); noFill();
        }

        ellipse(x, mappedVal(val), pointSize, pointSize);
        stroke(0);
        line(x,mappedVal(val) + (pointSize/2),x,fromOrigin());
      }
    }

    // Make markers
    textAlign(RIGHT, CENTER);
    for (int i=0; i < 20; i+=1) {
      float markVal = lerp(0, 4500, i * 0.05);
      fill(0); noStroke();
      ellipse(width - margin, mappedVal(markVal), 5, 5);
      fill(255);
      text(floor(markVal), width - margin - 10, mappedVal(markVal));
    }
    fill(0); noStroke();
    ellipse(width - margin, mappedVal(4500), 5, 5);
    fill(255);
    text(4500, width - margin - 10, mappedVal(4500));
  }
}

float mappedVal(float val) {
  return fromOrigin(map2(val, 0, 4500, 0, highY, easY, 2));
}
