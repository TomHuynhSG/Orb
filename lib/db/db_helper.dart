import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:orbit/models/task.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = 'tasks';

  static Future<void> initDb() async {
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE $_tableName("
                "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                "title STRING, note TEXT, date STRING, "
                "startTime STRING, endTime STRING, "
                "remind INTEGER, repeat STRING, "
                "color INTEGER, "
                "isCompleted INTEGER)",
          );
        },
      );
    } catch (e) {
      
      print('error $e');
    }
  }

  static Future<int> insert(Task task) async {
    return await _db!.insert(_tableName, task.toJson());
  }
  static Future<int> delete(Task task) async =>
      await _db!.delete(_tableName, where: 'id = ?',
          whereArgs: [task.id]);

  static Future<List<Map<String, dynamic>>> query() async {
    return _db!.query(_tableName);
  }
  static Future<int> update(int id) async {
    return await _db!.rawUpdate('''
    UPDATE tasks   
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }
}
