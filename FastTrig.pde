/**
 * Fast Trigonometry
 * by Lorenzo Pasqualis  
 *
 * Pre-calculates a table of trigonometric functions. Speeds up trigonometric function calculations.
 * Very simple implementation only for cos values. Used to optimize CultureWaves (50% FPS improvement)
 */
class FastTrig  {
  float[] m_cosTable;
  int m_precision;
  
  // Given a "precision" number, calculats a table of cos values.
  // The larger "precision", the more accurate the results.
  FastTrig(int precision) {
    m_precision = precision;
    m_cosTable = new float[m_precision];
    for(int i=0;i<precision;i++) {
      m_cosTable[i]=cos(map(i,0,precision,0,TWO_PI));      
    }
  }
  
  float fastCos(float x) {
    return m_cosTable[(int)round(map(abs(x)%TWO_PI,0,TWO_PI,0,m_precision-1))]; //<>//
  }
}