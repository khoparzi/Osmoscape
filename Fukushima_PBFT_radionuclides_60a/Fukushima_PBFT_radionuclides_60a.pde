String[] labels = {"Cs-134",	"Cs-137",	"K-40",	"Po-210",	"Cs-134",	"Cs-137", "K-40", "Po-210"};
void readData() {
  data = readCSV("../../data/2018/60_Fukushima_PBFT_radionuclides.csv", -2);
  if (data != null) {
    println(data);
    rows = data.length();
    cols = data.seriesCount() - 1;
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
    colors = tools.colorSpectrum(rows,0.6,0.9);

    for (DataRow rowData : data) {
      int row = rowData.getRowIndex();
      for (int col=1; col <= cols; col++) {
        values[col-1][row] = rowData.getFloat(col);
        if (row==0)
          points[col-1][0] = new Vec2D(((col-1)%4) * 250, ((col-1)/4) * 400);
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
    for (int row=0; row < rows; row++) {
      // Make legend
      fill(colors.get(row), 100); noStroke();
      rect(width - margin, (row*20) + 850, 10, 10);
      fill(200);
      text(markers[row], width - 40, (row*20) + 850);
    }

    textAlign(CENTER,CENTER);
    for (int row=0; row < rows; row++) {
      for(int col=0; col < cols; col++) {
        float x = points[col][0].x + 100;
        float y = points[col][0].y + 200;
        fill(colors.get(row), 50); noStroke();
        float val = mappedVal(values[col][row]); float valCount = val;

        if ((col==3||col==7)&&(row==2)) {
          valCount = values[col][row] / 1000;
        }

        // if ((col==3||col==7)&&(row==2)) {
          float xOff = random(-50,50);
          float yOff = random(0,50);
          // rect(x+xOff, y+yOff, val/500, val/500);
          // fill(100);
          // text(val,x+xOff,y+yOff);

          // Make a point cloud of mondrian boxes
          float pointCount = 0;
          fill(colors.get(row), 100);

          while (pointCount < valCount) {
            //ellipse(x + ((pointCount % 20) * 10), y+((pointCount/20)*10), 6, 6);
            float sizer = ((pointCount % 10)) + 6;
            if ((col==3||col==7)&&(row==2)) {
              makeTri(x + (randomGaussian() * 50), y + (randomGaussian() * 50), sizer*4);
            } else {
              ellipse(
                // x + ((pointCount % 20) * 10), y + ((pointCount / 20) * 10) - 50,
                x + (randomGaussian() * (val/8)), y + (randomGaussian() * (val/8)),
                sizer, sizer
              );
            }
            pointCount++;
          }

          // text(values[col][row], x, y + (50*col));
          fill(200);
          if (row == rows - 1)
            text(labels[col], x, y + 20);
        // }

      }
    }
  }
}

float mappedVal(float val) {
  return map2(val, 0, 550, 0, highY, easY, 2);
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
