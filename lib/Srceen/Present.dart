import 'package:flutter/material.dart';
import 'package:omni/Home.dart'; // ตรวจสอบให้แน่ใจว่าไฟล์ Home.dart มีอยู่จริง

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PresentPage(),
      debugShowCheckedModeBanner: false, // ปิดคำว่า "Debug"
    );
  }
}

class PresentPage extends StatefulWidget {
  @override
  _PresentPageState createState() => _PresentPageState();
}

class _PresentPageState extends State<PresentPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สถิติ'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomePage(userId: )),
            // );
            // Handle back button press
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 100.0,
              lineWidth: 13.0,
              animation: true,
              percent: 0.64,
              center: Text(
                "64 %",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.orange,
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildStatisticItem('รถยนต์'),
                  _buildStatisticItem('รถจักรยานยนต์'),
                  _buildStatisticItem('รถบรรทุก'),
                  _buildStatisticItem('รถไฟ'),
                  _buildStatisticItem('Item'),
                  _buildStatisticItem('Item'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildStatisticItem(String title) {
    return ListTile(
      leading: Icon(Icons.circle, color: Colors.orange),
      title: Text(title),
      trailing: Text('Statistic'),
      onTap: () {
        // Handle item tap
      },
    );
  }
}

class CircularPercentIndicator extends StatelessWidget {
  final double radius;
  final double lineWidth;
  final bool animation;
  final double percent;
  final Widget center;
  final CircularStrokeCap circularStrokeCap;
  final Color progressColor;

  const CircularPercentIndicator({
    required this.radius,
    required this.lineWidth,
    required this.animation,
    required this.percent,
    required this.center,
    required this.circularStrokeCap,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: radius,
          width: radius,
          child: CircularProgressIndicator(
            strokeWidth: lineWidth,
            value: percent,
            color: progressColor,
          ),
        ),
        center,
      ],
    );
  }
}

enum CircularStrokeCap {
  round,
  butt,
}
