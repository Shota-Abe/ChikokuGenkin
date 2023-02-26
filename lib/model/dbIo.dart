import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:calendar_hackathon/model/moneyManagemant.dart';
import 'package:calendar_hackathon/model/schedule.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:intl/intl.dart';

class scheduleDb {
  static Future<void> createTable(sql.Database schDb) async {
    await schDb.execute('''CREATE TABLE schedule(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        startAt TEXT,
        endAt TEXT,
        getUpTime TEXT,
        memo TEXT
      )
    ''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'scheduleDb.db',
      version: 1,
      onCreate: (sql.Database schDb, int version) async {
        await createTable(schDb);
      },
    );
  }

  static Future<int> createSchedule(Schedule sch) async {
    final schDb = await scheduleDb.db();

    final data = {
      'title': sch.title,
      'startAt': DateFormat('yyyy-MM-dd-Hm').format(sch.startAt),
      'endAt': DateFormat('yyyy-MM-dd-Hm').format(sch.endAt),
      'getUpTime': DateFormat('yyyy-MM-dd-Hm').format(sch.getUpTime),
      'memo': sch.memo
    };

    final id = await schDb.insert('schedule', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllSchedule() async {
    final schDb = await scheduleDb.db();
    return schDb.query('schedule', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getSchedule(int id) async {
    final schDb = await scheduleDb.db();
    return schDb.query('schedule', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<int> updateSchedule(int id, Schedule sch) async {
    final schDb = await scheduleDb.db();

    final data = {
      'title': sch.title,
      'startAt': DateFormat('yyyy-MM-dd-Hm').format(sch.startAt),
      'endAt': DateFormat('yyyy-MM-dd-Hm').format(sch.endAt),
      'getUpTime': DateFormat('yyyy-MM-dd-Hm').format(sch.getUpTime),
      'memo': sch.memo
    };

    final result =
        await schDb.update('schedule', data, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  static Future<void> deleteSchedule(int id) async {
    final schDb = await scheduleDb.db();
    try {
      await schDb.delete('schedule', where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  // static Future<DateTime?> getNextGetUpTime() async {
  //   final schDb = await scheduleDb.db();
  //   final now = DateTime.now();
  //   final result = await schDb.rawQuery(
  //     '''
  //     SELECT getUpTime FROM schedule
  //     WHERE getUpTime > ?
  //     ORDER BY getUpTime ASC
  //     LIMIT 1
  //   ''',
  //     // [DateFormat('yyyy-MM-dd-Hm').format(now)],
  //    [now.toIso8601String()], // ISO 8601形式で渡す
  //   );
  //   if (result.isEmpty) return null;
  //   final getUpTimeStr = result[0]['getUpTime'] as String;
  //   return DateFormat('yyyy-MM-dd-Hm').parse(getUpTimeStr);
  // }

//   static Future<DateTime?> getNextGetUpTime() async {
//   final schDb = await scheduleDb.db();
//   final now = DateTime.now();
//   final today = DateTime(now.year, now.month, now.day, now.minute); // 今日の日付を取得する
//   final result = await schDb.rawQuery(
//     '''
//       SELECT getUpTime FROM schedule
//       WHERE getUpTime > ?
//       ORDER BY getUpTime ASC
//       LIMIT 1
//     ''',
//     [today.toIso8601String()], // ISO 8601形式で渡す
//   );
//   if (result.isEmpty) return null;
//   final getUpTimeStr = result[0]['getUpTime'] as String;
//   return DateFormat('yyyy-MM-dd-Hm').parse(getUpTimeStr);
// }

  static Future<Map<String, dynamic>?> getNextSchedule() async {
    final schDb = await scheduleDb.db();
    final now = DateTime.now();
    final result = await schDb.rawQuery(
      '''
        SELECT * FROM schedule 
        WHERE getUpTime > ? 
        ORDER BY getUpTime ASC 
        LIMIT 1
      ''',
      [DateFormat('yyyy-MM-dd-Hm').format(now)],
    );
    if (result.isEmpty) return null;
    return result[0];
  }
}

class MoneyDb {
  static Future<void> createTable(sql.Database moneyDb) async {
    await moneyDb.execute('''CREATE TABLE money(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        revenue INTEGER,
        expenditure INTEGER,
        date TEXT
      )
    ''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'moneyDb.db',
      version: 2,
      onCreate: (sql.Database moneyDb, int version) async {
        await createTable(moneyDb);
      },
    );
  }

  static Future<int> createMoney(Money money) async {
    final moneyDb = await MoneyDb.db();

    final data = {
      'revenue': money.revenue,
      'expenditure': money.expenditure,
      'date': DateFormat('yyyyMMdd').format(money.date)
    };

    final id = await moneyDb.insert('money', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllMoney() async {
    final moneyDb = await MoneyDb.db();
    return moneyDb.query('money', orderBy: 'id');
  }

  static Future<List<Map<String, dynamic>>> getMoney(int id) async {
    final moneyDb = await MoneyDb.db();
    return moneyDb.query('money', where: 'id = ?', whereArgs: [id], limit: 1);
  }

  static Future<int> updateMoney(int id, Money money) async {
    final moneyDb = await MoneyDb.db();

    final data = {
      'revenue': money.revenue,
      'expenditure': money.expenditure,
      'date': DateFormat('yyyy-MM-dd').format(money.date)
    };

    final result =
        await moneyDb.update('money', data, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  static Future<void> deleteMoney(int id) async {
    final moneyDb = await MoneyDb.db();
    try {
      await moneyDb.delete('money', where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
