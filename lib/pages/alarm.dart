import 'dart:async';

import 'package:calendar_hackathon/model/dbIo.dart';
import 'package:calendar_hackathon/model/moneyManagemant.dart';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/services.dart';

class AlarmView extends StatefulWidget {
  @override
  _AlarmViewState createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  final _focusNode = FocusNode();
  final _focusNode2 = FocusNode();
  bool _isKeyboardVisible = false;
  int revenue = 0;
  int expenditure = 0;
  String _revenueString = "";
  String _expenditureString = "";

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
    _focusNode2.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _focusNode2.removeListener(_onFocusChanged);
    _focusNode2.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      if (_focusNode.hasFocus || _focusNode2.hasFocus) {
        _isKeyboardVisible = true;
      }
      if (!_focusNode.hasFocus && !_focusNode2.hasFocus) {
        _isKeyboardVisible = false;
      }
    });
  }

  Future<void> save(Money money) async {
    final id = await MoneyDb.createMoney(money);
    print(await MoneyDb.getMoney(id));
  }

  Future<void> onStopButtonTapped() async {
    final bool hasAlarm = await Alarm.hasAlarm();
    if (hasAlarm) {
      await Alarm.stop();
    }
    await save(Money(
        revenue: revenue, expenditure: expenditure, date: DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アラーム'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              focusNode: _focusNode,
              decoration: InputDecoration(hintText: '収入を入力'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              onChanged: (String value) {
                revenue = int.tryParse(value) ?? 0; // 入力された文字列をint型に変換して代入する
                setState(() {
                  _revenueString = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              focusNode: _focusNode2,
              decoration: InputDecoration(hintText: '支出を入力'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              onChanged: (String value) {
                expenditure =
                    int.tryParse(value) ?? 0; // 入力された文字列をint型に変換して代入する
                setState(() {
                  _expenditureString = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: (_revenueString == "" || _expenditureString == "")
                  ? null
                  : onStopButtonTapped,
              child: const Text("ストップ"),
            ),
            // ElevatedButton(
            //     onPressed: () async {
            //       await Alarm.stop();
            //     },
            //     child: const Text("ストップ")),
            const Spacer(),
            (_isKeyboardVisible)
                ? Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: const Text("完了"),
                      ),
                    ],
                  )
                : const Spacer()
          ],
        ),
      ),
    );
  }
}
