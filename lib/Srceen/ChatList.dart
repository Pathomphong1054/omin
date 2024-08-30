import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatListPage(),
    );
  }
}

class ChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: ListView(
        children: [
          _buildChatItem(context, 'กรมป้องกันและบรรเทาสาธารณภัย', 'ข้อความใหม่', true),
          _buildChatItem(context, 'การไฟฟ้านครหลวง', 'ข้อความใหม่', true),
          _buildChatItem(context, 'การไฟฟ้าส่วนภูมิภาค', 'ข้อความใหม่', true),
          _buildChatItem(context, 'กองปราบปราม', 'ข้อความใหม่', true),
          _buildChatItem(context, 'แพทย์ฉุกเฉิน', 'ข้อความใหม่', false),
          _buildChatItem(context, 'แจ้งเหตุเพลิงไหม้ใหม่', 'ข้อความใหม่', true),
          _buildChatItem(context, 'แจ้งเหตุอุบัติเหตุร้าย', 'ข้อความใหม่', true),
          _buildChatItem(context, 'แพทย์ฉุกเฉิน', 'ข้อความใหม่', false),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: '',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.show_chart),
      //       label: '',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.chat),
      //       label: '',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notifications),
      //       label: '',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: '',
      //     ),
      //   ],
      //   currentIndex: 2,
      //   selectedItemColor: Colors.orange,
      //   onTap: (index) {
      //     // Handle bottom navigation tap
      //   },
      // ),
    );
  }

  Widget _buildChatItem(BuildContext context, String title, String subtitle, bool isOnline) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isOnline ? Colors.green : Colors.grey,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text('8m ago'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatDetailScreen()),
        );
      },
    );
  }
}

class ChatDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('กู้ภัยอาสา'),
        leading: BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildChatBubble('รถตู้คันนี้อยากได้ข้าวใส่แกงฟาร์ม', false),
                _buildChatBubble('แต่ถ้าไม่ใช่คันไหนที่รถยนต์', true),
                _buildChatBubble('ถูกยางปัดและเข้าติดบันไดชั้นที่สาม', false),
                _buildChatBubble('งูพิษที่ถูกจับและนำส่งหน่วยพยาบาล', true),
                _buildChatBubble('อุบัติเหตุของรถยนต์เป็นการบันทึกอย่างไร', false),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: 2,
        selectedItemColor: Colors.orange,
        onTap: (index) {
          // Handle bottom navigation tap
        },
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isSender) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: isSender ? Colors.orangeAccent : Color.fromARGB(255, 175, 175, 175),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(text),
      ),
    );
  }
}
