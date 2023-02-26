import 'package:shared_preferences/shared_preferences.dart';

class savingsManagement {
  static Future setSavings(int savings) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('Savings', savings);
  }

  static Future<int> getSavings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int rtn = prefs.getInt('Savings') ?? 0;
    return rtn;
  }

//支出の場合、引数をマイナスにして入れる
  static Future<void> changeSavings(int changes) async {
    setSavings(await getSavings() + changes);
  }
}
