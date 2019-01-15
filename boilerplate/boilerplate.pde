void readData() {
  // data = readCSV("../../data/2018/csv.csv", -2);
  if (data != null) {
    rows = data.length();
    cols = data.seriesCount();
    points = new Vec2D[cols][rows];
    values = new float[cols][rows];
    colors = tools.colorSpectrum(cols,0.6,0.9);
  }
}

void render() {
  background(50); // To clear BG before next render
  makeGrid();
  makeRegistrationMarks(); // If we want RegistrationMarks
  makeAxis(); // Make an axis line

  /* Write your drawing code here */
  if (data != null) {
    
  }
}
