import 'package:flutter/material.dart';

class Alert {
  final List<String> Emoticon = ['đ', 'đ', 'đ', 'đĽ', 'đą'];
  final int targetSpend = 30000; //çŽć¨ćŻĺş
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
    //çśćăŤĺżăăéĄćĺ­ăčżă
    return Emoticon[rtnState(spend)];
  }
}
