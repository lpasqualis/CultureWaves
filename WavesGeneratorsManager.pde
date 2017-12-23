class WavesGeneratorsManager {
  ArrayList<WaveGenerator> m_waveGenerators;
  Conf m_conf;
  Zoomer m_zoom;
  
  WavesGeneratorsManager(Conf conf, Zoomer zoomer) {
    m_waveGenerators         = new ArrayList<WaveGenerator>();
    m_conf = conf;
    m_zoom = zoomer;
  }
  
  ArrayList<WaveGenerator> getAll() {
    return m_waveGenerators;
  }
  
  void removeLast() {
    if(!m_waveGenerators.isEmpty()) {
      m_waveGenerators.remove(m_waveGenerators.size()-1);
    }
  }

  void remove(WaveGenerator wg) {
     m_waveGenerators.remove(wg);
  }
  
  void addMember(float x, float y) {
    m_waveGenerators.add(new Member(m_conf, new PVector(x, y)));
  }
  
  void remove(float x, float y) {
    WaveGenerator wg = find(x,y);
    if (wg!=null) {
      remove(wg);
    }
  }
  
  WaveGenerator find(float x, float y) {
    PVector clicked = new PVector(x, y);
    WaveGenerator result=null;
    for(WaveGenerator wg: m_waveGenerators){ 
      // If (x,y) is close enough
      if(wg.getLoc().dist(clicked)<m_conf.clickDistance/m_zoom.getZoomLevel()){
        if (result==null) {
          result = wg; // We don't have any other candidate, so just set it
        } else {
          if (wg.getLoc().dist(clicked)<result.getLoc().dist(clicked)) {
            result = wg; // This one is closer than the current candidte. Replace it.
          }
        }
      }
    }
    return result;
  }
  
  void restore(JSONObject jo) {
    JSONArray members = jo.getJSONArray("members");
    ArrayList waveGenerators = new ArrayList<WaveGenerator>();
    for (int i = 0; i < members.size(); i++) {
      waveGenerators.add(new Member(m_conf,members.getJSONObject(i)));
    }  
    m_waveGenerators=waveGenerators;
  }

}