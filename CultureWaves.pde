/**
 * Culture Waves
 * by Lorenzo Pasqualis
 *
 * See: https://github.com/lpasqualis/CultureWaves
 */

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Globals
////////////////////////////////////////////////////////////////////////////////////////////////////////////

Culture g_culture;

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Setup the sketch
////////////////////////////////////////////////////////////////////////////////////////////////////////////

void setup(){
  size(500, 500, P3D);
  surface.setResizable(true);
  g_culture = new Culture(this);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Drawing
////////////////////////////////////////////////////////////////////////////////////////////////////////////

void draw(){
  g_culture.draw();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Key handling
////////////////////////////////////////////////////////////////////////////////////////////////////////////

void keyPressed() {
  g_culture.keyPressed();
}

void keyReleased() {
  g_culture.keyReleased();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Mouse handling
////////////////////////////////////////////////////////////////////////////////////////////////////////////

void mousePressed(){
  g_culture.mousePressed();
}

void mouseWheel(MouseEvent event) {
  g_culture.mouseWheel(event);
}

void mouseDragged() {
  g_culture.mouseDragged();
}

void mouseReleased() {
  g_culture.mouseReleased();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CallBacks
////////////////////////////////////////////////////////////////////////////////////////////////////////////

//
// Callback for Culture.loadWave()
//
void waveSelected(File selection) {
  if (selection != null) {
    g_culture.loadWave(selection);
  }
}