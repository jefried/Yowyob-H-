import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Model/PostModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PostDataBase {
  PostDataBase._();

  static final PostDataBase instance = PostDataBase._();
  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'post_database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE post(numCreator INTEGER, urlPhoto TEXT, date TEXT, texte TEXT, urlMedia TEXT, mediaType TEXT, likes INTEGER, duration INTEGER, PRIMARY KEY(numCreator, date))"
        );
      },
      version: 1,
    );
  }

  void insertPost(PostModel postModel) async {
    final Database db = await database;

    await db.insert(
      'post',
      postModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateConversation(PostModel postModel) async {
    final Database db = await database;
    await db.rawQuery('UPDATE post SET urlPhoto = ?, texte = ?, urlMedia = ?, mediaType = ?, likes = ?, duration = ? WHERE numCreator = ? AND date = ?', [postModel.urlPhoto, postModel.texte, postModel.urlMedia, postModel.mediaType, postModel.likes, postModel.duration.inSeconds, postModel.numCreator, postModel.date.toIso8601String()]);
  }

  void deleteConversation(int numCreator, DateTime date) async {
    final Database db = await database;
    await db.rawQuery('DELETE FROM post WHERE numCreator = ? AND date = ?', [numCreator, date.toIso8601String()]);
  }

  Future<List<PostModel>> stories() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('post');
    List<PostModel> stories = List.generate(maps.length, (i) {
      return PostModel.fromMap(maps[i]);
    });

    return stories;
  }
}