// import 'package:flutter/material.dart';
// import 'dart:convert'; // สำหรับแปลงข้อมูล JSON
// import 'package:http/http.dart' as http; // สำหรับการเรียก API

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Road Accident Alerts',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AlertsPage(),
//     );
//   }
// }

// class AlertsPage extends StatefulWidget {
//   @override
//   _AlertsPageState createState() => _AlertsPageState();
// }

// class _AlertsPageState extends State<AlertsPage> {
//   List<dynamic> alerts = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchAlerts();
//   }

//   Future<void> fetchAlerts() async {
//   //   final response = await http.get(Uri.parse('https://api.example.com/alerts')); // แก้ไข URL ตามที่ใช้งานจริง
//   //   if (response.statusCode == 200) {
//   //     setState(() {
//   //       alerts = json.decode(response.body);
//   //     });
//   //   } else {
//   //     throw Exception('Failed to load alerts');
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Accident Alerts'),
//       ),
//       body: alerts.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: alerts.length,
//               itemBuilder: (context, index) {
//                 final alert = alerts[index];
//                 return ListTile(
//                   title: Text(alert['title']),
//                   subtitle: Text(alert['description']),
//                   trailing: Icon(Icons.warning, color: Colors.red),
//                 );
//               },
//             ),
//     );
//   }
// }
