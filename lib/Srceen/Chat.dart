import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(),
      debugShowCheckedModeBanner: false, // ปิดคำว่า "Debug"
    );
  }
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('กู้ภัยออโต้ค'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () {
            // Handle back button press
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.orange),
            onPressed: () {
              // Handle search button press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                _buildReceivedMessage(
                  'รถของนำ้องสาววิริยาสันตโกไท่จงแมนบริเวณทางม้าลายเมื่อช่วงเช้าที่ผ่านมา\nตำแหน่งนหูสะพานพญานาค\nบนตัวแทนของอนุเสาวรีย์ชัยฯ ใกล้ๆกับทาง\nลงสะพานลอยฝั่งมองใต้อนพยาบาล',
                ),
                _buildSentMessage(
                  'แต่ถ้าเร่งด่วนก้อไปไม่กู้รุนแรงรถดับกลางซอยออกมาไม่ได้',
                ),
                _buildReceivedMessage(
                  'ถูกข้างซดกับบราเดอร์หน้านัยต่อตา\nตำรวจลากสหถเหตุจากหลับใน\nแพ้พ่ายครูฝึกวิชาการจากกรุงเทพพาณิชย์\nฝากด้วยนะรสของอนุที่ใช้หลักเท่านั้น\nรัลสูญบัติคือผู้เสียชีวิตลาน',
                ),
                _buildSentMessage(
                  'วงษ์ตำรวจสอบสวนให้มันถึงไม่เปิด\nอันรถหลักนี้',
                ),
                _buildReceivedMessage(
                  'จุดเกิดเหตุของอนุเสาวรีย์ฯ\nรถยนต์ชนกันพับบนป้ายแนบเนียนหรือฟลุก\nยานน้อยหาจุดนี้นับตังปราบใช่เส้นเปค\nนี้หรือเทอม 05.40 น. มั่นที่ 15 ค.',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Message here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: () {
                    // Handle send message
                  },
                  child: Icon(Icons.send, color: Colors.white),
                  backgroundColor: Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceivedMessage(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildSentMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.orange[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
