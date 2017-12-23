/**
 * Configuration for CultureWaves
 * by Lorenzo Pasqualis  
 */

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Configuration
////////////////////////////////////////////////////////////////////////////////////////////////////////////

class Conf {
  
  private class ColorSchema { // Represents a wave color schema
    private color m_colorLow;
    private color m_colorMid;
    private color m_colorHigh;
    private String m_name;
    
    ColorSchema(String name, int colLow, int colMid, int colHigh) {
      m_name       = name;
      m_colorLow   = colLow;
      m_colorMid   = colMid;
      m_colorHigh  = colHigh;
    }
    
    color getColorLow()   { return m_colorLow; }
    color getColorMid()   { return m_colorMid; }
    color getColorHigh()  { return m_colorHigh; }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Configurations members are public and can be modified by anything
  
  public float step;
  public float maxAmp;
  public float minAmp;
  public float maxSpeed;
  public float minSpeed;
  public float maxInterval;
  public float minInterval;  
  public boolean animation;
  public float clickDistance;
  public ArrayList<ColorSchema> waveColorSchemas;
  public int currSchemaIndex;
  public float renderingSpeed;
  
  public color wave;
  private color memberColors[] = new color[2];
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  color lowPointColor() {
    return waveColorSchemas.get(currSchemaIndex).getColorLow();
  }

  color midPointColor() {
    return waveColorSchemas.get(currSchemaIndex).getColorMid();
  }

  color highPointColor() {
    return waveColorSchemas.get(currSchemaIndex).getColorHigh();
  }
  
  void nextWaveColorSchema() {
    currSchemaIndex = ( currSchemaIndex + 1 ) % waveColorSchemas.size();
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Load configuration
  //
  Conf() {
    step                   = 2;
    maxAmp                 = 50;
    minAmp                 = 40;
    maxSpeed               = 0.8;
    minSpeed               = 0.05;
    maxInterval            = PI / 32;
    minInterval            = PI / 256;
    animation              = true;
    clickDistance          = 20.0;
    renderingSpeed         = 1.0;

    waveColorSchemas = new ArrayList<ColorSchema>();
    waveColorSchemas.add(new ColorSchema("Black & White",    #FFFFFF, #000000, #FFFFFF));
    waveColorSchemas.add(new ColorSchema("Shades of Gray",   #000000, #888888, #FFFFFF));
    waveColorSchemas.add(new ColorSchema("Eye Burner",       #FF0000, #00AA00, #0000FF));
    waveColorSchemas.add(new ColorSchema("Black/White/Red",  #000000, #FFFFFF, #FF0000));
    waveColorSchemas.add(new ColorSchema("Blue/Black/Red",   #0000FF, #000000, #FF0000));
    waveColorSchemas.add(new ColorSchema("Landscape",        #1E90FF, #228B22, #FFFFFF));
    waveColorSchemas.add(new ColorSchema("Mountains",        #3B6182, #000000, #835C3B));
    currSchemaIndex = 3;
    
    wave              = color(0,0,0,80);
    memberColors[0]     = color(0,0,0);
    memberColors[1]     = color(255,255,255);
  }
  
}