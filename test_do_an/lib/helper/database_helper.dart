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
        // Tạo các bảng nếu cần
        await db.execute('''
          CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            name TEXT NOT NULL,
            avatar TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS albums (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER NOT NULL,
            name TEXT NOT NULL,
            isDefault INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY (userId) REFERENCES users(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS album_songs (
            albumId INTEGER NOT NULL,
            songId INTEGER NOT NULL,
            PRIMARY KEY (albumId, songId),
            FOREIGN KEY (albumId) REFERENCES albums(id),
            FOREIGN KEY (songId) REFERENCES songs(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS songs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            artistId INTEGER NOT NULL,
            filePath TEXT NOT NULL,
            avatar TEXT,
            lyrics TEXT,
            FOREIGN KEY (artistId) REFERENCES artists(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS artists (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            avatar TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS followed_artists (
            userId INTEGER NOT NULL,
            artistId INTEGER NOT NULL,
            PRIMARY KEY (userId, artistId),
            FOREIGN KEY (userId) REFERENCES users(id),
            FOREIGN KEY (artistId) REFERENCES artists(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS artist_albums (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            artistId INTEGER NOT NULL,
            name TEXT NOT NULL,
            FOREIGN KEY (artistId) REFERENCES artists(id)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {},
    );
  }

  Future<int> registerUser(
      String username, String password, String name, String? avatar) async {
    final db = await database;
    try {
      int userId = await db.insert(
        'users',
        {
          'username': username,
          'password': password,
          'name': name,
          'avatar': avatar
        },
        conflictAlgorithm: ConflictAlgorithm.rollback,
      );

      // Tạo album "Yêu thích" mặc định cho người dùng
      await db.insert(
        'albums',
        {
          'userId': userId,
          'name': 'Yêu thích',
          'isDefault': 1, // Đánh dấu là album mặc định
        },
        conflictAlgorithm: ConflictAlgorithm.rollback,
      );

      return userId;
    } catch (e) {
      print('Lỗi khi đăng ký người dùng: $e');
      return -1;
    }
  }

  Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
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

  // Hàm kiểm tra xem người dùng đã theo dõi nghệ sĩ hay chưa
  Future<bool> isFollowingArtist(int userId, int artistId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'followed_artists',
      where: 'userId = ? AND artistId = ?',
      whereArgs: [userId, artistId],
    );
    return result.isNotEmpty;
  }

  // Hàm để theo dõi nghệ sĩ
  Future<void> followArtist(int userId, int artistId) async {
    final db = await database;
    await db.insert(
      'followed_artists',
      {
        'userId': userId,
        'artistId': artistId,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // Hàm để bỏ theo dõi nghệ sĩ
  Future<void> unfollowArtist(int userId, int artistId) async {
    final db = await database;
    await db.delete(
      'followed_artists',
      where: 'userId = ? AND artistId = ?',
      whereArgs: [userId, artistId],
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
      String artistName =
          artists.isNotEmpty ? artists.first['name'] : 'Unknown Artist';
      return {
        'id': song['id'],
        'title': song['title'],
        'artist': artistName,
        'artistId': song['artistId'], // Thêm artistId
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
      String artistName =
          artists.isNotEmpty ? artists.first['name'] : 'Unknown Artist';
      result.add({
        'id': song['id'],
        'title': song['title'],
        'artist': artistName,
        'artistId': song['artistId'], // Thêm artistId
        'filePath': song['filePath'],
        'avatar': song['avatar'],
        'lyrics': song['lyrics'],
      });
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getFollowedArtists(int userId) async {
    final db = await database;
    List<Map<String, dynamic>> followedArtists = await db.query(
      'followed_artists',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    if (followedArtists.isEmpty) {
      return [];
    }

    List<int> artistIds =
        followedArtists.map((e) => e['artistId'] as int).toList();

    List<Map<String, dynamic>> artists = await db.query(
      'artists',
      where: 'id IN (${artistIds.join(",")})',
    );

    return artists;
  }

  Future<List<Map<String, dynamic>>> getSongsByArtist(int artistId) async {
    final db = await database;
    List<Map<String, dynamic>> songs = await db.query(
      'songs',
      where: 'artistId = ?',
      whereArgs: [artistId],
    );
    return songs;
  }

  Future<List<Map<String, dynamic>>> getArtistAlbums(int artistId) async {
    final db = await database;
    List<Map<String, dynamic>> albums = await db.query(
      'artist_albums',
      where: 'artistId = ?',
      whereArgs: [artistId],
    );
    return albums;
  }

  Future<Map<String, dynamic>?> getArtistByName(String name) async {
    final db = await database;
    List<Map<String, dynamic>> artists = await db.query(
      'artists',
      where: 'name = ?',
      whereArgs: [name],
    );
    return artists.isNotEmpty ? artists.first : null;
  }

  Future<List<Map<String, dynamic>>> getRandomSongs() async {
    final db = await database;
    List<Map<String, dynamic>> songs = await db.query(
      'songs',
      orderBy: 'RANDOM()',
      limit: 5,
    );

    List<Map<String, dynamic>> result = [];
    for (var song in songs) {
      List<Map<String, dynamic>> artists = await db.query(
        'artists',
        where: 'id = ?',
        whereArgs: [song['artistId']],
      );
      String artistName =
          artists.isNotEmpty ? artists.first['name'] : 'Unknown Artist';
      result.add({
        'id': song['id'],
        'title': song['title'],
        'artist': artistName,
        'artistId': song['artistId'], // Thêm artistId
        'filePath': song['filePath'],
        'avatar': song['avatar'],
        'lyrics': song['lyrics'],
      });
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> searchSongsByTitle(String keyword) async {
    final db = await database;
    List<Map<String, dynamic>> songs = await db.query(
      'songs',
      where: 'title LIKE ?',
      whereArgs: ['%$keyword%'],
    );

    List<Map<String, dynamic>> result = [];
    for (var song in songs) {
      List<Map<String, dynamic>> artists = await db.query(
        'artists',
        where: 'id = ?',
        whereArgs: [song['artistId']],
      );
      String artistName =
          artists.isNotEmpty ? artists.first['name'] : 'Unknown Artist';
      result.add({
        'id': song['id'],
        'title': song['title'],
        'artist': artistName,
        'artistId': song['artistId'], // Thêm artistId
        'filePath': song['filePath'],
        'avatar': song['avatar'],
        'lyrics': song['lyrics'],
      });
    }
    return result;
  }

  // Hàm lấy album "Yêu thích" của người dùng
  Future<Map<String, dynamic>?> getFavoriteAlbum(int userId) async {
    final db = await database;
    List<Map<String, dynamic>> albums = await db.query(
      'albums',
      where: 'userId = ? AND isDefault = ?',
      whereArgs: [userId, 1],
    );
    return albums.isNotEmpty ? albums.first : null;
  }

  // Hàm kiểm tra xem bài hát có trong album "Yêu thích" không
  Future<bool> isSongInFavoriteAlbum(int userId, int songId) async {
    final db = await database;
    Map<String, dynamic>? favoriteAlbum = await getFavoriteAlbum(userId);
    if (favoriteAlbum == null) return false;

    List<Map<String, dynamic>> result = await db.query(
      'album_songs',
      where: 'albumId = ? AND songId = ?',
      whereArgs: [favoriteAlbum['id'], songId],
    );
    return result.isNotEmpty;
  }

  // Hàm thêm bài hát vào album "Yêu thích"
  Future<void> addSongToFavoriteAlbum(int userId, int songId) async {
    final db = await database;
    Map<String, dynamic>? favoriteAlbum = await getFavoriteAlbum(userId);
    if (favoriteAlbum == null) {
      // Nếu không có album "Yêu thích", tạo mới (trường hợp lỗi)
      int albumId = await db.insert(
        'albums',
        {
          'userId': userId,
          'name': 'Yêu thích',
          'isDefault': 1,
        },
        conflictAlgorithm: ConflictAlgorithm.rollback,
      );
      await db.insert(
        'album_songs',
        {
          'albumId': albumId,
          'songId': songId,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } else {
      await db.insert(
        'album_songs',
        {
          'albumId': favoriteAlbum['id'],
          'songId': songId,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  // Hàm xóa bài hát khỏi album "Yêu thích"
  Future<void> removeSongFromFavoriteAlbum(int userId, int songId) async {
    final db = await database;
    Map<String, dynamic>? favoriteAlbum = await getFavoriteAlbum(userId);
    if (favoriteAlbum != null) {
      await db.delete(
        'album_songs',
        where: 'albumId = ? AND songId = ?',
        whereArgs: [favoriteAlbum['id'], songId],
      );
    }
  }

  // Hàm lấy tất cả album của người dùng
  Future<List<Map<String, dynamic>>> getUserAlbums(int userId) async {
    final db = await database;
    try {
      List<Map<String, dynamic>> albums = await db.query(
        'albums',
        where: 'userId = ?',
        whereArgs: [userId],
      );
      print('Danh sách album từ database: $albums');

      // Tạo bản sao của danh sách để tránh lỗi liên quan đến dữ liệu gốc
      List<Map<String, dynamic>> albumsCopy = List.from(albums);

      // Sắp xếp danh sách
      if (albumsCopy.isNotEmpty) {
        albumsCopy.sort((a, b) {
          int aIsDefault = a['isDefault'] ?? 0;
          int bIsDefault = b['isDefault'] ?? 0;
          if (aIsDefault == 1) return -1;
          if (bIsDefault == 1) return 1;
          return (a['name'] ?? '').compareTo(b['name'] ?? '');
        });
      }

      // Chuyển đổi dữ liệu
      return albumsCopy.map((album) {
        return {
          'id': album['id'] ?? 0,
          'name': album['name'] ?? 'Unknown Album',
          'image': 'assets/images/song_icon.png',
          'isDefault': album['isDefault'] ?? 0,
        };
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy danh sách album: $e');
      return []; // Trả về danh sách rỗng nếu có lỗi
    }
  }

  // Hàm lấy danh sách bài hát trong một album
  Future<List<Map<String, dynamic>>> getSongsInAlbum(int albumId) async {
    final db = await database;
    List<Map<String, dynamic>> albumSongs = await db.query(
      'album_songs',
      where: 'albumId = ?',
      whereArgs: [albumId],
    );

    List<Map<String, dynamic>> songs = [];
    for (var albumSong in albumSongs) {
      Map<String, dynamic>? song = await getSongById(albumSong['songId']);
      if (song != null) {
        songs.add(song);
      }
    }
    return songs;
  }

  Future<Map<String, dynamic>?> getAlbumById(int albumId) async {
    final db = await database;
    try {
      List<Map<String, dynamic>> albums = await db.query(
        'albums',
        where: 'id = ?',
        whereArgs: [albumId],
      );
      return albums.isNotEmpty ? albums.first : null;
    } catch (e) {
      print('Lỗi khi lấy album: $e');
      return null;
    }
  }

  // Hàm tạo album mới (dùng trong CreatePlaylistSheet)
  Future<int> createAlbum(int userId, String albumName) async {
    final db = await database;
    try {
      int albumId = await db.insert(
        'albums',
        {
          'userId': userId,
          'name': albumName,
          'isDefault': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.rollback,
      );
      print(
          'Tạo album thành công: id=$albumId, userId=$userId, name=$albumName');
      return albumId;
    } catch (e) {
      print('Lỗi khi tạo album: $e');
      return -1;
    }
  }

  // Hàm xóa album (dùng trong PlaylistOptionsBottomSheet)
  Future<void> deleteAlbum(int albumId) async {
    final db = await database;
    try {
      // Kiểm tra xem album có phải là "Yêu thích" không
      List<Map<String, dynamic>> albums = await db.query(
        'albums',
        where: 'id = ?',
        whereArgs: [albumId],
      );

      if (albums.isNotEmpty && albums.first['isDefault'] == 1) {
        throw Exception('Không thể xóa album "Yêu thích"');
      }

      // Xóa các bài hát trong album từ bảng album_songs
      await db.delete(
        'album_songs',
        where: 'albumId = ?',
        whereArgs: [albumId],
      );
      // Xóa album từ bảng albums
      await db.delete(
        'albums',
        where: 'id = ?',
        whereArgs: [albumId],
      );
      print('Xóa album thành công: albumId=$albumId');
    } catch (e) {
      print('Lỗi khi xóa album: $e');
      rethrow;
    }
  }

  //Hàm thêm nhạc vào album
  Future<void> addSongToAlbum(int albumId, int songId) async {
    final db = await database;
    try {
      await db.insert(
        'album_songs',
        {
          'albumId': albumId,
          'songId': songId,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      print(
          'Thêm bài hát vào album thành công: albumId=$albumId, songId=$songId');
    } catch (e) {
      print('Lỗi khi thêm bài hát vào album: $e');
      rethrow;
    }
  }

  //Hàm xóa bài hát khỏi album
  Future<void> removeSongFromAlbum(int albumId, int songId) async {
    final db = await database;
    try {
      await db.delete(
        'album_songs',
        where: 'albumId = ? AND songId = ?',
        whereArgs: [albumId, songId],
      );
      print(
          'Xóa bài hát khỏi album thành công: albumId=$albumId, songId=$songId');
    } catch (e) {
      print('Lỗi khi xóa bài hát khỏi album: $e');
      rethrow;
    }
  }
}
