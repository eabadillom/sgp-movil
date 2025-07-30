import 'package:path/path.dart';
import 'package:sgp_movil/conf/loggers/logger_singleton.dart';
import 'package:sgp_movil/features/dashboard/domain/push_message.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteService 
{
  static final SQLiteService _instance = SQLiteService._internal();
  factory SQLiteService() => _instance;

  SQLiteService._internal();

  static LoggerSingleton log = LoggerSingleton.getInstance('SQLiteService');
  static Database? _db;
  static const _dbName = 'push_messages.db';

  static Future<void> init() async 
  {
    if(_db != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async 
      {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS push_messages (
            messageId TEXT PRIMARY KEY,
            title TEXT,
            body TEXT,
            sentDate TEXT,
            read INTEGER
          )
        ''');
      },
    );

    log.logger.info('Database initialized at $path');
  }

  static Database get database 
  {
    if(_db == null) {
      throw Exception('Base de datos no inicializada. Llamar a init() primero.');
    }
    return _db!;
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
    log.logger.info('Tam de notificaciones: ${maps.length}');
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
      log.logger.info('No se eliminaron las notificaciones leidas');
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
    log.logger.info('Base de datos cerrada');
  }

}
