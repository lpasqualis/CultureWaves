
/**
 * Member.
 * by Lorenzo Pasqualis
 *
 * Represent a wave generator that can be place anywhere in the view.
 * Any specialized Wave Generator should derive from this base one.
 */
class WaveGenerator{
  
  protected Conf    m_conf;
  protected PVector m_loc;
  protected float   m_startTime;
  protected float   m_energy;
  protected float   m_amp;
  protected float   m_speed;
  protected float   m_interval;
  protected int     m_tick;
  protected boolean m_highlight;
  protected FastTrig m_fastTrig;

  void record(JSONObject jo) {
      jo.setFloat("x",m_loc.x);
      jo.setFloat("y",m_loc.y);
      jo.setFloat("z",m_loc.z);
      jo.setFloat("energy",m_energy);
      jo.setFloat("amp",m_amp);
      jo.setFloat("speed",m_speed);
      jo.setFloat("interval",m_interval);
  }
  
  WaveGenerator(Conf conf, JSONObject jo) {
      reset();
      m_conf      = conf;
      m_loc.x     = jo.getFloat("x");
      m_loc.y     = jo.getFloat("y");
      m_loc.z     = jo.getFloat("z");
      m_energy    = jo.getFloat("energy");
      m_amp       = jo.getFloat("amp");
      m_speed     = jo.getFloat("speed");
      m_interval  = jo.getFloat("interval");
  }

  WaveGenerator(WaveGenerator wg) {
    m_conf            = wg.m_conf;
    m_loc             = wg.m_loc;
    m_startTime       = wg.m_startTime;
    m_energy          = wg.m_energy;
    m_amp             = wg.m_amp;
    m_speed           = wg.m_speed;
    m_interval        = wg.m_interval;
    m_tick            = wg.m_tick;
    m_highlight       = wg.m_highlight;
    m_fastTrig        = wg.m_fastTrig;
  }

  WaveGenerator(Conf conf){
    reset();
    m_conf          = conf;
  }

  WaveGenerator(Conf conf, PVector _loc){
    reset();
    m_conf            = conf;
    m_loc             = _loc;
    m_amp             = random(m_conf.minAmp,      m_conf.maxAmp);
    m_speed           = random(m_conf.minSpeed,    m_conf.maxSpeed);
    m_interval        = random(m_conf.minInterval, m_conf.maxInterval);
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  void reset() {
    m_conf          = null;
    m_loc           = new PVector();
    m_startTime     = 0;
    m_energy        = 1.0;
    m_amp           = 0;
    m_speed         = 0;
    m_interval      = 0;
    m_highlight     = false;
    m_tick          = 0;
    m_fastTrig      = new FastTrig(1000);
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Returns a time ticker
  
  int getTimeTick() {
    if (m_conf.animation) {
      m_tick = frameCount;
    }
    return m_tick; 
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Make any wave generator changs, as needed.
  
  void update(){ 
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Value at the wave generator point
  
  float getOscValue() {
    return m_amp * m_energy; 
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Get the wave value in point p
  
  float getValue(PVector p){
    float d = m_loc.dist(p)+1;
    float a = m_amp * m_energy;
    
    //float v = cos(d * m_interval - (getTimeTick() - m_startTime) * m_speed);
    float v = m_fastTrig.fastCos(d * m_interval - (getTimeTick() - m_startTime) * m_speed); // 50% faster
    
    return map(v, -1, 1, -a, a); //<>//
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Highlight
  
  void setHighlight(boolean b) {
    m_highlight = b;
  }
  
  boolean isHighlighted() {
    return m_highlight;
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // 
  
  PVector getLoc() { return m_loc; }
  
  void setLoc(float x, float y) {
    m_loc.x = x;
    m_loc.y = y;
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Draw the wave generator
  
  void draw(Zoomer zoom, float maxHeight, boolean noDistraction, boolean crowdedMode) {
    fill(map(m_amp,  m_conf.minAmp, m_conf.maxAmp,    red(m_conf.memberColors[0]),    red(m_conf.memberColors[1])),
         map(m_amp,  m_conf.minAmp, m_conf.maxAmp,  green(m_conf.memberColors[0]),  green(m_conf.memberColors[1])),
         map(m_amp,  m_conf.minAmp, m_conf.maxAmp,   blue(m_conf.memberColors[0]),   blue(m_conf.memberColors[1])));
    float a=abs((getValue(m_loc))/m_amp)+5.0;
    ellipse(m_loc.x,m_loc.y,a,a);
  }
  
}