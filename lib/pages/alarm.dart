import 'dart:async';

import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';

class AlarmView extends StatefulWidget {
  DateTime getUpTime;
  AlarmView(this.getUpTime, {super.key});
  @override
  _AlarmViewState createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  bool showNotifOnRing = true;
  bool showNotifOnKill = true;
  bool isRinging = false;
  bool loopAudio = true;

  StreamSubscription? subscription;

  // Future<void> pickTime() async {
  //   final now = DateTime.now();
  //   final res = await showTimePicker(
  //     initialTime: TimeOfDay(
  //       hour: now.hour,
  //       minute: now.add(const Duration(minutes: 1)).minute,
  //     ),
  //     context: context,
  //     confirmText: 'SET ALARM',
  //   );

  //   if (res == null) return;
  //   setState(() => selectedTime = res);

  //   DateTime dt = DateTime(
  //     now.year,
  //     now.month,
  //     now.day,
  //     selectedTime!.hour,
  //     selectedTime!.minute,
  //   );

  //   if (ringDay() == 'tomorrow') dt = dt.add(const Duration(days: 1));

  //   setAlarm(dt);
  // }

  // String ringDay() {
  //   final now = TimeOfDay.now();

  //   if (selectedTime!.hour > now.hour) return 'today';
  //   if (selectedTime!.hour < now.hour) return 'tomorrow';

  //   if (selectedTime!.minute > now.minute) return 'today';
  //   if (selectedTime!.minute < now.minute) return 'tomorrow';

  //   return 'tomorrow';
  // }

  Future<void> setAlarm(DateTime dateTime, [bool enableNotif = true]) async {
    final alarmSettings = AlarmSettings(
      dateTime: dateTime,
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: loopAudio,
      notificationTitle:
          showNotifOnRing && enableNotif ? 'Alarm example' : null,
      notificationBody:
          showNotifOnRing && enableNotif ? 'Your alarm is ringing' : null,
      enableNotificationOnKill: true,
    );
    await Alarm.set(settings: alarmSettings);
  }

  @override
  void initState() {
    super.initState();
    subscription = Alarm.ringStream.stream.listen((_) {
      setState(() {
        isRinging = true;
      });
    });
    setAlarm(widget.getUpTime);
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アラーム'),
      ),
      body: Center(
        child: Text(widget.getUpTime.toString()),
      ),
    );
  }
}
