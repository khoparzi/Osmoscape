import processing.svg.*;
import processing.pdf.*;
import geomerative.*;

/* Set the width and height of your screen canvas in pixels */
final int CONFIG_WIDTH_PIXELS = 500;
final int CONFIG_HEIGHT_PIXELS = 500;

PFont f;

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
  f = createFont("Arial",24);
  textFont(f);
  seededRender();
}

void draw() {
}

void seededRender() {
  randomSeed(seed);
  noiseSeed(seed);
  render();
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
  case '?':
    println("Keyboard shortcuts:");
    println("  n: Generate a new seeded image");
    println("  l: Save low-resolution image");
    println("  h: Save high-resolution image");
    println("  p: Save PDF version");
    println("  s: Save SVG version");
  }
}

void saveLowRes() {
  println("Saving low-resolution image...");
  save("../Renders/lowres-" + seed + ".png");
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
  hires.save("../Renders"+seed + "highres-" + seed + ".png");
  println("Finished");
}

void savePDF() {
  println("Saving PDF image...");
  beginRecord(PDF, "../Renders/vector-" + seed + ".pdf");
  seededRender();
  endRecord();
  println("Finished");
}

void saveSVG() {
  println("Saving SVG image...");
  beginRecord(SVG, "../Renders/vector-" + seed + ".svg");
  seededRender();
  endRecord();
  println("Finished");
}
