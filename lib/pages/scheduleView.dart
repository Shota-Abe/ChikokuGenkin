import 'package:calendar_hackathon/model/schedule.dart';
import 'package:calendar_hackathon/model/dbIo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  final List<Schedule> scheduleListItem = []; //スケジュール
  final List<int> idList = [];

  @override
  void initState() {
    super.initState();
    getFirstSchedule();
  }

  @override
  Widget build(BuildContext context) {
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
                        await scheduleDb.updateSchedule(
                            idList[index], scheduleListItem[index]);
                        setState(() {});
                      },
                      icon: const Icon(Icons.edit),
                      iconSize: 20,
                    ),
                    IconButton(
                      splashRadius: 10,
                      onPressed: () async {
                        await scheduleDb.deleteSchedule(idList[index]);
                        getFirstSchedule();
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

  Future<void> getFirstSchedule() async {
    final items = (await scheduleDb.getAllSchedule());
    //print(items);

    late List<String> dateAndTime;
    int year;
    int month;
    int day;
    int hour;
    int minute;
    int id;

    for (int i = 0; i < items.length; i++) {
      id = items[i]['id'];
      final itemList = await scheduleDb.getSchedule(id);
      final itemGetMap = itemList[0];
      //print(itemGetMap);
      // ignore: unnecessary_null_comparison
      if (itemGetMap != null) {
        final itemGetTitle = itemGetMap['title'] as String;
        final itemGetStratAtString = itemGetMap['startAt'] as String;
        dateAndTime = itemGetStratAtString.split('-');
        year = int.parse(dateAndTime[0]);
        month = int.parse(dateAndTime[1]);
        day = int.parse(dateAndTime[2]);
        if (dateAndTime[3].length == 4) {
          hour = int.parse(dateAndTime[3].substring(0, 2));
          minute = int.parse(dateAndTime[3].substring(2, 4));
        } else if (dateAndTime[3].length == 3 &&
            int.parse(dateAndTime[3].substring(0, 2)) > 24) {
          hour = int.parse(dateAndTime[3].substring(0, 1));
          minute = int.parse(dateAndTime[3].substring(1, 3));
        } else if (dateAndTime[3].length == 3) {
          hour = int.parse(dateAndTime[3].substring(0, 1));
          minute = int.parse(dateAndTime[3].substring(1, 3));
        } else {
          hour = int.parse(dateAndTime[3].substring(0, 1));
          minute = int.parse(dateAndTime[3].substring(1, 2));
        }
        List<int> dateTimeList = [year, month, day, hour, minute];
        //print(dateTimeList);
        final getStartAt = DateTime(dateTimeList[0], dateTimeList[1],
            dateTimeList[2], dateTimeList[3], dateTimeList[4]);

        final itemGetEndAtString = itemGetMap['endAt'] as String;
        dateAndTime = itemGetEndAtString.split('-');
        year = int.parse(dateAndTime[0]);
        month = int.parse(dateAndTime[1]);
        day = int.parse(dateAndTime[2]);
        if (dateAndTime[3].length == 4) {
          hour = int.parse(dateAndTime[3].substring(0, 2));
          minute = int.parse(dateAndTime[3].substring(2, 4));
        } else if (dateAndTime[3].length == 3 &&
            int.parse(dateAndTime[3].substring(0, 2)) > 24) {
          hour = int.parse(dateAndTime[3].substring(0, 1));
          minute = int.parse(dateAndTime[3].substring(1, 3));
        } else if (dateAndTime[3].length == 3) {
          hour = int.parse(dateAndTime[3].substring(0, 1));
          minute = int.parse(dateAndTime[3].substring(1, 3));
        } else {
          hour = int.parse(dateAndTime[3].substring(0, 1));
          minute = int.parse(dateAndTime[3].substring(1, 2));
        }

        dateTimeList = [year, month, day, hour, minute];
        //print(dateTimeList);
        final getEndAt = DateTime(dateTimeList[0], dateTimeList[1],
            dateTimeList[2], dateTimeList[3], dateTimeList[4]);

        final itemGetGetUpTimeString = itemGetMap['getUpTime'] as String;
        dateAndTime = itemGetGetUpTimeString.split('-');
        year = int.parse(dateAndTime[0]);
        month = int.parse(dateAndTime[1]);
        day = int.parse(dateAndTime[2]);
        if (dateAndTime[3].length == 4) {
          hour = int.parse(dateAndTime[3].substring(0, 2));
          minute = int.parse(dateAndTime[3].substring(2, 4));
        } else if (dateAndTime[3].length == 3 &&
            int.parse(dateAndTime[3].substring(0, 2)) > 24) {
          hour = int.parse(dateAndTime[3].substring(0, 1));
          minute = int.parse(dateAndTime[3].substring(1, 3));
        } else if (dateAndTime[3].length == 3) {
          hour = int.parse(dateAndTime[3].substring(0, 1));
          minute = int.parse(dateAndTime[3].substring(1, 3));
        } else if (dateAndTime[3].length == 2) {
          hour = int.parse(dateAndTime[3].substring(0, 1));
          minute = int.parse(dateAndTime[3].substring(1, 2));
        }
        dateTimeList = [year, month, day, hour, minute];
        //print(dateTimeList);

        final getGetUpTime = DateTime(dateTimeList[0], dateTimeList[1],
            dateTimeList[2], dateTimeList[3], dateTimeList[4]);
        final String itemGetMemo;
        if (itemGetMap['memo'] != null) {
          itemGetMemo = itemGetMap['memo'] as String;
        } else {
          itemGetMemo = '';
        }

        final getSceduleItem = Schedule(
            title: itemGetTitle,
            startAt: getStartAt,
            endAt: getEndAt,
            getUpTime: getGetUpTime,
            memo: itemGetMemo);

        scheduleListItem.add(getSceduleItem);
        idList.add(id);
      }
      setState(() {});
    }
  }
}
