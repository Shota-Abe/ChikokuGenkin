import 'package:flutter/material.dart';

import 'package:alarm/alarm.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';

import 'pages/root.dart';
import 'package:calendar_hackathon/model/dbIo.dart';
import 'package:calendar_hackathon/model/schedule.dart';
import 'package:calendar_hackathon/model/moneyManagemant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  Wakelock.disable();

  await Alarm.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      // home: const CalendarView(),
      home: Root(),
    );
  }
}
