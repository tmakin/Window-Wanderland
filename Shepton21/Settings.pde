
class Settings {
  final String fileName = "settings.json";

  int nX = 4;
  int nY = 5;

  int margin=50;
  float aspectRatio = 1.2;
  
  float rotX=0;
  float rotY=0;
  
  int showIndex = 3;


  int n;
  int w;
  int h;
  
  Settings() {
    load();
    postProcess();

    JSONObject json = serializeJSON();
    println(json);
  }

  private void postProcess() {
    n = nX*nY;
    h = int((height-2*margin)/nY);
    w = int(h/aspectRatio);    
  }

  JSONObject serializeJSON() {
    JSONObject json = new JSONObject();
    json.setInt("nX", nX);
    json.setInt("nY", nY);
    json.setInt("margin", margin);
    json.setFloat("aspectRatio", aspectRatio);
    
    json.setFloat("rotX", rotX);
    json.setFloat("rotY", rotY);
    
    json.setInt("showIndex", showIndex);

    return json;
  }

  void save() {
    JSONObject json = serializeJSON();
    saveJSONObject(json, fileName);
    println("Settings saved", fileName);
  }

  void load() {
    File f = dataFile(fileName);
    if (!f.isFile()) {
      println("Settings file not found", fileName);
      return;
    }

    JSONObject json = loadJSONObject(fileName);

    nX = json.getInt("nX", nX);
    nY = json.getInt("nY", nY);

    w = json.getInt("w", w);
    h = json.getInt("h", h);

    rotX = json.getFloat("rotX", rotX);
    rotY = json.getFloat("rotY", rotY);
    
    margin = json.getInt("margin", margin);
    aspectRatio = json.getFloat("aspectRatio", aspectRatio);
    
    showIndex = json.getInt("showIndex", showIndex);
    
    println("Settings loaded", fileName);
  }
}
