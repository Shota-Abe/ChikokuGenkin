import 'package:shared_preferences/shared_preferences.dart';

class Alert {
  final List<String> Emoticon = ['😆', '😀', '🙂', '😥', '😱'];

  Future setTargetSpend(int targetSpend) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('targetSpend', targetSpend);
  }

  Future<int> getTargetSpend() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int rtn = await prefs.getInt('targetSpend') ?? 0;
    return rtn;
  }

  Future<int> rtnState(int spend) async {
    int subscript;
    int targetSpend = await getTargetSpend(); //目標支出

    for (subscript = 1; subscript < 5; subscript++) {
      if (spend < subscript * targetSpend * 2 / 5) {
        break;
      }
    }
    return Future.value(subscript - 1);
  }

  Future<String> alert(int spend) async {
    //状態に応じた顔文字を返す
    return Future.value(Emoticon[await rtnState(spend)]);
  }
}
