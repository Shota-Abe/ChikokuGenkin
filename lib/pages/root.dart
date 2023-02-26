import 'package:alarm/alarm.dart';
import 'package:calendar_hackathon/model/dbIo.dart';
import 'package:calendar_hackathon/model/schedule.dart';
import 'package:calendar_hackathon/pages/alarm.dart';
import 'package:calendar_hackathon/pages/calendar.dart';
import 'package:calendar_hackathon/pages/chart_page.dart';
import 'package:calendar_hackathon/pages/scheduleView.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  Future<void> setAlarm([bool enableNotif = true]) async {
    // final id = await scheduleDb.createSchedule(Schedule(
    //     title: "title",
    //     startAt: DateTime.now(),
    //     endAt: DateTime.now(),
    //     getUpTime: DateTime.now().add(Duration(minutes: 1)),
    //     // getUpTime: DateTime.now(),
    //     memo: "memo"));
    // print(await scheduleDb.getSchedule(id));

    final nextSchedule = await scheduleDb.getNextSchedule();

    if (nextSchedule != null) {
      final nextGetUpTimeString = nextSchedule['getUpTime'] as String;
      print(nextGetUpTimeString);

      List<String> dateAndTime = nextGetUpTimeString.split('-');
      int year = int.parse(dateAndTime[0]);
      int month = int.parse(dateAndTime[1]);
      int day = int.parse(dateAndTime[2]);
      int hour = int.parse(dateAndTime[3].substring(0, 2));
      int minute = int.parse(dateAndTime[3].substring(2, 4));
      List<int> dateTimeList = [year, month, day, hour, minute];
      print(dateTimeList); // [2023, 2, 25, 16, 47]

      final nextGetUpTime = DateTime(dateTimeList[0], dateTimeList[1],
          dateTimeList[2], dateTimeList[3], dateTimeList[4]);

      final alarmSettings = AlarmSettings(
        dateTime: nextGetUpTime,
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: true,
        notificationTitle: enableNotif ? 'アラーム' : null,
        notificationBody: enableNotif ? 'アラームが鳴っています' : null,
        enableNotificationOnKill: true,
      );

      await Alarm.set(settings: alarmSettings);
    }
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
                    setAlarm();
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
