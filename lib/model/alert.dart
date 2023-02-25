import 'package:calendar_hackathon/model/savingsIo.dart';
import 'package:calendar_hackathon/model/targetSpendIo.dart';

class Alert {
  final List<String> Emoticon = ['😆', '😀', '🙂', '😥', '😱'];

  Future<int> rtnState(int spend) async {
    targetSpendIo tSIo = targetSpendIo();
    int subscript;
    int targetSpend = await tSIo.getTargetSpend(); //目標支出

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
