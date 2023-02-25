import 'package:calendar_hackathon/model/moneyManagemant.dart';
import 'package:calendar_hackathon/model/schedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  TextEditingController titelContoroller = TextEditingController();
  TextEditingController revenueContoroller = TextEditingController();
  TextEditingController expenditureContoroller = TextEditingController();
  DateTime now = DateTime.now(); //現在の日付と時間を取得
  List<String> weekName = ['日', '月', '火', '水', '木', '金', '土']; //曜日の表示用のリスト
  late PageController controller;
  DateTime firstDay = DateTime(2020, 1, 1); //最初の月
  late DateTime selectedDate; //選択した日付
  late int initialIndex; //ページ遷移数
  int monthDuration = 0;

  DateTime? selectedStartTime;
  DateTime? selectedEndTime;
  DateTime? getUpTime;

  late List<int> yearOption;
  List<int> monthOption = List.generate(12, (index) => index + 1);
  List<int>? dayOption;
  void buildDayOption(DateTime selectedDate) {
    List<int> _list = [];
    for (int i = 1;
        i <=
            DateTime(selectedDate.year, selectedDate.month + 1, 1)
                .subtract(const Duration(days: 1))
                .day;
        i++) {
      _list.add(i);
    }
    dayOption = _list;
  }

  List<int> hourOption = List.generate(24, (index) => index);
  List<int> minuteOption = List.generate(60, (index) => index);

  bool isSettingStartTime = true;

  Map<DateTime, List<Schedule>> scheduleMap = {
    //スケジュール
    /*DateTime(2023, 2, 24): [
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
          memo: ''),
    ]*/
  };

  Map<DateTime, List<Money>> moneyMap = {
    DateTime(2023, 2, 24): [
      Money(revenue: 0, expenditure: 2000),
    ]
  };

  void selectDate(DateTime cacheDate) {
    selectedDate = cacheDate;
    setState(() {});
  }

  @override
  //ページの始まり
  void initState() {
    super.initState();

    yearOption = [now.year];
    for (int i = 1; i < 10; i++) {
      yearOption.add(now.year + i);
    }
    selectedDate = now;
    initialIndex = (now.year - firstDay.year) * 12 +
        (now.month - firstDay.month); //最初の月から何ヶ月経っているか
    controller = PageController(initialPage: initialIndex); //現在の月を最初に表示する
    controller.addListener(() {
      monthDuration = (controller.page! - initialIndex).round();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('yyyy年 M月')
            .format(DateTime(now.year, now.month + monthDuration))), //年と月の表示
        elevation: 1, //曜日と上の年月の表示との影をなくす
      ),
      body: Column(
        children: [
          Container(
            height: 30,
            color: Theme.of(context).primaryColor,
            //曜日を表示する（日曜日始まり）
            child: Row(
              children: weekName
                  .map((e) => Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            e,
                            style: const TextStyle(color: Colors.white), //文字は白色
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          //日付を表示する
          Expanded(child: createCalendarItem()),
          Container(
            height: 50,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: IconButton(
                    splashRadius: 30,
                    onPressed: () async {
                      selectedStartTime = selectedDate;
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return buildAddScheduleDialog();
                          });
                      titelContoroller.clear();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.event_available,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    splashRadius: 30,
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return buildAddmoneyDialog();
                          });
                      titelContoroller.clear();
                      revenueContoroller.clear();
                      expenditureContoroller.clear();
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.savings_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).padding.bottom,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget buildAddScheduleDialog() {
    return StatefulBuilder(builder: (context, setState) {
      return SimpleDialog(
        titlePadding: EdgeInsets.zero,
        title: Column(
          children: [
            Row(
              children: [
                IconButton(
                  splashRadius: 10,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel),
                ),
                Expanded(
                    child: TextField(
                  controller: titelContoroller,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'タイトルを入力'),
                )),
                IconButton(
                  splashRadius: 10,
                  onPressed: () {
                    //スケジュールを追加する処理
                    if (!validationIsOk()) {
                      return;
                    }

                    DateTime checkScheduleTime = DateTime(
                        selectedStartTime!.year,
                        selectedStartTime!.month,
                        selectedStartTime!.day);
                    Schedule newSchedule = Schedule(
                        title: titelContoroller.text,
                        startAt: selectedStartTime!,
                        endAt: selectedEndTime!,
                        getUpTime: getUpTime!,
                        memo: '');
                    if (scheduleMap.containsKey(checkScheduleTime)) {
                      scheduleMap[checkScheduleTime]!.add(newSchedule);
                    } else {
                      scheduleMap[checkScheduleTime] = [newSchedule];
                    }
                    selectedEndTime = null;
                    getUpTime = null;
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(Icons.check_circle),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      buildDayOption(selectedDate);
                      isSettingStartTime = true;
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return buildSelectTimeDialog();
                          });
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(DateFormat('yyyy').format(selectedStartTime!)),
                          Text(DateFormat('MM/dd').format(selectedStartTime!)),
                          Text(DateFormat('HH:mm').format(selectedStartTime!)),
                        ],
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_right),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      buildDayOption(selectedDate);
                      isSettingStartTime = false;
                      selectedEndTime ??= selectedStartTime;
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return buildSelectTimeDialog();
                          });
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(selectedEndTime == null
                              ? '----'
                              : DateFormat('yyyy').format(selectedEndTime!)),
                          Text(selectedEndTime == null
                              ? '--/--'
                              : DateFormat('MM/dd').format(selectedEndTime!)),
                          Text(selectedEndTime == null
                              ? '--:--'
                              : DateFormat('HH:mm').format(selectedEndTime!)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      buildDayOption(selectedDate);
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return buildGetUpTimeDialog();
                          });
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.topCenter,
                      height: 80,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('起床時間', textAlign: TextAlign.left),
                            Text(getUpTime == null
                                ? '--:--'
                                : DateFormat('HH:mm').format(getUpTime!))
                          ]),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  Widget buildAddmoneyDialog() {
    return StatefulBuilder(builder: (context, setState) {
      return SimpleDialog(
        titlePadding: EdgeInsets.zero,
        title: Column(
          children: [
            Row(
              children: [
                IconButton(
                  splashRadius: 10,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel),
                ),
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: Text(DateFormat('MM/dd').format(selectedDate)))),
                IconButton(
                  splashRadius: 10,
                  onPressed: () {
                    //歳入歳出を追加する処理
                    if (!(revenueContoroller.text == null)) {
                      revenueContoroller.text = '0';
                    }
                    if (!(expenditureContoroller.text == null)) {
                      expenditureContoroller.text = '0';
                    }

                    DateTime checkScheduleTime = DateTime(selectedDate.year,
                        selectedDate.month, selectedDate.day);
                    Money newmoneyManager = Money(
                        revenue: int.parse(revenueContoroller.text),
                        expenditure: int.parse(expenditureContoroller.text));

                    if (moneyMap.containsKey(checkScheduleTime)) {
                      moneyMap[checkScheduleTime]!.add(newmoneyManager);
                    } else {
                      moneyMap[checkScheduleTime] = [newmoneyManager];
                    }
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(Icons.check_circle),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.right,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: revenueContoroller,
                    style: const TextStyle(fontSize: 25),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                        labelText: '収入'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  textAlign: TextAlign.right,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: expenditureContoroller,
                  style: const TextStyle(fontSize: 25),
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: '0', labelText: '支出'),
                )),
              ],
            )
          ],
        ),
      );
    });
  }

  Widget buildGetUpTimeDialog() {
    getUpTime = DateTime(selectedStartTime!.year, selectedStartTime!.month,
        selectedStartTime!.day, 6, 0);
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: StatefulBuilder(builder: (context, setState) {
        return SimpleDialog(
          titlePadding: const EdgeInsets.only(top: 30),
          title: Column(children: [
            Row(
              children: [
                IconButton(
                  splashRadius: 10,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.cancel),
                ),
                const Expanded(
                    child: Text('起床時刻を選択', textAlign: TextAlign.center)),
                IconButton(
                  splashRadius: 10,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check_circle),
                ),
              ],
            ),
            Container(
                height: 150,
                child: Row(children: [
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 35,
                      onSelectedItemChanged: (int index) {
                        getUpTime = DateTime(
                            selectedStartTime!.year,
                            selectedStartTime!.month,
                            selectedStartTime!.day,
                            hourOption[index],
                            getUpTime!.minute);
                      },
                      scrollController: FixedExtentScrollController(
                          initialItem: hourOption.indexOf(getUpTime!.hour)),
                      children: hourOption
                          .map((e) => Container(
                                alignment: Alignment.center,
                                height: 35,
                                child: Text('$e'),
                              ))
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 35,
                      onSelectedItemChanged: (int index) {
                        getUpTime = DateTime(
                            selectedStartTime!.year,
                            selectedStartTime!.month,
                            selectedStartTime!.day,
                            getUpTime!.hour,
                            minuteOption[index]);
                      },
                      scrollController: FixedExtentScrollController(
                          initialItem: minuteOption.indexOf(getUpTime!.minute)),
                      children: minuteOption
                          .map((e) => Container(
                                alignment: Alignment.center,
                                height: 35,
                                child: Text('$e'),
                              ))
                          .toList(),
                    ),
                  ),
                ]))
          ]),
        );
      }),
    );
  }

  Widget buildSelectTimeDialog() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: StatefulBuilder(builder: (context, setState) {
        return SimpleDialog(
          titlePadding: EdgeInsets.zero,
          title: Column(children: [
            Row(
              children: [
                IconButton(
                  splashRadius: 10,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.cancel),
                ),
                const Expanded(
                    child: Text('日時を選択', textAlign: TextAlign.center)),
                IconButton(
                  splashRadius: 10,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check_circle),
                ),
              ],
            ),
            Container(
              height: 150,
              child: Row(children: [
                Expanded(
                  flex: 2,
                  child: CupertinoPicker(
                    itemExtent: 35,
                    onSelectedItemChanged: (int index) {
                      if (isSettingStartTime) {
                        selectedStartTime = DateTime(
                            yearOption[index],
                            selectedStartTime!.month,
                            selectedStartTime!.day,
                            selectedStartTime!.hour,
                            selectedStartTime!.minute);
                      } else {
                        selectedEndTime = DateTime(
                            yearOption[index],
                            selectedEndTime!.month,
                            selectedEndTime!.day,
                            selectedEndTime!.hour,
                            selectedEndTime!.minute);
                      }
                    },
                    scrollController: FixedExtentScrollController(
                        initialItem: yearOption.indexOf(isSettingStartTime
                            ? selectedStartTime!.year
                            : selectedEndTime!.year)),
                    children: yearOption
                        .map((e) => Container(
                              alignment: Alignment.center,
                              height: 35,
                              child: Text('$e'),
                            ))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 35,
                    onSelectedItemChanged: (int index) {
                      if (isSettingStartTime) {
                        selectedStartTime = DateTime(
                            selectedStartTime!.year,
                            monthOption[index],
                            selectedStartTime!.day,
                            selectedStartTime!.hour,
                            selectedStartTime!.minute);
                        buildDayOption(selectedStartTime!);
                      } else {
                        selectedEndTime = DateTime(
                            selectedEndTime!.year,
                            monthOption[index],
                            selectedEndTime!.day,
                            selectedEndTime!.hour,
                            selectedEndTime!.minute);
                        buildDayOption(selectedStartTime!);
                      }
                      setState(() {});
                    },
                    scrollController: FixedExtentScrollController(
                        initialItem: monthOption.indexOf(isSettingStartTime
                            ? selectedStartTime!.month
                            : selectedEndTime!.month)),
                    children: monthOption
                        .map((e) => Container(
                              alignment: Alignment.center,
                              height: 35,
                              child: Text('$e'),
                            ))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 35,
                    onSelectedItemChanged: (int index) {
                      if (isSettingStartTime) {
                        selectedStartTime = DateTime(
                            selectedStartTime!.year,
                            selectedStartTime!.month,
                            dayOption![index],
                            selectedStartTime!.hour,
                            selectedStartTime!.minute);
                      } else {
                        selectedEndTime = DateTime(
                            selectedEndTime!.year,
                            selectedEndTime!.month,
                            dayOption![index],
                            selectedEndTime!.hour,
                            selectedEndTime!.minute);
                      }
                    },
                    scrollController: FixedExtentScrollController(
                        initialItem: dayOption!.indexOf(isSettingStartTime
                            ? selectedStartTime!.day
                            : selectedEndTime!.day)),
                    children: dayOption!
                        .map((e) => Container(
                              alignment: Alignment.center,
                              height: 35,
                              child: Text('$e'),
                            ))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 35,
                    onSelectedItemChanged: (int index) {
                      if (isSettingStartTime) {
                        selectedStartTime = DateTime(
                            selectedStartTime!.year,
                            selectedStartTime!.month,
                            selectedStartTime!.day,
                            hourOption[index],
                            selectedStartTime!.minute);
                      } else {
                        selectedEndTime = DateTime(
                            selectedEndTime!.year,
                            selectedEndTime!.month,
                            selectedEndTime!.day,
                            hourOption[index],
                            selectedEndTime!.minute);
                      }
                    },
                    scrollController: FixedExtentScrollController(
                        initialItem: hourOption.indexOf(isSettingStartTime
                            ? selectedStartTime!.hour
                            : selectedEndTime!.hour)),
                    children: hourOption
                        .map((e) => Container(
                              alignment: Alignment.center,
                              height: 35,
                              child: Text('$e'),
                            ))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 35,
                    onSelectedItemChanged: (int index) {
                      if (isSettingStartTime) {
                        selectedStartTime = DateTime(
                          selectedStartTime!.year,
                          selectedStartTime!.month,
                          selectedStartTime!.day,
                          selectedStartTime!.hour,
                          minuteOption[index],
                        );
                      } else {
                        selectedEndTime = DateTime(
                          selectedEndTime!.year,
                          selectedEndTime!.month,
                          selectedEndTime!.day,
                          selectedEndTime!.hour,
                          minuteOption[index],
                        );
                      }
                    },
                    scrollController: FixedExtentScrollController(
                        initialItem: minuteOption.indexOf(isSettingStartTime
                            ? selectedStartTime!.minute
                            : selectedEndTime!.minute)),
                    children: minuteOption
                        .map((e) => Container(
                              alignment: Alignment.center,
                              height: 35,
                              child: Text('$e'),
                            ))
                        .toList(),
                  ),
                ),
              ]),
            )
          ]),
        );
      }),
    );
  }

  bool validationIsOk() {
    if (selectedEndTime == null) {
      print('終了時刻が入力されていません。');
      return false;
    } else if (selectedStartTime!.isAfter(selectedEndTime!)) {
      print('開始日時より終了日時の方が先になっています。');
      return false;
    } else if (getUpTime == null) {
      print('起床時間が設定されていません。');
      return false;
    } else {
      return true;
    }
  }

  Future<void> editSchedule(
      {required int index, required Schedule selectedSchedule}) async {
    selectedStartTime = selectedSchedule.startAt;
    selectedEndTime = selectedSchedule.endAt;
    getUpTime = selectedSchedule.getUpTime;
    titelContoroller.text = selectedSchedule.title;
    final result = await showDialog(
        context: context,
        builder: (context) {
          return buildAddScheduleDialog();
        });

    if (result == true) {
      scheduleMap[DateTime(selectedSchedule.startAt.year,
              selectedSchedule.startAt.month, selectedSchedule.startAt.day)]!
          .removeAt(index);
    }

    setState(() {});
  }

  void deleteSchedule(
      {required int index, required Schedule selectedSchedule}) {
    scheduleMap[DateTime(
      selectedSchedule.startAt.year,
      selectedSchedule.startAt.month,
      selectedSchedule.startAt.day,
    )]!
        .removeAt(index);
    setState(() {});
  }

  //日付を並べて表示するための
  Widget createCalendarItem() {
    return PageView.builder(
        controller: controller,
        itemBuilder: (context, index) {
          //ページ遷移
          List<Widget> _list = [];
          List<Widget> _listCache = [];

          DateTime date = DateTime(
              now.year, now.month + index - initialIndex, 1); //現在の月の初日を取得
          int monthLastDay = DateTime(now.year, date.month + 1, 1)
              .subtract(const Duration(days: 1))
              .day; //現在の月の最終日を取得

          for (int i = 0; i < monthLastDay; i++) {
            _listCache.add(_CalenderItem(
              day: i + 1,
              now: now,
              cacheDate: DateTime(date.year, date.month, i + 1),
              scheduleList: scheduleMap[DateTime(date.year, date.month, i + 1)],
              selectedDate: selectedDate,
              selectDate: selectDate,
              editSchedule: editSchedule,
              deleteSchedule: deleteSchedule,
              moneyList: moneyMap[DateTime(date.year, date.month, i + 1)],
            ));
            int repeatNumber = 7 - _listCache.length;
            if (date.add(Duration(days: i)).weekday == 6) {
              //月曜日が0土曜日で折り返す
              if (i < 7) {
                //
                _listCache.insertAll(
                    0,
                    List.generate(
                        repeatNumber,
                        (index) => Expanded(
                            child: Container(
                                color: Colors.black.withOpacity(0.1)))));
              }
              //七日で区切って次の行に行かせる
              _list.add(Expanded(child: Row(children: _listCache)));
              _listCache = [];
            } else if (i == monthLastDay - 1) {
              //余っている日を次の行に送る
              _listCache.addAll(List.generate(
                  repeatNumber,
                  (index) => Expanded(
                      child: Container(color: Colors.black.withOpacity(0.1)))));
              _list.add(Expanded(child: Row(children: _listCache)));
            }
          }

          //縦に並べて返す
          return Column(
            children: _list,
          );
        });
  }
}

class _CalenderItem extends StatelessWidget {
  final int day;
  final DateTime now;
  final DateTime cacheDate;
  final DateTime selectedDate;
  final List<Schedule>? scheduleList;
  final Function selectDate;
  final Function editSchedule;
  final Function deleteSchedule;
  final List<Money>? moneyList;
  const _CalenderItem(
      {required this.day,
      required this.now,
      required this.cacheDate,
      required this.selectedDate,
      required this.scheduleList,
      required this.selectDate,
      required this.editSchedule,
      required this.deleteSchedule,
      required this.moneyList,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = (selectedDate.difference(cacheDate).inDays == 0) &&
        (selectedDate.day == cacheDate.day);
    bool isToday = (now.difference(cacheDate).inDays == 0) &&
        (now.day == cacheDate.day); //今日の日付とキャッシュの日付が同じかどうか判断する変数

    return Expanded(
      child: GestureDetector(
        onTap: () {
          selectDate(cacheDate);
        },
        child: Container(
          decoration: BoxDecoration(
              color: isSelected ? Colors.black.withOpacity(0.1) : null,
              border: Border.all(color: Colors.grey)), //boxの枠線を灰色にする
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 20,
                  height: 20,
                  color: isToday
                      ? Theme.of(context)
                          .primaryColor
                          .withOpacity(0.8) //今日の日付だけ色をつける
                      : null,
                  alignment: Alignment.center,
                  child: Text(
                    '$day',
                    style: TextStyle(
                        color: isToday ? Colors.white : null), //今日の日付の文字の色を白にする
                  )),
              scheduleList == null
                  ? Container()
                  : Column(
                      //スケジュールのカレンダー上の表示
                      children: scheduleList!
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
                                                deleteSchedule(
                                                    index: e.key,
                                                    selectedSchedule: e.value);
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
                                  padding:
                                      const EdgeInsets.only(left: 2, right: 2),
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
              /*moneyList == null
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: moneyList!
                          .map((e) => Container(
                                width: double.infinity,
                                height: 20,
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.only(
                                    left: 2, right: 2, top: 2),
                                padding:
                                    const EdgeInsets.only(left: 2, right: 2),
                                color: Colors.green.withOpacity(0.8),
                                child: Text(
                                  e.title,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                    )*/
            ],
          ),
        ),
      ),
    );
  }
}
