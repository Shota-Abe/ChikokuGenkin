import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

  @override
  void initState() {
    //initStateはウィジェット作成時の初期値
    data = [
      _ChartData('月', 0),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: SfCartesianChart(
                title: ChartTitle(text: '貯金額の遷移'), // タイトル
                legend: Legend(isVisible: true), // 凡例の表示

                primaryXAxis: CategoryAxis(),
                primaryYAxis:
                    NumericAxis(minimum: 0, maximum: 150000, interval: 50000),
                tooltipBehavior: _tooltip,
                series: <ChartSeries<_ChartData, String>>[
                  ColumnSeries<_ChartData, String>(
                    dataSource: data,
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y,
                    name: '貯金額',
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    width: 0.2,
                    color: const Color.fromRGBO(8, 142, 255, 1),
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: true), // データ数値の表示
                  )
                ]),
          ),
          DropdownButton(
            style: TextStyle(fontSize: 15.0),
            items: const [
              DropdownMenuItem(
                child: Text('50000'),
                value: '50000',
              ),
              DropdownMenuItem(
                child: Text('60000'),
                value: '60000',
              ),
              DropdownMenuItem(
                child: Text('70000'),
                value: '70000',
              ),
              DropdownMenuItem(
                child: Text('80000'),
                value: '80000',
              ),
            ],
            onChanged: (String? value) {
              setState(() {
                isSelectedItem = value;
              });
            },
            value: isSelectedItem,
          ),
          Text('今月の目標金額：$isSelectedItem 円')
        ],
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
