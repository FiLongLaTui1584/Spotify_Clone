import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('music_app.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, fileName);
    print('Đường dẫn database: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print('Database mới được tạo (nếu không dùng file từ assets)');
      },
      onUpgrade: (db, oldVersion, newVersion) async {},
    );
  }

  Future<int> registerUser(String username, String password, String name, String? avatar) async {
    final db = await database;
    try {
      int result = await db.insert(
        'users',
        {'username': username, 'password': password, 'name': name, 'avatar': avatar},
        conflictAlgorithm: ConflictAlgorithm.rollback,
      );
      return result;
    } catch (e) {
      return -1;
    }
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(int id, String name, String? avatar) async {
    final db = await database;
    return await db.update(
      'users',
      {'name': name, 'avatar': avatar},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Hàm lấy bài hát hiện tại (dựa trên id)
  Future<Map<String, dynamic>?> getSongById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> songs = await db.query(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (songs.isNotEmpty) {
      Map<String, dynamic> song = songs.first;
      List<Map<String, dynamic>> artists = await db.query(
        'artists',
        where: 'id = ?',
        whereArgs: [song['artistId']],
      );
      String artistName = artists.isNotEmpty ? artists.first['name'] : 'Unknown Artist';
      return {
        'id': song['id'],
        'title': song['title'],
        'artist': artistName,
        'filePath': song['filePath'],
        'avatar': song['avatar'],
        'lyrics': song['lyrics'],
      };
    }
    return null;
  }

  // Hàm lấy tất cả bài hát
  Future<List<Map<String, dynamic>>> getAllSongs() async {
    final db = await database;
    List<Map<String, dynamic>> songs = await db.query('songs');

    List<Map<String, dynamic>> result = [];
    for (var song in songs) {
      List<Map<String, dynamic>> artists = await db.query(
        'artists',
        where: 'id = ?',
        whereArgs: [song['artistId']],
      );
      String artistName = artists.isNotEmpty ? artists.first['name'] : 'Unknown Artist';
      result.add({
        'id': song['id'],
        'title': song['title'],
        'artist': artistName,
        'filePath': song['filePath'],
        'avatar': song['avatar'],
        'lyrics': song['lyrics'],
      });
    }
    return result;
  }
}