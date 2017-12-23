/**
 * Instructions.
 * by Lorenzo Pasqualis
 *
 * Show the instructions for CultureWaves usage.
 */

class Instructions{
  private PFont   m_font;
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Creates an instructions object in a zoomer environment
  
  Instructions() {
    m_font = createFont("Georgia", fontSize());
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Returns the font size
  
  int fontSize() {
    return 14;
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Returns the copy of the instructions
  
  String instructionsCopy() {
    return 
      "[SHIFT or ALT]+LEFT-CLICK = Add Member\n"+
      "RIGHT-CLICK = Remove Member\n"+
      "LEFT CLICK = Select Member\n"+
      "MOUSE WHEEL = ZOOM IN/OUT\n"+
      "SHIFT+MOUSE WHEEL = ROTATE X\n"+
      "SHIFT+UP / SHIFT+DOWN = Zoom Out/In\n"+
      "COMMAND+S / COMMAND+L= Save/Load Wave\n"+
      "TAB = Change Color Schema\n"+
      "[ / ] = Higher/Lower Resolution\n"+
      "+/- = Luminosity control\n"+
      "r = Reset\n"+
      "c = Center\n"+
      "i = Toggle instructions\n"+
      "f = Fast, low-res\n"+
      "s = Slow, high-res\n"+
      "h = Toggle members\n"+
      "b = Re-balance lights\n"+
      "d = Toggle depth\n"+
      "x = Toggle status\n"+
      "' = Toggle labels\n"+
      "LEFT / RIGHT / UP / DOWN / MOUSE-DRAG = Move view\n"+
      "SPACE = Stop Animation\n";
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Draws the instructions. Call from main draw() function.
  
  void draw() {
    pushMatrix();
    hint(DISABLE_DEPTH_TEST);
    background(0);
    textFont(m_font);
    textAlign(CENTER,CENTER);
    fill(0, 255, 0, 255);
    text(instructionsCopy(), width/2, height/2);
    hint(ENABLE_DEPTH_TEST);
    popMatrix();
  }
}