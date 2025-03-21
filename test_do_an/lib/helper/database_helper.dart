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
    print('Đường dẫn database: $path'); // Debug đường dẫn

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print('Tạo bảng users'); // Debug
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> registerUser(String username, String password) async {
    final db = await database;
    try {
      int result = await db.insert(
        'users',
        {'username': username, 'password': password},
        conflictAlgorithm: ConflictAlgorithm.rollback,
      );
      print('Đã thêm user: $username, ID: $result'); // Debug
      return result;
    } catch (e) {
      print('Lỗi khi đăng ký: $e'); // Debug lỗi cụ thể
      return -1;
    }
  }

  // Hàm kiểm tra đăng nhập
  Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    print('Kết quả đăng nhập: $result'); // Debug
    return result.isNotEmpty ? result.first : null;
  }
}
