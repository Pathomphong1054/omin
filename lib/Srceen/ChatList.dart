import 'package:flutter/material.dart';
import 'package:omni/Srceen/Chat.dart';

class ChatListPage extends StatelessWidget {
  final int userId;
  final String userName;

  ChatListPage({required this.userId, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildChatItem(
                context, 1, 'กรมป้องกันและบรรเทาสาธารณภัย', Icons.security),
            _buildChatItem(context, 2, 'การไฟฟ้านครหลวง', Icons.flash_on),
            _buildChatItem(context, 3, 'การไฟฟ้าส่วนภูมิภาค', Icons.flash_on),
            _buildChatItem(context, 4, 'กองปราบปราม', Icons.local_police),
            _buildChatItem(context, 5, 'แพทย์ฉุกเฉิน', Icons.local_hospital),
            _buildChatItem(
                context, 6, 'แจ้งเหตุเพลิงไหม้ใหม่', Icons.fireplace),
            _buildChatItem(context, 7, 'แจ้งเหตุอุบัติเหตุร้าย', Icons.warning),
            _buildChatItem(context, 8, 'แพทย์ฉุกเฉิน', Icons.local_hospital),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(
      BuildContext context, int groupId, String groupName, IconData icon) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        leading: CircleAvatar(
          backgroundColor: Colors.orangeAccent,
          child: Icon(icon, color: Colors.white, size: 28),
          radius: 28,
        ),
        title: Text(
          groupName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 1, // จำกัดบรรทัดเดียว
          overflow: TextOverflow.ellipsis, // แสดง ... เมื่อข้อความยาวเกินไป
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                groupId: groupId,
                groupName: groupName,
                userId: userId,
                userName: userName,
              ),
            ),
          );
        },
      ),
    );
  }
}
