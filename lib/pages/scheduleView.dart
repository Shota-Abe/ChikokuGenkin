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
        title: const Text("スケジュール"),
      ),
      body: ListView.builder(
        itemCount: scheduleListItem.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListTile(
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
                      TextButton.icon(
                        onPressed: () async {
                          await scheduleDb.deleteSchedule(idList[index]);
                          getFirstSchedule();
                          setState(() {});
                        },
                        label: const Text('削除'),
                        icon: const Icon(Icons.delete, size: 20),
                        style:
                            TextButton.styleFrom(alignment: Alignment.topLeft),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 0),
            ],
          );
        },
      ),
    );
  }

  DateTime getItems(String getItemString) {
    int hour;
    int minute;
    List<String> dateAndTime = getItemString.split('-');
    int year = int.parse(dateAndTime[0]);
    int month = int.parse(dateAndTime[1]);
    int day = int.parse(dateAndTime[2]);
    if (dateAndTime[3].length == 4) {
      hour = int.parse(dateAndTime[3].substring(0, 2));
      minute = int.parse(dateAndTime[3].substring(2, 4));
    } else if (dateAndTime[3].length == 3 &&
        int.parse(dateAndTime[3].substring(0, 2)) > 24) {
      hour = int.parse(dateAndTime[3].substring(0, 1));
      minute = int.parse(dateAndTime[3].substring(1, 3));
    } else if (dateAndTime[3].length == 3) {
      hour = int.parse(dateAndTime[3].substring(0, 2));
      minute = int.parse(dateAndTime[3].substring(2, 3));
    } else if (dateAndTime[3].length == 2 && int.parse(dateAndTime[3]) != 10) {
      hour = int.parse(dateAndTime[3].substring(0, 1));
      minute = int.parse(dateAndTime[3].substring(1, 2));
    } else {
      hour = int.parse(dateAndTime[3]);
      minute = 0;
    }
    List<int> dateTimeList = [year, month, day, hour, minute];
    //print(dateTimeList);
    final getItem = DateTime(dateTimeList[0], dateTimeList[1], dateTimeList[2],
        dateTimeList[3], dateTimeList[4]);

    return getItem;
  }

  Future<void> getFirstSchedule() async {
    scheduleListItem.clear();
    final items = (await scheduleDb.getAllSchedule());
    //print(items);

    int id;

    for (int i = 0; i < items.length; i++) {
      id = items[i]['id'];
      final itemList = await scheduleDb.getSchedule(id);
      final itemGetMap = itemList[0];
      //print(itemGetMap);
      // ignore: unnecessary_null_comparison
      if (itemGetMap != null) {
        final itemGetTitle = itemGetMap['title'] as String;
        final getStartAt = getItems(itemGetMap['startAt'] as String);
        final getEndAt = getItems(itemGetMap['endAt'] as String);
        final getGetUpTime = getItems(itemGetMap['getUpTime'] as String);
        final String itemGetMemo = itemGetMap['memo'] as String;

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
