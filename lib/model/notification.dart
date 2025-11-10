import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotificationModel {
  final int? id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  // Added optional data field for storing FCM payload data
  final Map<String, dynamic>? data;

  NotificationModel({
    this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead ? 1 : 0,
      'data': data != null ? _encodeMap(data!) : null,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      timestamp: DateTime.parse(map['timestamp']),
      isRead: map['isRead'] == 1,
      data: map['data'] != null ? _decodeMap(map['data']) : null,
    );
  }

  // Helper method to encode Map to JSON string
  static String _encodeMap(Map<String, dynamic> map) {
    return map.entries.map((e) => '"${e.key}":"${e.value.toString()}"').join(',');
  }

  // Helper method to decode JSON string to Map
  static Map<String, dynamic> _decodeMap(String data) {
    try {
      // Simple parsing for basic key-value pairs
      final pairs = data.replaceAll('{', '').replaceAll('}', '').split(',');
      final map = <String, dynamic>{};
      for (var pair in pairs) {
        final parts = pair.split(':');
        if (parts.length == 2) {
          final key = parts[0].trim().replaceAll('"', '');
          final value = parts[1].trim().replaceAll('"', '');
          map[key] = value;
        }
      }
      return map;
    } catch (e) {
      Logger().e('Error decoding notification data: $e');
      return {};
    }
  }
}

class NotificationDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    var path = join(await getDatabasesPath(), 'notifications.db');
    return await openDatabase(
      path,
      version: 2, // Increased version number for migration
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE notifications(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            body TEXT,
            timestamp TEXT,
            isRead INTEGER,
            data TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add the data column if upgrading from version 1
          await db.execute('ALTER TABLE notifications ADD COLUMN data TEXT');
        }
      },
    );
  }

  static Future<void> insertNotification(NotificationModel notification) async {
    final db = await database;
    await db.insert(
      'notifications',
      notification.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<NotificationModel>> getNotifications() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      orderBy: 'timestamp DESC', // Most recent first
    );
    return List.generate(maps.length, (i) {
      return NotificationModel.fromMap(maps[i]);
    });
  }

  static Future<void> markAsRead(int id) async {
    final db = await database;
    await db.update(
      'notifications',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> markAllAsRead() async {
    final db = await database;
    await db.update(
      'notifications',
      {'isRead': 1},
    );
  }

  static Future<void> deleteNotification(int id) async {
    final db = await database;
    await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteAllNotifications() async {
    final db = await database;
    await db.delete('notifications');
  }

  static Future<int> getUnreadCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM notifications WHERE isRead = 0');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  static Future<void> clearAllNotifications() async {
    final db = await database;
    await db.delete('notifications');
  }
}
