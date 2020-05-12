class CA {

  int[] cells;
  int generation;

  int[]ruleset, skipNumber, colorReverse;

  String[] lines, lines2, lines3;

  int w = 7;
  int index = 0;
  int x = 234; //パターン描き始めのx位置
  int y = 200; //パターン描き始めのy位置
  int pw = 400; //パターンの横幅
  int ph = 530; //パターンの縦幅

  CA(int r) {
    lines = loadStrings("ruleset.txt");
    rule = r;
    String[] pieces = split(lines[rule], ' ');
    ruleset = int(split(pieces[1], ','));
    cells = new int[pw/w];
    restart();
    lines2 = loadStrings("skipNumber.txt");
    lines3 = loadStrings("colorReverse.txt");
    skipNumber = int(split(lines2[0], ' '));
    colorReverse = int(split(lines3[0], ' '));
  }

  // Make a random ruleset
  void randomize() {
    rule = int(random(lines.length));
    println(rule);
    //単調なルールは飛ばす
    for (int i = 0; i < skipNumber.length; i++) {
      if (rule == skipNumber[i]) {
        randomize();
      }
    }
    String[] pieces = split(lines[rule], ' ');
    String[] pieces2 = split(pieces[1], ',');
    for (int i = 0; i < 8; i++) {
      ruleset[i] = int(pieces2[i]);
    }
  }

  //Reset to generation 0
  void restart() {
    for (int i = 0; i < cells.length; i++) {
      cells[i] = 0;
    }
    cells[cells.length/2] = 1;
    generation = 0;
  }

  void generate() {
    int[] nextgen = new int[cells.length];
    for (int i = 1; i < cells.length-1; i++) {
      int left = cells[i-1];
      int me = cells[i];
      int right = cells[i+1];
      nextgen[i] = rules(left, me, right);
    }
    cells = nextgen;
    generation++;
  }

  void display() {
    for (int i = 0; i < cells.length; i++) {
      if (cells[i] == 1) fill(64, 73, 106); //紺色
      else fill(207, 202, 229); //薄紫

      //色の塗り方が逆のパターンを設定
      for (int j = 0; j < colorReverse.length; j++) {
        if (rule == colorReverse[j]) {
          if (cells[i] == 1) fill(207, 202, 229); //紺色
          else fill(64, 73, 106); //薄紫
        }
      }
      noStroke();
      rect(x+i*w, y+generation*w, w, w);
    }
  }

  int rules (int a, int b, int c) {
    if (a == 1 && b == 1 && c == 1) return ruleset[0];
    if (a == 1 && b == 1 && c == 0) return ruleset[1];
    if (a == 1 && b == 0 && c == 1) return ruleset[2];
    if (a == 1 && b == 0 && c == 0) return ruleset[3];
    if (a == 0 && b == 1 && c == 1) return ruleset[4];
    if (a == 0 && b == 1 && c == 0) return ruleset[5];
    if (a == 0 && b == 0 && c == 1) return ruleset[6];
    if (a == 0 && b == 0 && c == 0) return ruleset[7];
    return 0;
  }

  boolean finished() {
    if (generation > ph/w) {
      return true;
    } else {
      return false;
    }
  }
}
