import 'package:flutter/material.dart';

class CustomMusicBar extends StatelessWidget {
  const CustomMusicBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF5C2401),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              'assets/images/random.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'NOLOVENOLIFE',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                Text(
                  'HIEUTHUHAI',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.skip_previous, color: Colors.white, size: 35),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.play_arrow, color: Colors.white, size: 35),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.skip_next, color: Colors.white, size: 35),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
