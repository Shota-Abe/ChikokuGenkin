import 'package:calendar_hackathon/model/schedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class scheduleView extends StatefulWidget {
  const scheduleView({Key? key}) : super(key: key);

  @override
  State<scheduleView> createState() => _scheduleViewState();
}

class _scheduleViewState extends State<scheduleView> {
  late DateTime selectedList;

  List<String> titelList = ['suchedule1', 'suchedule2', 'suchedule3'];

  final List<Schedule> scheduleListItem = [
    //スケジュール
    Schedule(
        title: 'ハッカソン',
        startAt: DateTime(2023, 2, 24, 10),
        endAt: DateTime(2023, 2, 26, 20),
        getUpTime: DateTime(2023, 2, 24, 6),
        memo: ''),
    Schedule(
        title: 'プログラミング',
        startAt: DateTime(2023, 2, 24, 10),
        endAt: DateTime(2023, 2, 26, 20),
        getUpTime: DateTime(2023, 2, 24, 6),
        memo: '')
  ]; //schefuleMapをそのまま持ってきたい。

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
                      onPressed: () {},
                      icon: const Icon(Icons.edit),
                      iconSize: 20,
                    ),
                    IconButton(
                      splashRadius: 10,
                      onPressed: () {},
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

  /* Widget createScheduleItem() {
    return ListView.builder(
      itemCount: scheduleListItem.length,
      itemBuilder: (context, index) {
        List<Widget> scheduleList = [];

        for (int i = 0; i < 2; i++) {
          scheduleList.add(_scheduleItem(selectedList: selectedList));
        }
        return Container(
          child: ListTile(
            title: Text(scheduleListItem[index]['title']),
            subtitle: Text('開始時間 ${scheduleListItem[index]['startAt']}'),
          ),
        );
      },
    );
  }*/
}


/*class _scheduleItem extends StatelessWidget {
  final DateTime selectedList;
  const _scheduleItem({required this.selectedList});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
            color: Colors.green, border: Border.all(color: Colors.grey)),
        child: Column(children: [
          scheduleList == null
              ? Container()
              : Column(
                  //スケジュールのカレンダー上の表示
                  children: scheduleList
                      .asMap()
                      .entries
                      .map((e) => GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(e.value.title),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: const Text('編集'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            editSchedule(
                                                index: e.key,
                                                selectedSchedule: e.value);
                                          },
                                        ),
                                        CupertinoDialogAction(
                                          child: const Text('削除'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            scheduleList[DateTime(
                                              selectedSchedule.startAt.year,
                                              selectedSchedule.startAt.month,
                                              selectedSchedule.startAt.day,
                                            )]!
                                                .removeAt(index);
                                            setState(() {});
                                          },
                                          isDestructiveAction: true,
                                        ),
                                        CupertinoDialogAction(
                                          child: const Text('キャンセル'),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              width: double.infinity,
                              height: 20,
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(
                                  left: 2, right: 2, top: 2),
                              padding: const EdgeInsets.only(left: 2, right: 2),
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.8),
                              child: Text(
                                e.value.title,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ))
                      .toList()),
        ]),
      ),
    ));
  }
}*/
