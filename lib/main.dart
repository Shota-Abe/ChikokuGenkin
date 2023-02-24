import 'package:alarm/alarm.dart';
import 'package:calendar_hackathon/pages/calendar.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import 'pages/root.dart';

// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.disable();

  await Alarm.init();

  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      // home: const CalendarView(),
      home: Root(),
    );
  }
}
