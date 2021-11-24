import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Model/conversationsGroup.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ConversationGroupDataBase {
  ConversationGroupDataBase._();

  static final ConversationGroupDataBase instance = ConversationGroupDataBase._();
  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'conversationGroup_database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE conversationGroup(urlPhoto TEXT, numCreatorGroup INTEGER, dateCreationGroup TEXT, numCurrent INTEGER, lastMessage TEXT, date TEXT, lastToWrite TEXT, amountMessagesNotRead INTEGER, PRIMARY KEY(numCreatorGroup, dateCreationGroup, numCurrent)"
        );
      },
      version: 1,
    );
  }

  void insertConversationGroup(ConversationGroup conversationGroup) async {
    final Database db = await database;

    await db.insert(
      'conversationGroup',
      conversationGroup.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateConversationGroup(ConversationGroup conversationGroup) async {
    final Database db = await database;
    await db.rawQuery('UPDATE conversationGroup SET urlPhoto ?, lastMessage = ?, date = ?, lastToWrite = ?, amountMessagesNotRead = ?, WHERE numCurrent = ? AND numCreatorGroup = ? AND dateCreationGroup = ?', [conversationGroup.urlPhoto, conversationGroup.lastMessage, conversationGroup.date.toIso8601String(), conversationGroup.lastToWrite, conversationGroup.amountMessagesNotRead, conversationGroup.numCurrent, conversationGroup.numCreatorGroup, conversationGroup.dateCreationGroup.toIso8601String()]);
  }

  void deleteConversationGroup(int numCurrent, int numCreatorGroup, DateTime dateCreationGroup) async {
    final Database db = await database;
    db.rawQuery('DELETE FROM conversationGroup WHERE numCurrent = ? AND numCreatorGroup = ? AND dateCreationGroup = ?', [numCurrent, numCreatorGroup, dateCreationGroup.toIso8601String()]);
  }

  Future<List<ConversationGroup>> conversationsGroup() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('conversationGroup');
    List<ConversationGroup> conversationsGroup = List.generate(maps.length, (i) {
    return ConversationGroup.fromMap(maps[i]);
    });

    return conversationsGroup;
  }
}