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
                  await Alarm.stop();
                },
                child: const Text("ストップ"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
