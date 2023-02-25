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

  Future<void> changeSavings(int changes) async {
    setSavings(await getSavings() + changes);
  }
}
