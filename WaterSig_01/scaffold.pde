import processing.svg.*;
import processing.pdf.*;
import geomerative.*;
// HiVis library for handling CSVs
import hivis.common.*;
import hivis.data.*;
import hivis.data.reader.*;
import hivis.data.view.*;
// Toxiclibs library for Polar to cartesian conversions
import toxi.math.*;
import toxi.geom.*;
// controlP5 for UI elements
import controlP5.*;
// For random colours
import java.awt.Color;
import dawesometoolkit.*;

/* Set the width and height of your screen canvas in pixels */
final int CONFIG_WIDTH_PIXELS = 1000;
final int CONFIG_HEIGHT_PIXELS = 1000;
final int REG_PIXELS = 50;

PFont f;
ControlP5 cp5;
boolean showUI = true;

DataTable data;
Vec2D[][] points;
float[][] values;
String[] labels;
DawesomeToolkit tools = new DawesomeToolkit(this);
ArrayList<Integer> colors; color currentColor;
int pointSize = 50;
float highY = 100, sector, tight = 0.24, lowY = 30;
int margin = 10;
float gap = 0.6;
int yGap = 5, highRow;
int rows, cols;

/*
 * When generating high-resolution images, the CONFIG_SCALE_FACTOR
 * is used as the multiplier for the number of pixels. (e.g, a canvas
 * of 1000x1000px with a scale factor of 5 gives a 5000x5000px image.
 */
final int CONFIG_SCALE_FACTOR = 5;

/*
 * =========================================================
 * =========================================================
 * Ignore everything below this line! Just press '?' while
 * your sketch is running to get a list of available options
 * to export your sketch into various formats.
 * =========================================================
 * =========================================================
 */

int seed;

void settings() {
  size(CONFIG_WIDTH_PIXELS, CONFIG_HEIGHT_PIXELS);
}

void setup() {
  seed = millis();
  f = createFont("Arial",14);
  textFont(f);
  cp5 = new ControlP5(this);
  addUI();

  readData();
  seededRender();
}

void draw() {
}

void addUI() {
  cp5.addSlider("highY")
     .setPosition(10,10)
     .setRange(0,500)
     .setValue(250);

  cp5.addSlider("pointSize")
    .setPosition(10,20);

  cp5.addSlider("margin")
    .setPosition(10,30)
    .setValue(10);

  cp5.addSlider("highRow")
    .setPosition(10,40)
    .setValue(13);

  cp5.addSlider("lowY")
    .setPosition(10,50)
    .setRange(1,200)
    .setValue(100);

  cp5.addSlider("tight")
    .setPosition(10,60)
    .setRange(0, 0.5);

  cp5.addSlider("gap")
    .setPosition(10,70)
    .setRange(0,2)
    .setValue(0.6);
}

void seededRender() {
  randomSeed(seed);
  noiseSeed(seed);
  render();
}

// To update the render after every controlP5
void controlEvent(ControlEvent theEvent) {
  render();
}

int fromOrigin() {
  return height - margin;
}

int fromOrigin(int y) {
  return height - margin - y;
}

void makeRegistrationMarks() {
  strokeWeight(1);
  stroke(255, 0, 0);
  line(35, 10, 35, REG_PIXELS); // Top left
  stroke(0, 0, 0);
  line(10,35, REG_PIXELS, 35);
  stroke(255, 0, 0);
  line(width-35,10,width-35, REG_PIXELS); // Top right
  stroke(0, 0, 0);
  line(width-10,35,width-REG_PIXELS,35);
}

void makeGrid() {
  for (int row=0; row < 5; row++) {
    float rad = map(3200 + (row * 200) + 270, 3200, 3600, lowY, highY);
    float val = map(3200 + (row * 100), 3200, 3600, lowY, highY);
    stroke(80); strokeWeight(0.2); noFill();
    ellipse(width/2, height/2, rad, rad);
    Vec2D point = new Vec2D(val, 50)
      .toCartesian().add(width/2, height/2);
    text(3200 + (row*100), point.x, point.y);
  }
}

void makeAxis() {
  stroke(255, 0, 0);
  line(margin,fromOrigin(),width-margin,fromOrigin());
}

public ArrayList satSpectrum(int numItems, color col){
  float hue = hue(col);
  float brightness = brightness(col);
	ArrayList colors = new ArrayList();
	for (int i=0; i < numItems; i++){
		Color c = new Color(Color.HSBtoRGB(hue,(float)(1.0/numItems)*i,brightness));
		colors.add(c.getRGB());
	}
	return colors;
}

public ArrayList lumSpectrum(int numItems, color col){
  float hue = hue(col);
  float saturation = saturation(col);
	ArrayList colors = new ArrayList();
	for (int i=0; i < numItems; i++){
		Color c = new Color(Color.HSBtoRGB(hue,saturation,(float)(1.0/numItems)*i));
		colors.add(c.getRGB());
	}
	return colors;
}

void keyPressed() {
  switch(key) {
  case 'l':
    saveLowRes();
    break;
  case 'h':
    saveHighRes(CONFIG_SCALE_FACTOR);
    break;
  case 'p':
    savePDF();
    break;
  case 's':
    saveSVG();
    break;
  case 'n':
    seed = millis();
    seededRender();
    break;
  case 'u':
    if (showUI){
      showUI = false;
      cp5.hide();
    } else {
      showUI = true;
      cp5.show();
    }
    render();
    break;
  case '?':
    println("Keyboard shortcuts:");
    println("  n: Generate a new seeded image");
    println("  l: Save low-resolution image");
    println("  h: Save high-resolution image");
    println("  p: Save PDF version");
    println("  s: Save SVG version");
    println("  u: Show hide UI");
  }
}

void saveLowRes() {
  println("Saving low-resolution image...");
  save("../Renders/" + this.getClass().getName() + "-lowres-" + seed + ".png");
  println("Finished");
}

void saveHighRes(int scaleFactor) {
  PGraphics hires = createGraphics(
    width * scaleFactor,
    height * scaleFactor,
    JAVA2D);
  println("Saving high-resolution image...");
  beginRecord(hires);
  hires.scale(scaleFactor);
  seededRender();
  endRecord();
  hires.save("../Renders/" + this.getClass().getName() + "-highres-" + seed + ".png");
  println("Finished");
}

void savePDF() {
  println("Saving PDF image...");
  beginRecord(PDF, "../Renders/" + this.getClass().getName() + "-vector-" + seed + ".pdf");
  seededRender();
  endRecord();
  println("Finished");
}

void saveSVG() {
  println("Saving SVG image...");
  beginRecord(SVG, "../Renders/" + this.getClass().getName() + "-vector-" + seed + ".svg");
  seededRender();
  endRecord();
  println("Finished");
}
