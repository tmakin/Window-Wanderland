
class ShowSettings {
  final int index;
  final int duration;

  ShowSettings(int index, int duration) {
    this.index = index;
    this.duration = duration;
  }
}

class Settings {
  final String fileName = "settings.json";

  int nX = 3;
  int nY = 4;

  int margin=0;
  float aspectRatio = 1.9;

  float rotX=0;
  float rotY=0;

  int n;
  int w;
  int h;
  
  boolean windowFrame=false;
  boolean flip=true;

  ArrayList<ShowSettings> showList = new ArrayList<ShowSettings>();

  Settings() {

    showList.add(new ShowSettings(1, 1));  // checker
    showList.add(new ShowSettings(0, 1));  // tile
    showList.add(new ShowSettings(2, 2));  // apple
    
    showList.add(new ShowSettings(1, 1));  // checker
    showList.add(new ShowSettings(0, 1));  // tile
    showList.add(new ShowSettings(3, 2));  // murmaration

    tryLoad();
    postProcess();

    JSONObject json = serializeJSON();
    println(json);
  }

  private void postProcess() {
    n = nX*nY;
    
    float windowHeight = height-2*margin;
    float windowWidth = windowHeight/aspectRatio;
    h = int(windowHeight/nY);
    w = int(windowWidth/nX);
    //println("aspect", (float)h/(float)w);
  }

  JSONObject serializeJSON() {
    JSONObject json = new JSONObject();
    json.setInt("nX", nX);
    json.setInt("nY", nY);
    json.setInt("margin", margin);
    json.setFloat("aspectRatio", aspectRatio);

    json.setFloat("rotX", rotX);
    json.setFloat("rotY", rotY);
    
    json.setBoolean("windowFrame", windowFrame);
    json.setBoolean("flip", flip);
    
    JSONArray showListJson = new JSONArray();
    for (int i = 0; i < showList.size(); i++) {

      JSONArray values = new JSONArray();
      ShowSettings item = showList.get(i);
      values.setInt(0, item.index);
      values.setInt(1, item.duration);

      showListJson.setJSONArray(i, values);
    } 

    json.setJSONArray("showList", showListJson);

    return json;
  }

  void save() {
    JSONObject json = serializeJSON();
    saveJSONObject(json, fileName);
    println("Settings saved", fileName);
  }

  void tryLoad() {
     try {
       load();
     }
     catch(Exception e) {
           println("Failed to load settings", e);
     }
  }
  
  void load() {
    JSONObject json = loadJSONObject(fileName);

    nX = json.getInt("nX", nX);
    nY = json.getInt("nY", nY);

    w = json.getInt("w", w);
    h = json.getInt("h", h);

    rotX = json.getFloat("rotX", rotX);
    rotY = json.getFloat("rotY", rotY);

    windowFrame = json.getBoolean("windowFrame", windowFrame);
    flip = json.getBoolean("flip", flip);
    
    margin = json.getInt("margin", margin);
    aspectRatio = json.getFloat("aspectRatio", aspectRatio);


    JSONArray showListJson = json.getJSONArray("showList");
    if (showListJson.size() > 0) {
      showList.clear();

      for (int i = 0; i < showListJson.size(); i++) {

        JSONArray values = showListJson.getJSONArray(i);
        showList.add(new ShowSettings(values.getInt(0), values.getInt(1)));
      }
    }

    println("Settings loaded", fileName);
  }
}
