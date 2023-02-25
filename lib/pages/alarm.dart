import 'dart:async';
import 'dart:math';
import 'package:sensors/sensors.dart';

import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';

class AlarmView extends StatefulWidget {
  @override
  _AlarmViewState createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  // GyroscopeEvent? _gyroscopeEvent;
  // StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  // void _startListeningGyroscope() {
  //   _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
  //     setState(() {
  //       _gyroscopeEvent = event;
  //     });
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   if (mounted) {
  //     _startListeningGyroscope();
  //   }
  // }

  // @override
  // void dispose() {
  //   _gyroscopeSubscription?.cancel();
  //   super.dispose();
  // }

  bool _shouldShowBlack = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          _shouldShowBlack = !_shouldShowBlack;
        });
      },
      child: _shouldShowBlack
          ? Container(
              color: Colors.black,
            )
          : Scaffold(
              appBar: AppBar(
                title: Text('アラーム'),
                // title:
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const TextField(
                        decoration: InputDecoration(hintText: '収入を入力'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const TextField(
                        decoration: InputDecoration(hintText: '支出を入力'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          bool hasAlarm = await Alarm.hasAlarm();
                          if (hasAlarm) {
                            await Alarm.stop();
                          }
                        },
                        child: const Text("ストップ"),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
