import 'package:flutter/material.dart';

class SongDetailPage extends StatefulWidget {
  @override
  _SongDetailPageState createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  double _currentTime = 0; // Thời gian hiện tại của bài hát
  final double _totalDuration = 196; // Tổng thời gian bài hát (196 giây)

  // Hàm chuyển đổi giây thành phút:giây (mm:ss)
  String _formatDuration(double seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = (seconds % 60).toInt();
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.expand_more, color: Colors.white, size: 35),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Tuyển tập của HIEUTHUHAI",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.white, size: 30),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(), // Hiệu ứng cuộn mượt
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 30, bottom: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/random.png',
                  width: 418,
                  height: 418,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NOLOVENOLIFE",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "HIEUTHUHAI",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite_border,
                        color: Colors.white, size: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 25, bottom: 8),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                      trackHeight: 6,
                    ),
                    child: Slider(
                      value: _currentTime,
                      min: 0,
                      max: _totalDuration,
                      onChanged: (value) {
                        setState(() {
                          _currentTime = value;
                        });
                      },
                      activeColor: Color.fromARGB(166, 222, 219, 219),
                      inactiveColor: Color.fromARGB(255, 58, 56, 56),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_currentTime),
                          style: TextStyle(
                              color: Color.fromARGB(166, 222, 219, 219),
                              fontSize: 14),
                        ),
                        Text(
                          _formatDuration(_totalDuration),
                          style: TextStyle(
                              color: Color.fromARGB(166, 222, 219, 219),
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.shuffle, color: Colors.white, size: 25),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_previous,
                        color: Colors.white, size: 45),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.play_circle_fill,
                        color: Colors.white, size: 80),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next, color: Colors.white, size: 45),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.timer, color: Colors.white, size: 25),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bản xem trước lời bài hát",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 200,
                    ),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(), // Hiệu ứng cuộn mượt
                      child: Text(
                        "Mình hãy cứ sống thế đi\n"
                        "Ta cứ mãi ước mơ\n"
                        "Ta cứ luôn mong chờ\n"
                        "Điều tuyệt vời nhé em\n"
                        "Cầm tay nhau mãi bước đi\n"
                        "Sẽ cứ thế mỉm cười\n"
                        "Ta sẽ quên đi\n"
                        "Bao nhiêu tình yêu tan vỡ\n"
                        "Như là giấc mơ\n"
                        "No love no life\n"
                        "No love no life\n"
                        "Anh chẳng còn muốn\n"
                        "Quay về nơi ấy\n"
                        "No love no life\n"
                        "No love no life\n"
                        "Sẽ mãi thuộc về nơi đây với em\n"
                        "Em biết anh là một thằng rapper\n"
                        "Rót mật vào tai bằng dây thanh\n"
                        "Chỉ xuất hiện là họ đã say nhanh\n"
                        "Mang tiếp trap và trăm cái red flag\n"
                        "Là bởi vì luôn luôn\n"
                        "Có phụ nữ vây quanh\n"
                        "Có 1000 lý do để phải ghen\n"
                        "Nhưng em không\n"
                        "Em up hình biết chắc anh phải xem\n"
                        "Và đặc biệt phải khen\n"
                        "Sau mỗi lần xem xong\n"
                        "Anh luôn muốn\n"
                        "Cài cho em thêm cúc\n"
                        "Khi có thằng con trai nào đi qua\n"
                        "Vì em và anh luôn muốn\n"
                        "Chuyện mình nghiêm túc\n"
                        "Không phải just a game như fifa\n"
                        "Em làm cho mọi bài nhạc chia tay\n"
                        "Mà anh đã từng viết\n"
                        "Nó trở nên vô nghĩa\n"
                        "Hai bờ môi chạm nhau vào khuya nay\n"
                        "Mình ăn cho thật bốc\n"
                        "Nên chẳng cần tô nĩa\n"
                        "Em luôn tự tin, thu hút\n"
                        "Điểm số luôn nằm ở top đầu\n"
                        "Lần đầu gặp thì anh đã nhìn thấu\n"
                        "Và cũng chẳng cần giấu\n"
                        "Là hai ta khớp màu\n"
                        "Em vẫn hay còn giận anh\n"
                        "Khi mà xem qua\n"
                        "Về những gì mà anh nói ở trên camera\n"
                        "Hứa với em anh có thể đảm bảo,\n"
                        "Tất cả thứ có thể ghen đều trên camera\n"
                        "Bên nhau ta còn\n"
                        "Không một giây do dự nào\n"
                        "Bởi vì là yeah girl\n"
                        "Em vẫn luôn làm cho anh tự hào\n"
                        "Anh ghét nhất mỗi lần đi phỏng vấn\n"
                        "Họ lại hỏi câu hỏi đó mà xem\n"
                        "Họ hỏi anh về hình mẫu lý tưởng\n"
                        "Nhưng không thể trả lời đó là em\n"
                        "Bởi vì em tinh tế và em thông minh\n"
                        "Đặt niềm tin hết vào anh\n"
                        "Khi anh không tin\n"
                        "Tặng em cả rừng hoa thật là lung linh\n"
                        "Là vì em với đẹp luôn là cặp song sinh\n"
                        "Làm anh thốt lên là DAMN như là KDot\n"
                        "Là lý do mà đàn ông ngoài kia hay khóc\n"
                        "Là lý do anh không sợ fan nữ unfan\n"
                        "Và phải là nói mình độc thân\n"
                        "Như idol K-Pop and it pays off\n"
                        "Và cuộc sống sự nổi tiếng\n"
                        "Anh đã quen rồi\n"
                        "Cũng không hay ra ngoài\n"
                        "Nên là I don’t mind\n"
                        "Em thì rất ghét là phải tránh\n"
                        "Mấy nơi đông người\n"
                        "Cố luôn phải che mặt dù ta không sai\n"
                        "Anh biết là em vẫn hay hình dung\n"
                        "Ngày đứng chung một khung hình\n"
                        "Và ta công khai\n"
                        "Vì mình luôn hiểu ý nhau\n"
                        "Vì có chung chữ cái đầu\n"
                        "Ngoài mình ra thì không ai\n"
                        "Mình hãy cứ sống thế đi\n"
                        "Ta cứ mãi ước mơ\n"
                        "Ta cứ luôn mong chờ\n"
                        "Điều tuyệt vời nhé em\n"
                        "Cầm tay nhau mãi bước đi\n"
                        "Sẽ cứ thế mỉm cười\n"
                        "Ta sẽ quên đi\n"
                        "Bao nhiêu tình yêu tan vỡ\n"
                        "Như là giấc mơ\n"
                        "No love no life\n"
                        "No love no life\n"
                        "Anh chẳng còn muốn\n"
                        "Quay về nơi ấy\n"
                        "No love no life\n"
                        "No love no life\n"
                        "Sẽ mãi thuộc về nơi đây với em\n"
                        "No love no life\n"
                        "No love no life\n"
                        "Anh chẳng còn muốn\n"
                        "Quay về nơi ấy\n"
                        "No love no life\n"
                        "No love no life\n"
                        "Sẽ mãi thuộc về nơi đây với em\n",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Người tham gia thực hiện",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildContributor("HIEUTHUHAI", "Nghệ sĩ chính", true),
                  _buildContributor(
                      "Trần Minh Hiếu", "Nhà soạn nhạc, Người viết lời", false),
                  _buildContributor("Kewtiie", "Nhà sản xuất", false),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildContributor(String name, String role, bool isFollowing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Text(role, style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          if (isFollowing)
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child:
                  Text("Đang theo dõi", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}
