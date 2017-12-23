/**
 * Member.
 * by Lorenzo Pasqualis
 *
 * Specialized Wave Generator that is represented with a person's name.
 * The name is selected when the object is created, and it depends on the position of that initial creation.  
 */

class Member extends WaveGenerator {
  String[] names = {
      "Adam","Alan","Aldo","Alex","Andy","Ari","Ario","Asa","Ben","Blake","Brooks",
      "Bryce","Cal","Chad","Charlie","Chase","Chris","Clay","Cole","Dane","Dan",
      "Dave","Drew","Eli","Enzo","Eric","Ethan","Evan","Felix","Franz","Fritz",
      "Gary","Gray","Gus","Heath","Henry","Hugo","Ian","Jack","Jake","James","Jason",
      "Jay","John","Josh","Lane","Lee","Liam","Luke","Mark","Matt","Max","Miles",
      "Milo","Nate","Nick","Nico","Noah","Owen","Parks","Pat","Paul","Pax","Price",
      "Ray","Rich","Roan","Ross","Ryan","Sam","Scott","Sean","Shay","Ted","Theo",
      "Tom","Troy","Ty","Van","Will","Zack","Zev","Abby","Alice","Ally","Amy","Angel",
      "Anna","Anne","Anya","April","Asia","Ava","Bay","Becca","Becky","Beth","Brooke",
      "Cara","Charlie","Cindy","Claire","Daisy","Della","Ella","Elsa","Emma","Eve",
      "Faith","Grace","Hana","Iris","Isis","Isla","Ivy","Jade","Jana","Jenna","Jill",
      "Jolie","Joy","Julie","June","Juno","Kate","Kathy","Katie","Kelly","Kerry",
      "Kim","Kitty","Lily","Lisa","Liz","Liza","Lola","Luz","Maddie","Maggie",
      "Mara","Mary","Maya","May","Misha","Molly","Nell","Nora","Oona","Oria","Paige",
      "Rain","Raven","Rhea","Rose","Sana","Sandy","Sarah","Sasha","Tara","Uma","Vera",
      "Vicky","Zadie","Zara"
    };
    
  String m_name;
  PFont m_myFont;

  void record(JSONObject jo) {
    super.record(jo);
    jo.setString("name",m_name);
  }
  
  Member(Conf conf, JSONObject jo) {
    super(conf, jo);
    m_name = jo.getString("name");
  }

  Member(WaveGenerator wg) {
    super(wg);
  }

  Member(Conf conf){
    super(conf);
  }

  Member(Conf conf, PVector _loc) {
    super(conf,_loc);
    m_name = names[floor(random(names.length))];
  }
  
  void reset() {
    super.reset();
    m_name = "";
    initFont();
  }
  
  void initFont() {
    m_myFont = createFont("Georgia", 12);
    textFont(m_myFont);
    textAlign(CENTER,CENTER);
  }
  
  float sign(float x) {
    if (x<0) return -1.0;
      else return 1.0;
  }
  
  boolean isVisible() {
    float sx = screenX(m_loc.x, m_loc.y, m_loc.z);
    float sy = screenY(m_loc.x, m_loc.y, m_loc.z);
    return (sx>=0 && sx<width && sy>=0 && sy<height);
  }
  
  void draw(Zoomer zoom, float maxHeight, boolean noDistraction, boolean crowdedMode) {     
    // Find out where on the screen the generstor will appear. If it is outside of the screen,
    // just skip the whole thing. There is no reason to draw anything if the generator is not
    // visible.
    if (isVisible()) {
      int labelTransparency = 180;
      int sphereTransprency = 255;
      float maxSphereAmp = 60;
      float minSphereAmp = 20;
  
      String textToWrite     = m_name;
      int textLines          = 1;
      int textWidth          = m_name.length();
      float distanceFactor   = min(1/zoom.getZoomLevel(),5);
      float labelWidth       = 30*distanceFactor;
      float labelHeight      = (labelWidth/3);
      
      if (m_highlight) {
          // When the Mewmber is highlighted, we want to make sure it is visible, marked in a different color and
          // has more information to allow for editing of some of its aspects. Also, we don't want to fall behind
          // other things, regardless of prospective.
          hint(DISABLE_DEPTH_TEST);
          if (!noDistraction) {
            String a1="Speed="+String.format("%.2f",m_speed);
            String a2="Amp="+String.format("%.2f",m_amp);
            textToWrite+="\n"+a1+"\n"+a2;
            textWidth=max(m_name.length(),a1.length(),a2.length());
            textLines+=2;
            labelWidth=80*distanceFactor;
            labelHeight *= textLines*1.2;
          }
          labelTransparency=200;
          sphereTransprency=255;
      }
  
      float valueAtLocation = (m_conf.animation)? getValue(m_loc) : m_amp; // when animation is stopped, display name at max size
      float ampAtLocation = ((m_amp+valueAtLocation)*5)/(m_conf.maxAmp)+minSphereAmp;             // Size of the spheres, indicating amplitude
      
      float labelX = 0.0;
      float labelY = 0.0;
      float labelZ = min(min(m_amp,200)*0.2 + maxHeight/2,100) + (60*(distanceFactor-1));
  
      color sphereColor;
      color labelColor;
      color lineColor;
      color labelBorderColor = color(0,0,0);
          
      float pointLightV1 = 100;
      float pointLightV2 = 100;
      float pointLightV3 = 100;
  
      // Choose the colors depending if this member is highlighted or not.
      if (m_highlight) {
        labelColor  =  color(255,255,0,labelTransparency);
        sphereColor =  color(180,180,0,sphereTransprency);
        lineColor   =  color(255,255,0,labelTransparency);
      } else {
        labelColor  =  color(255,255,255,labelTransparency);
        sphereColor =  color(180,180,180,sphereTransprency);
        lineColor   =  color(255,255,255,labelTransparency);
      }
  
      // Limit the size of the sphere to a max, but color it in red if we limited it. This ensures
      // that the rendering will stay sane, and at the same time gives us a visual indication of insanity.
      if (ampAtLocation>maxSphereAmp) {
        ampAtLocation=maxSphereAmp;
        sphereColor=color(255,0,0,sphereTransprency);
        if (!m_highlight) {
          labelColor  =  color(255,0,0,labelTransparency);
        }
      }
  
      // Now that we made all the rendering decisions, draw!
      pushMatrix();
  
      // Draw the member in position as a sphere
      translate(m_loc.x,m_loc.y,0);
      fill(sphereColor);
      lights();
      pointLight(pointLightV1, pointLightV2, pointLightV3, 0, 0, labelZ*10);
      sphere(ampAtLocation);
      
      if (!crowdedMode) {
        if (!m_highlight) {
          // Draw the line from the sphere to the label
          stroke(lineColor);
          strokeWeight(4);
          line(0,0,0,labelX,labelY,labelZ);
          noStroke();
        }
        
        // Prep to draw the label
        translate(labelX,labelY,labelZ);
        rotateX(-radians(zoom.getRotX())); // rotate so that we can see the labels no matter what the angle of rotation is
    
        // Draw Label
        rectMode(RADIUS);
        stroke(labelBorderColor,labelTransparency);
        strokeWeight(1);
        fill(labelColor);
        rect(0,0,labelWidth,labelHeight,8);
        
        // Text on top
        translate(0,0,1);
        fill(0,0,0,labelTransparency);
        textFont(m_myFont);
        textAlign(CENTER,CENTER);
        textSize(labelWidth/((textWidth+1)/2));
        text(textToWrite,0,0);    
      }
      // Restore defaults    
      if (m_highlight) {
        hint(ENABLE_DEPTH_TEST);
      }
      noStroke();
      rectMode(CORNER);
      popMatrix();
    }
  }
}