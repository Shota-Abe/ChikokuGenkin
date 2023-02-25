import 'package:shared_preferences/shared_preferences.dart';

class targetSpendIo {
  Future setTargetSpend(int targetSpend) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('targetSpend', targetSpend);
  }

  Future<int> getTargetSpend() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int rtn = await prefs.getInt('targetSpend') ?? 0;
    return rtn;
  }
}
