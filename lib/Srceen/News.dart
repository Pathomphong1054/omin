import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsPage(),
    );
  }
}

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                // Action เมื่อคลิกที่ไอคอนซ้าย
                print('แจ้งเตือนทั้งหมด ถูกคลิก');
              },
              child: Column(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  Text(
                    'แจ้งเตือนทั้งหมด',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // Action เมื่อคลิกที่ข้อความกลาง
                print('แจ้งเตือนในพื้นที่ ถูกคลิก');
              },
              child: Column(
                children: [
                  Text(
                    'Warning',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'แจ้งเตือนในพื้นที่',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // Action เมื่อคลิกที่ไอคอนขวา
                print('ประวัติแจ้งเตือน ถูกคลิก');
              },
              child: Column(
                children: [
                  Icon(Icons.history, color: Colors.black),
                  Text(
                    'ประวัติแจ้งเตือน',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('เนื้อหาของหน้า'),
      ),
    );
  }
}
