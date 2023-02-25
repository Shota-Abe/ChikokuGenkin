class Alert {
  final List<String> Emoticon = ['😆', '😀', '🙂', '😥', '😱'];
  final int targetSpend = 30000; //目標支出
  int rtnState(int spend) {
    int subscript;

    for (subscript = 1; subscript < 5; subscript++) {
      if (spend < subscript * targetSpend * 2 / 5) {
        break;
      }
    }
    return subscript - 1;
  }

  String alert(int spend) {
    //状態に応じた顔文字を返す
    return Emoticon[rtnState(spend)];
  }
}
