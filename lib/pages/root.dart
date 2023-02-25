import 'package:alarm/alarm.dart';
import 'package:calendar_hackathon/model/dbIo.dart';
import 'package:calendar_hackathon/model/schedule.dart';
import 'package:calendar_hackathon/pages/alarm.dart';
import 'package:calendar_hackathon/pages/calendar.dart';
import 'package:calendar_hackathon/pages/chart_page.dart';
import 'package:calendar_hackathon/pages/scheduleView.dart';
import 'package:flutter/material.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  Map<DateTime, List<Schedule>> scheduleMap = {};

  int _currentIndex = 0;
  bool _shouldShowBlack = false;
  final _screens = [CalendarView(), ScheduleView(), ChartPage(), AlarmView()];

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
              body: _screens[_currentIndex],
              bottomNavigationBar: NavigationBar(
                onDestinationSelected: (int index) {
                  if (index == 3) {
                    setAlarm(DateTime.now().add(const Duration(seconds: 5)));
                  }
                  setState(() {
                    _currentIndex = index;
                  });
                },
                selectedIndex: _currentIndex,
                destinations: const <Widget>[
                  NavigationDestination(
                    icon: Icon(Icons.calendar_month),
                    label: 'カレンダー',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.view_list),
                    label: 'スケジュール',
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
            ),
    );
  }
}
