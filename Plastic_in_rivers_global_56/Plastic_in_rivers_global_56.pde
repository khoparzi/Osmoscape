int maxVal = 6000;
void readData() {
  data = readCSV("../../data/2018/56_Plastic_in_rivers_global.csv", -2);
  if (data != null) {
    println(data);
    rows = data.length();
    cols = data.seriesCount() - 2;
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
    colors = tools.colorSpectrum(cols,0.6,0.9);

    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();
      for (int col=0; col < cols; col++) {
        values[col][row] = rowData.getFloat(col+2);
        // if (row==0)
          points[0][row] = new Vec2D(((row+1)/4) * 200, ((row+1)%4) * 250);
      }
    }
  }
}

void render() {
  background(50); // To clear BG before next render
  // makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line
  noStroke(); rectMode(CENTER);

  /* Write your drawing code here */
  if (data != null) {
    textAlign(RIGHT, CENTER);
    String[] markers = data.get(0).asStringArray();
    for (int col=0; col < cols; col++) {
      // Make legend
      fill(colors.get(col), 100); noStroke();
      rect(width - margin, (col*20) + 50, 10, 10);
      fill(200);
      // text(markers[row], width - 40, (row*20) + 50);
      text(data.getSeriesLabel(col+2), width - 40, (col*20) + 50);
    }
    textAlign(CENTER,CENTER);
    for (int row=0; row < rows; row++) {
      for(int col=0; col < cols; col++) {
        float x = points[0][row].x + 100;
        float y = points[0][row].y + 100;
        fill(colors.get(col), 50); noStroke();
        float val = mappedVal(values[col][row]);
        // Random offsets for the mondrian boxes
        float xOffset = random(-(val/2),val/2);
        float yOffset = random(0,val/2);

        // Make normal mondrian boxes
        // rect(x+xOffset, y+yOffset, val, val);

        // Make a point cloud of mondrian boxes
        float pointCount = 0;
        fill(colors.get(col), 100);
        while (pointCount < val) {
          //ellipse(x + ((pointCount % 20) * 10), y+((pointCount/20)*10), 6, 6);
          float sizer = ((pointCount % 10)) + 6;
          ellipse(
            // x + ((pointCount % 20) * 10), y + ((pointCount / 20) * 10) - 50,
            x + (randomGaussian() * (val/4)), y + (randomGaussian()* (val/4)),
            sizer, sizer
          );
          pointCount++;
        }

        // text(values[col][row], x, y + 20);
        fill(200);
        // if (row == rows - 1)
          text(markers[row], x, y + 20);
      }
    }
  }
}

float mappedVal(float val) {
  return map2(val, 0, maxVal, 0, highY, easY, 2);
}
