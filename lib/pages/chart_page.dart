import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/services.dart';

class ChartPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ChartPage({Key? key}) : super(key: key);

  @override
  ChartPageState createState() => ChartPageState();
}

class ChartPageState extends State<ChartPage> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  String? isSelectedItem = '50000';
  final now = DateTime.now();
  var _editText = '';
  var _alertText = '';

  @override
  void initState() {
    //initStateはウィジェット作成時の初期値
    data = [
      _ChartData('月', 100000),
      _ChartData('火', 0),
      _ChartData('水', 0),
      _ChartData('木', 0),
      _ChartData('金', 0),
      _ChartData('土', 0),
      _ChartData('日', 0),
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('貯金'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                // graph
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
                        color: Colors.green,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true), // データ数値の表示
                      )
                    ]),
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
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title: Text('目標金額を設定してください'),
                                    content: TextField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                        FilteringTextInputFormatter.digitsOnly,
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
                                        onPressed: () {
                                          setState(() {
                                            _alertText = _editText;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ));
                        },
                        child:
                            Text('目標金額を設定する', style: TextStyle(fontSize: 10.0)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: SizedBox(
                      height: 40,
                      width: 150,
                      child: ElevatedButton(
                        onPressed: buttonPressed1,
                        child: const Text(
                          '貯金額を確認する',
                          style: TextStyle(
                              fontSize: 10.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w100,
                              fontFamily: "Roboto"),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 200,
                width: 500,
                child: Scrollbar(
                  thickness: 12,
                  isAlwaysShown: true,
                  radius: const Radius.circular(20),
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 40),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemCount: 30,
                    itemBuilder: (context, index) => _buildCard(index + 1),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  @override
  Widget _buildCard(int index) {
    return Card(
        child: Container(
      margin: const EdgeInsets.all(10),
      child: Text(
        ' 　年　月　　　　　　　　　円',
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    ));
  }

  void buttonPressed1() {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          const AlertDialog(title: Text('あなたの貯金額は円です')),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
