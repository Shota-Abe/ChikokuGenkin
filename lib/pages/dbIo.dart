import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
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
}
