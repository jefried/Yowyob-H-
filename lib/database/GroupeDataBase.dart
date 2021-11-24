import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Model/GroupModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GroupeDataBase {
  GroupeDataBase._();

  static final GroupeDataBase instance = GroupeDataBase._();
  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'groupe_database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE groupe(numCreator TEXT, dateCreation TEXT, nom TEXT, description TEXT, urlPhoto TEXT, PRIMARY KEY(numCreator, dateCreation))"
        );
      },
      version: 1,
    );
  }

  void insertGroupe(GroupModel groupModel) async {
    final Database db = await database;

    await db.insert(
      'groupe',
      groupModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateGroupe(GroupModel groupModel) async {
    final Database db = await database;
    await db.rawQuery('UPDATE groupe SET nom = ?, description = ?, urlPhoto = ? WHERE numCreator = ? AND dateCreation = ?', [groupModel.nom, groupModel.description, groupModel.urlPhoto, groupModel.numCreator, groupModel.dateCreation.toIso8601String()]);
  }

  void deleteGroupe(String numCreator, DateTime dateCreation ) async {
    final Database db = await database;
    db.rawQuery('DELETE FROM groupe WHERE numCreator = ? AND dateCreation = ?', [numCreator, dateCreation.toIso8601String()]);
  }

  Future<List<GroupModel>> messages() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('groupe');
    List<GroupModel> messages = List.generate(maps.length, (i) {
      return GroupModel.fromMap(maps[i]);
    });

    return messages;
  }
}