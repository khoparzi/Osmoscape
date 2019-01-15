void readData() {
  data = readCSV("../../data/2018/54_Plastic_in_Bottles.csv", -2);
  if (data != null) {
    println(data);
    rows = data.length();
    cols = data.seriesCount() - 1;
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
    colors = tools.colorSpectrum(cols,0.6,0.9);

    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();
      for (int col=1; col <= cols; col++) {
        values[col-1][row] = rowData.getFloat(col);
        if (col==1)
          points[0][row] = new Vec2D(((row)%4) * 240, ((row)/4) * 140);
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
      rect(width - margin - 10, (col*20) + 850, 10, 10);
      fill(200);
      // text(markers[row], width - 40, (row*20) + 850);
      text(data.getSeriesLabel(col+1), width - 40, (col*20) + 850);
    }
    textAlign(CENTER,CENTER);
    for (int row=0; row < rows; row++) {
      for(int col=0; col < cols; col++) {
        float x = points[0][row].x + 100;
        float y = points[0][row].y + 100;
        fill(colors.get(col), 50); noStroke();
        float val = mappedVal(values[col][row]); float valCount = val;

        if (col==cols-1) {
          // rect(x+random(-50,50), y+random(0,50), val, val);
          valCount = val / 100;
        }

        // Make a point cloud of mondrian boxes
        float pointCount = 0;
        while (pointCount < valCount) {
          //ellipse(x + ((pointCount % 20) * 10), y+((pointCount/20)*10), 6, 6);
          float sizer = ((pointCount % 10)) + 6;
          if (col==cols-1) {
            makeTri(x + (randomGaussian() * (val/100)), y + (randomGaussian() * (val/100)), sizer*4);
          } else {
            ellipse(
              // x + ((pointCount % 20) * 10), y + ((pointCount / 20) * 10) - 50,
              // x + (randomGaussian() * (val/8)), y + (randomGaussian() * (val/8)),
              x + (randomGaussian() * (val/8)), y + (randomGaussian() * (val/8)),
              sizer, sizer
            );
          }
          pointCount++;
        }

        // text(values[col][row], x, y + 20);
        fill(200);
        if (col == cols - 1)
          text(markers[row], x, y + 20, 100, 70);
      }
    }
  }
}

float mappedVal(float val) {
  // return map2(val, 0, 10400, 0, highY, easY, 2);
  return map2(val, 0, 2300, 0, highY, easY, 2);
}

void makeTri(float x, float y, float size) {
  float x1 = x;
  float y1 = y - (size/2);
  float x2 = x + (size/2);
  float y2 = y + (size/2);
  float x3 = x - (size/2);
  float y3 = y + (size/2);
  // fill(255);
  triangle(x1,y1,x2,y2,x3,y3);
}
