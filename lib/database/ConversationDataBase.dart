import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Model/conversations.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ConversationDataBase {
  ConversationDataBase._();

  static final ConversationDataBase instance = ConversationDataBase._();
  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'conversation_database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE conversation(urlPhoto TEXT, numOther INTEGER, numCurrent INTEGER, lastMessage TEXT, date TEXT, lastToWrite TEXT, amountMessagesNotRead INTEGER, PRIMARY KEY(numOther, numCurrent))"
        );
      },
      version: 1,
    );
  }

  void insertConversation(Conversation conversation) async {
    final Database db = await database;

    await db.insert(
      'conversation',
      conversation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateConversation(Conversation conversation) async {
    final Database db = await database;
    await db.rawQuery('UPDATE conversation SET urlPhoto ?, lastMessage = ?, date = ?, lastToWrite = ?, amountMessagesNotRead = ?, WHERE numCurrent = ? AND numOther = ?', [conversation.urlPhoto, conversation.lastMessage, conversation.date.toIso8601String(), conversation.lastToWrite, conversation.amountMessagesNotRead, conversation.numCurrent, conversation.numOther]);
  }

  void deleteConversation(int numCurrent, int numOther) async {
    final Database db = await database;
    db.rawQuery('DELETE FROM conversation WHERE numCurrent = ? AND numOther = ?', [numCurrent, numOther]);
  }

  Future<List<Conversation>> conversations() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('conversation');
    List<Conversation> conversations = List.generate(maps.length, (i) {
    return Conversation.fromMap(maps[i]);
    });

    return conversations;
  }
}