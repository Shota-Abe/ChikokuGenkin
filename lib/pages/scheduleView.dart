import 'package:calendar_hackathon/model/dbIo.dart';
import 'package:calendar_hackathon/model/schedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key, required this.scheduleMap}) : super(key: key);
  final Map<DateTime, List<Schedule>> scheduleMap;

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  //late final selectedList

  final scheduleListItem = []; //schefuleMapをそのまま持ってきたい。

  @override
  Widget build(BuildContext context) {
    widget.scheduleMap.forEach(
      (key, value) {
        scheduleListItem.addAll(value);
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("予定表"),
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: scheduleListItem.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(
                  '${scheduleListItem[index].startAt.month}/${scheduleListItem[index].startAt.day} ${scheduleListItem[index].title}',
                  style: const TextStyle(fontSize: 18),
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                        child: Text(DateFormat('開始 H:mm')
                            .format(scheduleListItem[index].startAt))),
                    Expanded(
                        child: Text(DateFormat('終了 H:mm')
                            .format(scheduleListItem[index].endAt))),
                    Expanded(
                        child: Text(DateFormat('起床 H:mm')
                            .format(scheduleListItem[index].getUpTime))),
                    IconButton(
                      onPressed: () async {
                        //await scheduleDb.updateSchedule(selectedList, sch);
                      },
                      icon: const Icon(Icons.edit),
                      iconSize: 20,
                    ),
                    IconButton(
                      splashRadius: 10,
                      onPressed: () async {
                        //await scheduleDb.deleteSchedule(selectedList);
                      },
                      icon: const Icon(Icons.delete, size: 20),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
            ],
          );
        },
      ),
    );
  }
}
