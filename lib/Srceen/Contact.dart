import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContactPage(),
      debugShowCheckedModeBanner: false, // ปิดคำว่า "Debug"
    );
  }
}

class ContactPage extends StatelessWidget {
  final List<Contact> contacts = [
    Contact('กรมป้องกันและบรรเทาสาธารณภัย', '1784'),
    Contact('การไฟฟ้านครหลวง', '1130'),
    Contact('การไฟฟ้าส่วนภูมิภาค', '1129'),
    Contact('กองปราบปราม', '1195'),
    Contact('กู้ชีพนเรนทร', '0 2354 8222'),
    Contact('แจ้งเหตุเพลิงไหม้', '199'),
    Contact('เหตุฉุกเฉินทางน้ำ', '1196'),
    Contact('แจ้งเหตุอาชญากรรม', '191'),
    Contact('แพทย์ฉุกเฉิน', '1669'),
    Contact('ศูนย์ควบคุมการจราจร', '1197'),
    Contact('ร่วมด้วยช่วยกัน', '1677'),
    Contact('อส.100', '1137'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              title: Text(contacts[index].name),
              subtitle: Text(contacts[index].number),
              trailing: IconButton(
                icon: Icon(Icons.phone),
                onPressed: () {
                  // Add your call functionality here
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: ''),
        ],
      ),
    );
  }
}

class Contact {
  final String name;
  final String number;

  Contact(this.name, this.number);
}
