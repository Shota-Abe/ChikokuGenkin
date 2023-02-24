import 'package:alarm/alarm.dart';
import 'package:calendar_hackathon/pages/alarm.dart';
import 'package:calendar_hackathon/pages/calendar.dart';
import 'package:calendar_hackathon/pages/chart_page.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  int _currentIndex = 0;
  final _screens = [CalendarView(), ChartPage(), AlarmView()];

  @override
  void initState() {
    super.initState();
  }

  Future<void> setAlarm(DateTime dateTime, [bool enableNotif = true]) async {
    final alarmSettings = AlarmSettings(
      dateTime: dateTime,
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: true,
      notificationTitle: enableNotif ? 'Alarm example' : null,
      notificationBody: enableNotif ? 'Your alarm is ringing' : null,
      enableNotificationOnKill: true,
    );

    await Alarm.set(settings: alarmSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
            if (index == 2) {
              setAlarm(DateTime.now().add(const Duration(seconds: 5)));
            }
          });
        },
        selectedIndex: _currentIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'カレンダー',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'グラフ',
          ),
          NavigationDestination(
            icon: Icon(Icons.alarm),
            label: 'アラーム',
          ),
        ],
      ),
    );
  }
}
