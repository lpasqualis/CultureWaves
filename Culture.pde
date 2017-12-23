/**
 * Culture.
 * by Lorenzo Pasqualis  
 *
 * Represents an energy field where a group of members generate waves.
 * Handles all aspects of CultureWaves.
 */

class Culture {
  //ArrayList<WaveGenerator> m_waveGenerators;
  WavesGeneratorsManager m_wavesGeneratorsManager;
  WaveGenerator m_selectedWaveGenerator;
  
  Conf         m_conf;
  Zoomer       m_zoom;
  Instructions m_inst;
  boolean      m_shiftIsPressed;
  boolean      m_altIsPressed;
  boolean      m_commandIsPressed;
  boolean      m_allMembersHighlightedMode;
  PVector      m_dragStartingPosition;
  boolean      m_mousePressed;
  boolean      m_crowdedMode;
  float        m_balanceV;
  
  boolean      m_hideMembers;
  boolean      m_depth;
  boolean      m_showStatus;
  boolean      m_showInstructions;
  float        m_light;
  
  PApplet      m_sketch;
  
  PFont        m_font;

  Culture(PApplet sketch) {
    m_font = createFont("Courier", 12);
    m_sketch                 = sketch;
    m_shiftIsPressed         = false;
    m_altIsPressed           = false;
    m_commandIsPressed       = false;
    m_selectedWaveGenerator  = null;
    m_conf                   = new Conf();
    m_zoom                   = new Zoomer();
    m_inst                   = new Instructions();
    m_dragStartingPosition   = null;
    m_allMembersHighlightedMode         = false;
    m_hideMembers            = false;
    m_balanceV               = 0;
    m_depth                  = true;
    m_light                  = 0.5;
    m_crowdedMode            = false;
    m_wavesGeneratorsManager         = new WavesGeneratorsManager(m_conf,m_zoom);
    
    m_wavesGeneratorsManager.addMember(0,0);
    m_wavesGeneratorsManager.addMember(50,50);
    m_wavesGeneratorsManager.addMember(-50,50);
    m_wavesGeneratorsManager.addMember(-50,-50);
    m_wavesGeneratorsManager.addMember(50,-50);
  }
  
  void draw() {
    noStroke();
    pushMatrix();
    // Scale the resolution of the rendering to ensure one step per pixel (max-resolution)
    m_conf.step = min( ((m_zoom.xRight()-m_zoom.xLeft())/width), ((m_zoom.yBottom()-m_zoom.yTop())/height))*m_conf.renderingSpeed;
  
    // Decleare some helper variables to optimize calculations
    float maxAmpSum  = 0;
    PVector p        = new PVector();
    float v;
    float step       = m_conf.step;
    float halfStep   = step / 2.0;
    float left       = m_zoom.xLeft();
    float right      = m_zoom.xRight();
    float top        = m_zoom.yTop();
    float bottom     = m_zoom.yBottom();
  
    background(0);
  
    // Set the zoom level
    m_zoom.draw();
      
    if (m_balanceV==0) {
      maxAmpSum = calcMaxAmpSum()*m_light;
    } else {
      maxAmpSum = m_balanceV*m_light;
    }
    
    // Create zome local variables to avoid repeated calls to fetch values
    // Draw the waves as the result of the interferences of the wave generators
    for(float x = left; x < right; x += m_conf.step){
      for(float y = top; y < bottom; y += m_conf.step){
        p.x = x+halfStep;
        p.y = y+halfStep;
        v   = 0;
        for(WaveGenerator wg: m_wavesGeneratorsManager.getAll()){
          v  += wg.getValue(p);
          m_balanceV = max(m_balanceV,abs(v));
        }
        drawResultingWave(x,y,v,maxAmpSum);
      }
    }
    
    if (!m_hideMembers) {
      // Draw the wave generators
      for(WaveGenerator wg: m_wavesGeneratorsManager.getAll()){
        if (wg!=m_selectedWaveGenerator) {
          wg.draw(m_zoom,maxAmpSum,m_mousePressed,m_crowdedMode);
        }
        wg.update();
      }
      if (m_selectedWaveGenerator!=null) {
        m_selectedWaveGenerator.draw(m_zoom,maxAmpSum,m_mousePressed,false);
      }
    }
    popMatrix();
    if (m_showStatus) {
      drawStatus();
    }
    if (m_showInstructions) {
      m_inst.draw();
    }
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  void drawStatus() {
    int x=10;
    int y=10;
    pushMatrix();
    hint(DISABLE_DEPTH_TEST);
    fill(255, 255, 255, 180);
    rect(x,y,200,200);
    textFont(m_font);
    textAlign(LEFT,TOP);
    fill(0, 0, 0, 255);
    String status="";
    status += "FPS: "+frameRate+"\n";
    status += "Size: "+width+"x"+height+"\n";
    status += "Memebers: "+m_wavesGeneratorsManager.getAll().size()+"\n";
    status += "Light: "+m_light+"\n";
    status += "Speed: "+m_conf.renderingSpeed+"\n";
    status += m_zoom.status();
    
    text(status,x+10,y+10);
    hint(ENABLE_DEPTH_TEST);
    popMatrix();
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /*
   * Draw the wave
   *   x,y = point to render
   *   max = amplitude scale factor, used to make sure that all points can be rendered without going out of range 
   */         
  void drawResultingWave(float x,float y, float v, float maxAmp) {
    float midAmp = 0.0;
    float minAmp = -maxAmp;
    
    color mpc = m_conf.midPointColor();
    if(v <= 0){
      color lpc = m_conf.lowPointColor();    
      fill(map(v, minAmp, midAmp,    red(lpc),    red(mpc)),
           map(v, minAmp, midAmp,  green(lpc),  green(mpc)),
           map(v, minAmp, midAmp,   blue(lpc),   blue(mpc))
           );
    } else {
      color hpc = m_conf.highPointColor();
      fill(map(v, midAmp, maxAmp,    red(mpc),    red(hpc)),
           map(v, midAmp, maxAmp,  green(mpc),  green(hpc)),
           map(v, midAmp, maxAmp,   blue(mpc),   blue(hpc))
           );    
    }
    pushMatrix();
    if (m_depth) translate(0,0,v/5);
    rect(x, y, m_conf.step, m_conf.step);
    popMatrix();
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Key handling
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  void keyPressed() {
      int k = key;
      if (k==CODED) k=keyCode; 
      switch(k) {
        case BACKSPACE:
            if (!m_wavesGeneratorsManager.getAll().isEmpty()) {
              if (m_selectedWaveGenerator==null) {
                m_wavesGeneratorsManager.removeLast();
              } else {                            
                m_wavesGeneratorsManager.remove(m_selectedWaveGenerator);
                m_selectedWaveGenerator=null;
              }
            }
            break;
            
         case LEFT:
            if (m_selectedWaveGenerator==null) {
              if (m_altIsPressed) {
                m_zoom.leftFast();
              } else {
                 m_zoom.left();
              }
            } else {
              m_selectedWaveGenerator.m_speed-=(m_shiftIsPressed)? 0.10 : 0.01;
            }
            break;
            
         case RIGHT:
            if (m_selectedWaveGenerator==null) {
              if (m_altIsPressed) {
                m_zoom.rightFast();
              } else {
                m_zoom.right();
              }
            } else {
              m_selectedWaveGenerator.m_speed+=(m_shiftIsPressed)? 0.10 : 0.01;
            }
            break;
            
         case UP:
            if (m_selectedWaveGenerator==null) {
              if (m_shiftIsPressed) {
                  m_zoom.in();
              } else {
                  if (m_altIsPressed) {
                    m_zoom.upFast();
                  } else {
                    m_zoom.up();
                  }
              }
            } else {
              m_selectedWaveGenerator.m_amp=round(m_selectedWaveGenerator.m_amp);
              m_selectedWaveGenerator.m_amp+=(m_shiftIsPressed)? 10 : 1;
            }
            break;
            
         case DOWN:
            if (m_selectedWaveGenerator==null) {
              if (m_shiftIsPressed) {
                  m_zoom.out();
              } else {
                  if (m_altIsPressed) {
                    m_zoom.downFast();
                  } else {
                    m_zoom.down();
                  }
              }
            } else {
              m_selectedWaveGenerator.m_amp=round(m_selectedWaveGenerator.m_amp);
              m_selectedWaveGenerator.m_amp-=(m_shiftIsPressed)? 10 : 1;
              if (m_selectedWaveGenerator.m_amp<0) m_selectedWaveGenerator.m_amp=0;
            }
            break;          
            
         case 'a':
         case 'A':
            m_allMembersHighlightedMode=!m_allMembersHighlightedMode;
            for (WaveGenerator wg: m_wavesGeneratorsManager.getAll()) {
              wg.setHighlight(m_allMembersHighlightedMode);
            }
            m_selectedWaveGenerator=null;
            break;
  
         case '[': if (m_conf.renderingSpeed>0.5) m_conf.renderingSpeed-=0.5;  break;
         case ']': if (m_conf.renderingSpeed<5) m_conf.renderingSpeed+=0.1;    break;
  
         case TAB: m_conf.nextWaveColorSchema();         break;          
  
         case 'f':
         case 'F': m_conf.renderingSpeed=5.0;            break;
  
         case 's':
         case 'S':
           if (!m_commandIsPressed) {
             m_conf.renderingSpeed=1.0;            
           } else {
             saveWave();
           }
           break;
         case 'l':
         case 'L':
           if (!m_commandIsPressed) {
           } else {
             loadWave();
           }
           break;
  
         case ' ': m_conf.animation = !m_conf.animation; break;
  
         case 'r':
         case 'R': m_zoom.reset();                       break;
  
         case 'i':
         case 'I': m_showInstructions=!m_showInstructions;  break;
  
         case SHIFT: m_shiftIsPressed=true;              break;
  
         case ALT: m_altIsPressed=true;                  break;
  
         case 'c':
         case 'C': m_zoom.center();                      break;
  
         case 'h':
         case 'H': m_hideMembers = !m_hideMembers;       break;
  
         case 'd':
         case 'D': m_depth = !m_depth;       break;
  
         case 'b':
         case 'B':
           m_balanceV=0;
           m_light=0.5;
           break;
         case '-':
           if(m_light<3.0) m_light+=0.1;
           break;
         case '+':
           if (m_light>0.1) m_light-=0.1;
           break;
         case 157: // Command on MACOS, WIN on Windows, META on Others
           m_commandIsPressed=true;
           break;
         case 'x':
         case 'X':
           m_showStatus=!m_showStatus;
           break;
         case ESC:
           m_showStatus=false;
           m_showInstructions=false;
           m_selectedWaveGenerator=null;
           m_allMembersHighlightedMode=false;
           m_shiftIsPressed=false;
           m_altIsPressed=false;
           m_commandIsPressed=false;
           key=0; // Makes sure the sketch doesn't quit.
           break;
         case '`':
           m_crowdedMode=!m_crowdedMode;
           break;
      }
  }
  
  void keyReleased() {
    switch(keyCode) {
      case SHIFT:  m_shiftIsPressed   = false; break;
      case ALT:    m_altIsPressed     = false; break;
      case 157:    m_commandIsPressed = false; break;
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Mouse handling
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  void mousePressed(){
    m_mousePressed = true;
    m_dragStartingPosition = null; // Reset the position of the drag  
    if (mouseButton==LEFT) { 
      // Find the member the user clicked on
      WaveGenerator wg=null;
      if(!m_altIsPressed && !m_shiftIsPressed) {
        wg=m_wavesGeneratorsManager.find(m_zoom.mouseX(), m_zoom.mouseY());
      }
      if (wg!=null) {                                             // Clicked on a wave generator
          if (m_selectedWaveGenerator!=null &&                    // There is a selected wave generator 
              !m_allMembersHighlightedMode) {                     // We are not in all-highlight mode
            m_selectedWaveGenerator.setHighlight(false);          // Selected w.g. longer highlighted
          }
          m_selectedWaveGenerator=wg;                             // change the selection to the clicked one
          m_selectedWaveGenerator.setHighlight(true);             // highlight the selection
      } else {                                                    // If didn't clicked on one w.g.
        if (m_selectedWaveGenerator!=null) {                      // There is a selected w.g.
          if(!m_allMembersHighlightedMode) {                      // we are not in all highlight
            m_selectedWaveGenerator.setHighlight(false);          // Remove selection 
          }
          m_selectedWaveGenerator=null;
          m_dragStartingPosition = new PVector(m_zoom.mouseX(),m_zoom.mouseY());
        } else {
          if(m_altIsPressed || m_shiftIsPressed) { 
             m_wavesGeneratorsManager.addMember(m_zoom.mouseX(), m_zoom.mouseY());
          }  else {
            m_dragStartingPosition = new PVector(m_zoom.mouseX(),m_zoom.mouseY());
          }
        }
      }
    } 
    else 
    {
      m_wavesGeneratorsManager.remove(m_zoom.mouseX(), m_zoom.mouseY());
    }
  }
   
  void mouseDragged() 
  {
    if(m_selectedWaveGenerator != null && !m_hideMembers) {
      // Moove the selected object where the mouse is
      m_selectedWaveGenerator.setLoc(m_zoom.mouseX(),m_zoom.mouseY());
    } else {
      if(m_dragStartingPosition!=null) {
  
        // Grab coordinates of the mouse
        float mx = m_zoom.mouseX();
        float my = m_zoom.mouseY();
        
        m_zoom.setOrigin( m_dragStartingPosition.x-mx, m_dragStartingPosition.y-my );    // Move the zoom window
        m_dragStartingPosition = new PVector(mx,my);                      // Re-center the drag from this point
      }
    }
  }
  
  void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    if (!m_shiftIsPressed) {
      if(e>0) { m_zoom.out(); }
        else { m_zoom.in(); }
    } else {
      if (e>0) { m_zoom.rotateXout(); }
        else { m_zoom.rotateXin(); }
    }
  }
  
  void mouseReleased() {
    m_dragStartingPosition = null;
    m_mousePressed = false;
  }
  
  float calcMaxAmpSum() {
    float maxAmpSum = 0;
    for(WaveGenerator wg: m_wavesGeneratorsManager.getAll()){
      maxAmpSum  += wg.m_amp;
    }
    return maxAmpSum;
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Saving/Loading waves
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  void saveWave() {
    String name="output/culture-wave-"+year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+"-"+millis()%1000;
    save(name+".png");
  
    JSONObject jo = new JSONObject();
    recordMembers(jo);
    recordZoomer(jo);
    jo.setBoolean("depth",m_depth);
    jo.setFloat("light",m_light);
    jo.setBoolean("hideMembers",m_hideMembers);
    jo.setInt("colorSchema",m_conf.currSchemaIndex);
    saveJSONObject(jo, name+".json");
  }
  
  void recordMembers(JSONObject jo) {
    JSONArray members = new JSONArray();
    int i = 0;
    for(WaveGenerator wg: m_wavesGeneratorsManager.getAll()) {
      JSONObject member = new JSONObject();
      wg.record(member);
      members.setJSONObject(i, member);
      i++;
    }
    jo.setJSONArray("members",members);
  }
  
  void recordZoomer(JSONObject jo) {
    JSONObject zoomer = new JSONObject();
    m_zoom.record(zoomer);
    jo.setJSONObject("zoomer",zoomer);
  }
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  void loadWave() {
    selectInput("Select a wave to process:", "waveSelected",null,m_sketch);
  }
  
  void loadWave(File file) {
    JSONObject jo = loadJSONObject(file.getAbsolutePath());
    
    m_wavesGeneratorsManager.restore(jo);
    m_zoom                 = restoreZoomer(jo);
    m_depth                = jo.getBoolean("depth");
    m_light                = jo.getFloat("light");
    m_hideMembers          = jo.getBoolean("hideMembers");
    m_conf.currSchemaIndex = jo.getInt("colorSchema");
  }
  
  Zoomer restoreZoomer(JSONObject jo) {
    return new Zoomer(jo.getJSONObject("zoomer"));
  }

}