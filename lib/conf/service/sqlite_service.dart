import 'package:path/path.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/dashboard/domain/push_message.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteService 
{
  final LoggerSingleton log = LoggerSingleton.getInstance('SQLiteService');
  static Database? _db;

  static Future<void> init() async 
  {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'push_messages.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE push_messages (
            messageId TEXT PRIMARY KEY,
            title TEXT,
            body TEXT,
            sentDate TEXT,
            read INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> saveNotification(PushMessage message) async 
  {
    await _db?.insert(
      'push_messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<PushMessage>> getNotifications() async 
  {
    final List<Map<String, dynamic>> maps = await _db?.query('push_messages') ?? [];
    return maps.map((m) => PushMessage.fromMap(m)).toList();
  }

  static Future<PushMessage?> getNotificationById(String messageId) async 
  {
    final result = await _db?.query(
      'push_messages',
      where: 'messageId = ?',
      whereArgs: [messageId],
    );

    if (result!.isNotEmpty) {
      return PushMessage.fromMap(result.first);
    }

    return null;
  }

  static Future<void> deleteNotification(String id) async 
  {
    await _db?.delete('push_messages', where: 'messageId = ?', whereArgs: [id]);
  }

  static Future<void> deleteNotificationRead({bool onlyRead = false}) async
  {
    if(onlyRead) 
    {
      await _db?.delete(
        'push_messages',
        where: 'read = ?',
        whereArgs: [1],
      );
    } else {
      print('No se eliminaron las notificaciones leidas');
    }
  }

  static Future<void> markAllAsReadNotifications() async 
  {
    await _db?.update('push_messages', {'read': 1});
  }

  static Future<void> clearAllNotifications() async 
  {
    await _db?.delete('push_messages');
  }

  static Future<void> close() async 
  {
    await _db?.close();
    _db = null;
  }

}
