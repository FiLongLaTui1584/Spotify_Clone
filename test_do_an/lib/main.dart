import 'package:flutter/material.dart';
import 'package:test_do_an/page/firstPage.dart';
import 'package:test_do_an/page/sign_in.dart';
import 'package:test_do_an/page/sign_up.dart';
import 'package:test_do_an/main_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // Import đúng để dùng rootBundle và ByteData
import 'package:test_do_an/helper/audio_player_manager.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Đảm bảo các dịch vụ Flutter sẵn sàng
  await copyDatabaseIfNotExists(); // Sao chép database trước khi chạy app
  await AudioPlayerManager().init(); // Khởi tạo AudioPlayerManager
  runApp(MyApp());
}

Future<void> copyDatabaseIfNotExists() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'music_app.db');
  File dbFile = File(path);

  // Nếu file chưa tồn tại, sao chép từ assets
  if (!await dbFile.exists()) {
    ByteData data = await rootBundle.load(
        'assets/database/music_app.db'); // ByteData từ flutter/services.dart
    List<int> bytes = data.buffer.asUint8List();
    await dbFile.writeAsBytes(bytes, flush: true);
    print('Đã sao chép music_app.db từ assets');
  } else {
    print('Database đã tồn tại, không sao chép lại');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => IntroWidget(),
        '/login': (context) => SignIn(),
        '/register': (context) => SignUp(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}
