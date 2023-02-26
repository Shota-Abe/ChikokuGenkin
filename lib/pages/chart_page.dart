import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/services.dart';
import 'package:calendar_hackathon/model/targetSpendIo.dart';
import 'package:calendar_hackathon/model/dbIo.dart';
import 'package:calendar_hackathon/model/savingsIo.dart';
import 'package:intl/intl.dart';

class ChartPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ChartPage({Key? key}) : super(key: key);

  @override
  ChartPageState createState() => ChartPageState();
}

class ChartPageState extends State<ChartPage> with TickerProviderStateMixin {
  List<_ChartData> data = [];
  late TooltipBehavior _tooltip;
  final MoneyDb moneyDb = MoneyDb();
  final targetSpendIo tSIo = targetSpendIo();
  final savingsManagement saveMng = savingsManagement();
  String _editText = '';
  String _alertText = '';
  int _savingMoney = 0;
  DateTime now = DateTime.now();

  static const List<Tab> tabs = <Tab>[
    Tab(text: '貯金額の遷移'),
    Tab(text: '過去の貯金履歴'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    Future(() async {
      String targetSpend = '${await tSIo.getTargetSpend()}';
      int savingTmp = await savingsManagement.getSavings();
      _savingMoney = savingTmp;

      int tmp = _savingMoney;
      print(tmp);
      for (int i = 0; i < 7; i++) {
        data.insert(
            0,
            _ChartData(
                '${DateFormat('M/d').format(DateTime(now.year, now.month, now.day - i) /*now.add(Duration(days: -i))*/)}',
                (tmp).toDouble()));
        tmp -= await moneyDb
            .getSumDayMoney(DateTime(now.year, now.month, now.day - i));
        print(
            '${await moneyDb.getSumDayMoney(DateTime(now.year, now.month, now.day - i))} ; $tmp');
      }
      setState(() {
        _alertText = targetSpend;
      });
    });
    //initStateはウィジェット作成時の初期値
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    now = DateTime.now();
    return Scaffold(
        appBar: AppBar(
          title: const Text('貯金'),
          bottom: TabBar(controller: _tabController, tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.bar_chart),
            ),
            Tab(
              icon: Icon(Icons.currency_yen),
            )
          ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: SfCartesianChart(
                          title: ChartTitle(
                              text: '貯金額の遷移',
                              textStyle: TextStyle(fontSize: 16.0)), // タイトル
                          legend: Legend(isVisible: true), // 凡例の表示

                          primaryXAxis: CategoryAxis(),
                          primaryYAxis: NumericAxis(
                              minimum: 0, maximum: 150000, interval: 50000),
                          tooltipBehavior: _tooltip,
                          series: <ChartSeries<_ChartData, String>>[
                            ColumnSeries<_ChartData, String>(
                              dataSource: data,
                              xValueMapper: (_ChartData data, _) => data.x,
                              yValueMapper: (_ChartData data, _) => data.y,
                              name: '貯\n金\n額',
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              width: 0.2,
                              color: Colors.blue,
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: true), // データ数値の表示
                            )
                          ]),
                    ),
                  ),
                  Row(
                    // button
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Text('今月の目標金額： $_alertText円',
                            style: TextStyle(fontSize: 16.0)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20, bottom: 20),
                        child: SizedBox(
                          height: 40,
                          width: 150,
                          child: FilledButton.tonal(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text('目標金額を設定してください'),
                                        content: TextField(
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                10),
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _editText = value;
                                            });
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('キャンセル'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await tSIo.setTargetSpend(
                                                  int.tryParse(_editText) ?? 0);
                                              setState(() {
                                                _alertText = _editText;
                                              });
                                              print(
                                                  await tSIo.getTargetSpend());
                                              Navigator.pop(context);
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      ));
                            },
                            child: Text('目標金額を設定する',
                                style: TextStyle(fontSize: 10.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 20),
                        child: SizedBox(
                          height: 40,
                          width: 150,
                          child: FilledButton(
                            onPressed: buttonPressed1,
                            child: const Text(
                              '使用金額を確認する',
                              style: TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100,
                                  fontFamily: "Roboto"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(' 収支の履歴', style: TextStyle(fontSize: 32.0)),
                  ),
                  SizedBox(
                    height: 400,
                    width: 500,
                    child: Scrollbar(
                      thickness: 12,
                      isAlwaysShown: true,
                      radius: const Radius.circular(20),
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 40),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 30),
                        itemCount: 12,
                        itemBuilder: (context, index) => _buildCard(index + 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  Widget _buildCard(int index) {
    List<DateTime> twelveMonth = [DateTime(now.year, now.month)];
    for (int i = 1; i < 12; i++) {
      twelveMonth.add(DateTime(
          now.year + ((now.month - i - 1) / 12).ceil(), now.month - i));
    }

    return Card(
        child: Container(
      margin: const EdgeInsets.all(10),
      child: FutureBuilder(
          future: moneyDb.getSumMonthMoney(
              DateFormat('yyyy').format(twelveMonth[index - 1]),
              DateFormat('MM').format(twelveMonth[index - 1])),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              return Text(
                  '${twelveMonth[index - 1].month}月　　　　　　　　　　　　　　　${snapshot.data}円');
            } else {
              return Text("データが存在しません");
            }
          }),
    ));
  }

  void buttonPressed1() async {
    int expenditure = await moneyDb.getSumMonthExpenditure(
        DateFormat('yyyy').format(now), DateFormat('MM').format(now));
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(title: Text('あなたの使用金額は\n$expenditure円です')),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
