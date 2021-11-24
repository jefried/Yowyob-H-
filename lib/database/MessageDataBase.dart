import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/Model/messages.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MessageDataBase {
  MessageDataBase._();

  static final MessageDataBase instance = MessageDataBase._();
  static Database _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'message_database.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE message(numSender TEXT, numReceiver TEXT, date TEXT, mediaType TEXT, texte TEXT, urlMedia TEXT, PRIMARY KEY(numSender, numReceiver, date))"
        );
      },
      version: 1,
    );
  }

  void insertMessage(MessageModel message) async {
    final Database db = await database;

    await db.insert(
      'message',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateMessage(MessageModel message) async {
    final Database db = await database;
    await db.rawQuery('UPDATE message SET mediaType = ?, texte = ?, urlMedia = ? WHERE numSender = ? AND numReceiver = ? AND date = ?', [message.mediaType, message.texte, message.urlMedia, message.numSender, message.numReceiver, message.date.toIso8601String()]);
  }

  void deleteMessage(String numSender, String numReceiver,DateTime date ) async {
    final Database db = await database;
    db.rawQuery('DELETE FROM message WHERE numSender = ? AND numReceiver = ? AND date = ?', [numSender, numReceiver, date.toIso8601String()]);
  }

  void deleteTable () async {
    final Database db = await database;
    db.delete('message');
  }

  Future<List<MessageModel>> messages() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('message');
    List<MessageModel> messages = List.generate(maps.length, (i) {
    return MessageModel.fromMap(maps[i]);
    });

    return messages;
  }
}