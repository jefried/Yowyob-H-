import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Model/UserModel.dart';
import 'package:flutter_whatsapp/Model/UserModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDataBase {
  UserDataBase._();

  static final UserDataBase instance = UserDataBase._();
  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE user(number INTEGER PRIMARY KEY, name TEXT, surname TEXT, description TEXT, urlPhoto TEXT)"
        );
      },
      version: 1,
    );
  }

  void insertUser(UserModel user) async {
    final Database db = await database;

    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateUser(UserModel user) async {
    final Database db = await database;
    await db.update("user", user.toMap(),
        where: "number = ?", whereArgs: [user.number]);
  }

  void deleteUser(String number) async {
    final Database db = await database;
    await db.delete("user", where: "number = ?", whereArgs: [number]);
  }

  Future<UserModel> getUser(String number) async{
    final Database db = await database;
    await db.rawQuery("SELECT * FROM user WHERE number = ?", [number]);
  }

  void deleteTable () async {
    final Database db = await database;
    db.delete('user');
  }

  Future<List<UserModel>> users() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user');
    List<UserModel> users = List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });

    return users;
  }
}