/*
 * Zoomer
 * By Lorenzo Pasqualis
 *
 * Manages all the zooming and rotation of the view.
 */

class Zoomer{

  private float m_zoom;   // Zoom level, 2.0 = 2x zoom
  private float m_angle;  // Angle of rotation
  private float m_x0;     // Origin X, center of the view
  private float m_y0;     // Origin Y, center of the view
  private float m_xRot;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void record(JSONObject jo) {
    jo.setFloat("zoom",m_zoom);
    jo.setFloat("angle",m_angle);
    jo.setFloat("x0",m_x0);
    jo.setFloat("y0",m_y0);
    jo.setFloat("xRot",m_xRot);
  }  
  
  Zoomer() {
    reset();
  }
  
  Zoomer(JSONObject jo) {
    reset();
    m_zoom    = jo.getFloat("zoom");
    m_angle   = jo.getFloat("angle");
    m_x0      = jo.getFloat("x0");
    m_y0      = jo.getFloat("y0");
    m_xRot    = jo.getFloat("xRot");
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  void draw() {
    scale (m_zoom);
    translate (width()/2.0  - m_x0,  height()/2.0 - m_y0, 0);
    rotate (m_angle);
    rotateX (radians(m_xRot));
  }
  
  String status() {
    return "Zoom: "+m_zoom+"\nCenter: "+m_x0+","+m_y0+"\nRotation: "+m_xRot+"\nAngle: "+m_angle+"\n";
  }
  
  void in()          { m_zoom  += min(.05,m_zoom/10); }
  void out()         { m_zoom  -= min(.05,m_zoom/10); }

  void rotateXin()   { if (m_xRot>0) m_xRot  -= 1; }
  void rotateXout()  { if (m_xRot<90) m_xRot += 1; }

  void rotateLeft()  { m_angle -= .05; }
  void rotateRight() { m_angle += .05; }
  
  void up()          { m_y0 += 10; }
  void down()        { m_y0 -= 10; }
  void left()        { m_x0 -= 10; }
  void right()       { m_x0 += 10; }

  void upFast()          { m_y0 += height/2; }
  void downFast()        { m_y0 -= height/2; }
  void leftFast()        { m_x0 -= width/2; }
  void rightFast()       { m_x0 += width/2; }

  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  void reset() {
    m_zoom  = 1.0;
    m_angle = 0;
    m_xRot  = 0;
    center();
  }
  
  void center() {
    m_x0    = 0;
    m_y0    = 0;
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  float width() {
    return width/m_zoom;
  }

  float height() {
    return height/m_zoom;
  }
  
  float depth() {
    return m_zoom-1.0;
  }

  float zoom() {
    return m_zoom;
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
  float xLeft()     { return -width()/2.0  + m_x0;  }
  float xRight()    { return  width()/2.0  + m_x0;  }
  float yTop()      { return -height()/2.0 + m_y0; }
  float yBottom()   { return  height()/2.0 + m_y0; }
  
  float getRotX()       { return m_xRot; }
  float getZoomLevel()  { return m_zoom; }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  float mouseX()    { return map(mouseX,0,width,xLeft(),xRight()); }
  float mouseY()    { return map(mouseY,0,height,yTop(),yBottom()); }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  void setOrigin(float x, float y) {
    m_x0 += x;
    m_y0 += y;
  }
}