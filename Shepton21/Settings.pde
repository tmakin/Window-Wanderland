
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

  int margin=10;
  float aspectRatio = 1.35;

  float rotX=0;
  float rotY=0;

  int n;
  int w;
  int h;

  ArrayList<ShowSettings> showList = new ArrayList<ShowSettings>();

  Settings() {

    showList.add(new ShowSettings(2, 2)); 
    showList.add(new ShowSettings(3, 2)); 

    showList.add(new ShowSettings(1, 2)); 
    showList.add(new ShowSettings(0, 2)); 

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
