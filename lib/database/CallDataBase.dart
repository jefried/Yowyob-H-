import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Model/CallModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CallDataBase {
  CallDataBase._();

  static final CallDataBase instance = CallDataBase._();
  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'call_database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE call(numSender TEXT, numReceiver TEXT, date TEXT, urlPhotoSender TEXT, urlPhotoReceiver TEXT, taken INTEGER, PRIMARY KEY (numSender, numReceiver, date))"
        );
      },
      version: 1,
    );
  }

  void insertCall(CallModel callModel) async {
    final Database db = await database;

    await db.insert(
      'call',
      callModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateCall(CallModel callModel) async {
    final Database db = await database;
    await db.rawQuery('UPDATE call SET urlPhotoSender = ?, urlPhotoReceiver = ?, taken = ? WHERE numSender = ? AND numReceiver = ? AND date = ?', [callModel.urlPhotoSender, callModel.urlPhotoReceiver, callModel.taken, callModel.numSender, callModel.numReceiver, callModel.date.toIso8601String()]);
  }

  void deleteCall(String numSender, String numReceiver, DateTime date) async {
    final Database db = await database;
    db.rawQuery('DELETE FROM call WHERE numSender = ? AND numReceiver = ? AND date = ?', [numSender, numReceiver, date.toIso8601String()]);
  }

  Future<List<CallModel>> calls() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('call');
    List<CallModel> calls = List.generate(maps.length, (i) {
      return CallModel.fromMap(maps[i]);
    });

    return calls;
  }
}