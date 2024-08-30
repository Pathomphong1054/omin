import 'package:flutter/material.dart';
import 'package:omni/Splash_Screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omni Alarm',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// class BottomNavigation extends StatefulWidget {
//   const BottomNavigation({super.key});

//   @override
//   State<BottomNavigation> createState() => _BottomNavigationState();
// }
//
// class _BottomNavigationState extends State<BottomNavigation> {
//   int id = 0;
//   final List<Widget> screenpage = <Widget>[
//     AccidentReportPage(),
//     ChatPage(),
//     PresentPage(),
//     ProfilePage(),
//     ReportPage(),
//     LoginPage(),
//     SignUpPage(),
//     SplashScreenPage(),
//     NewsPage(),
//     MenuPage(),
//     HomePage(),
//     OfficerPage()
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }
