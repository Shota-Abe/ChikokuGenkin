import 'package:shared_preferences/shared_preferences.dart';

class savingsManagement {
  Future setSavings(int savings) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('targetSpend', savings);
  }

  Future<int> getSavings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int rtn = await prefs.getInt('Savings') ?? 0;
    return rtn;
  }

//支出の場合、引数をマイナスにして入れる
  Future<void> changeSavings(int changes) async {
    setSavings(await getSavings() + changes);
  }
}
