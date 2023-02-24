import 'dart:async';

import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';

class AlarmView extends StatefulWidget {
  @override
  _AlarmViewState createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アラーム'),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(onPressed: () async {
              await Alarm.stop();
            }, child: const Text("ボタン"),)
          ],
        ),
      ),
    );
  }
}
