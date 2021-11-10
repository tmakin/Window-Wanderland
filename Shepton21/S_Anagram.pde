import java.util.Queue;

String[] words = {"SHEPTON MALLET ", "TALLEST MEN HOP", "LETHAL POSTMEN", "MALLET PET NOSH", "THE MOLTEN ALPS", "HOT MENS PALLET", "SELL POTENT HAM", "ALLEN PET MOTHS", "HTML ANTELOPES"};


class CharBox {
  char character;
  int index;
  ShowBox box;

  CharBox(char character, int index, ShowBox box) {
    this.character = character;
    this.index = index;
    this.box = box;
  }
}

class AnagramShow extends Show {
  Window window;
  Window staticWindow;
  int pause = 0;

  CharBox[] charBoxes;
  ArrayList<CharBox> availableTiles = new ArrayList<CharBox>();
  int wordIndex = 0;
  String nextWord;
  int charIndex = 0;
  int n;

  color invalidColor = color(350, 90, 70);
  color[] tileColors = {color(200, 30, 100), color(150, 30, 100), color(100, 30, 100), color(50, 30, 100), color(0, 30, 100)};
  int colorIndex = 0;

  AnagramShow(Settings settings) {
    super(settings); 
    window = new Window(settings);
    staticWindow = new Window(settings);

    String refWord = words[0];
    n = Math.min(refWord.length(), settings.n);
    
    charBoxes = new CharBox[n];
    for (int k = 0; k < n; k++) {
      ShowBox box = window.boxes[k];
      char c = refWord.charAt(k);
      if (c == ' ') {
        box.disable();
      } else {
        box.setChar(c);
      }
      charBoxes[k] = new CharBox(c, k, box);
    }

    setNextWord();
    initColors();
  }

  void setNextWord() {
    nextColor();
    wordIndex++;
    if (wordIndex >= words.length) {
      wordIndex = 0;
      nextLoop();
    }

    nextWord = words[wordIndex];
    charIndex = 0;
  }

  void initColors() {
    for (CharBox item : charBoxes) {
      if (item.character == ' ') {
        nextColor();
      } else {
        item.box.setColor(tileColors[colorIndex]);
      }
    }
  }

  void nextColor() {
    colorIndex++;
    if (colorIndex >= tileColors.length) {
      colorIndex = 0;
    }
  }


  void swapTiles(int iA, int iB) {
    CharBox a = charBoxes[iA];
    CharBox b = charBoxes[iB];

    a.box.animate(b.box.box, 80);
    b.box.animate(a.box.box, -80);
    charBoxes[iB] = a;
    charBoxes[iA] = b;
  }

  void update() {
    if (pause>0) {
      pause--;
      return;
    }

    if (window.isAnimating()) {
      return;
    }

    if (charIndex == 0) {
      //resetColors();
    }

    if (charIndex >= nextWord.length()) {
      println("Reached end of word", charIndex);
      pause = 100;
      setNextWord();
      return;
    }


    int nextIndex = -1;
    char nextChar = nextWord.charAt(charIndex);
    for (int k=charIndex; k < n; k++) {
      if (charBoxes[k].character == nextChar) {
        nextIndex = k;
        break;
      }
    }

    if (nextIndex < 0) {
      println("Failed to find next index", charIndex, nextChar);
      setNextWord();
      return;
    }

    if (nextIndex != charIndex) {
      swapTiles(nextIndex, charIndex);
    }

    CharBox box = charBoxes[charIndex];
    if (box.character == ' ') {
      nextColor();
    } else {
      box.box.setColor(tileColors[colorIndex]);
    }
    charIndex++;
  }

  void draw() {
    window.draw();
    staticWindow.drawFrame();
  }

  void stop() {
  }

  void start() {
  }
}
