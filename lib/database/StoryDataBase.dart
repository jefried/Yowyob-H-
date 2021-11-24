import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Model/StoryModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class StoryDataBase {
  StoryDataBase._();

  static final StoryDataBase instance = StoryDataBase._();
  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'story_database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE story(numCreator INTEGER, urlPhoto TEXT, date TEXT, texte TEXT, urlMedia TEXT, mediaType TEXT, duration INTEGER, PRIMARY KEY(numCreator, date))"
        );
      },
      version: 1,
    );
  }

  void insertStory(StoryModel storyModel) async {
    final Database db = await database;

    await db.insert(
      'story',
      storyModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateStory(StoryModel storyModel) async {
    final Database db = await database;
    await db.rawQuery('UPDATE story SET urlPhoto = ?, texte = ?, urlMedia = ?, mediaType = ?, duration = ? WHERE numCreator = ? AND date = ?', [storyModel.urlPhoto, storyModel.texte, storyModel.urlMedia, storyModel.mediaType, storyModel.duration.inSeconds, storyModel.numCreator, storyModel.date.toIso8601String()]);
  }

  void deleteStory(int numCreator, DateTime date) async {
    final Database db = await database;
    db.rawQuery('DELETE FROM story WHERE numCreator = ? AND date = ?', [numCreator, date.toIso8601String()]);
  }

  Future<List<StoryModel>> stories() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('story');
    List<StoryModel> stories = List.generate(maps.length, (i) {
      return StoryModel.fromMap(maps[i]);
    });

    return stories;
  }
}