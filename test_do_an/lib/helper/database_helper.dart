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
        print('Tạo các bảng trong database');
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            name TEXT NOT NULL,
            avatar TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE artists (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            avatar TEXT,
            bio TEXT,
            createdAt TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE songs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            artistId INTEGER,
            filePath TEXT NOT NULL,
            lyrics TEXT,
            avatar TEXT,
            FOREIGN KEY (artistId) REFERENCES artists(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE albums (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            name TEXT NOT NULL,
            isDefault INTEGER DEFAULT 0,
            FOREIGN KEY (userId) REFERENCES users(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE album_songs (
            albumId INTEGER,
            songId INTEGER,
            FOREIGN KEY (albumId) REFERENCES albums(id),
            FOREIGN KEY (songId) REFERENCES songs(id),
            PRIMARY KEY (albumId, songId)
          )
        ''');
        await db.execute('''
          CREATE TABLE artist_albums (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            artistId INTEGER,
            name TEXT NOT NULL,
            releaseDate TEXT,
            avatar TEXT,
            FOREIGN KEY (artistId) REFERENCES artists(id)
          )
        ''');
        await db.execute('''
          CREATE TABLE artist_album_songs (
            artistAlbumId INTEGER,
            songId INTEGER,
            FOREIGN KEY (artistAlbumId) REFERENCES artist_albums(id),
            FOREIGN KEY (songId) REFERENCES songs(id),
            PRIMARY KEY (artistAlbumId, songId)
          )
        ''');
        await db.execute('''
          CREATE TABLE followed_artists (
            userId INTEGER,
            artistId INTEGER,
            FOREIGN KEY (userId) REFERENCES users(id),
            FOREIGN KEY (artistId) REFERENCES artists(id),
            PRIMARY KEY (userId, artistId)
          )
        ''');
      },
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
      print('Đã thêm user: $username, ID: $result');
      return result;
    } catch (e) {
      print('Lỗi khi đăng ký: $e');
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

  Future<List<Map<String, dynamic>>> getSongs() async {
    final db = await database;
    return await db.query('songs');
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
}