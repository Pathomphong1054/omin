import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: OfficerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class OfficerPage extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<OfficerPage> {
  String? selectedGender;
  String? selectedDepartment;
  String? selectedAddress;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController profileImageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> submitForm() async {
    final response = await http.post(
      Uri.parse('http://10.5.50.82/omni/register_agency.php'),
      body: {
        'name': usernameController.text,
        'birthdate': birthdateController.text,
        'gender': selectedGender,
        'agency': selectedDepartment,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': selectedAddress,
        'profile_image':
            profileImageController.text, // ต้องจัดการตามข้อมูลรูปภาพที่ส่งมา
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      print('ส่งข้อมูลสำเร็จ');
    } else {
      print('การส่งข้อมูลล้มเหลว');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 246, 150, 7),
              Color.fromRGBO(239, 194, 44, 1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 75.0),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'ลงทะเบียน',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            SizedBox(height: 16),
            buildTextField('ชื่อผู้ใช้', Icons.person, usernameController),
            SizedBox(height: 8),
            buildTextField('วันเกิด', Icons.cake, birthdateController),
            SizedBox(height: 8),
            buildDropdownField(
              'เพศ',
              Icons.wc,
              ['ชาย', 'หญิง'],
              selectedGender,
              (newValue) {
                setState(() {
                  selectedGender = newValue;
                });
              },
            ),
            SizedBox(height: 8),
            buildTextField('Email', Icons.email, emailController),
            SizedBox(height: 8),
            buildTextField('เบอร์โทรศัพท์', Icons.phone, phoneController),
            SizedBox(height: 8),
            buildDropdownField(
              'หน่วยงาน',
              Icons.business,
              ['หน่วยงาน 1', 'หน่วยงาน 2', 'หน่วยงาน 3'],
              selectedDepartment,
              (newValue) {
                setState(() {
                  selectedDepartment = newValue;
                });
              },
            ),
            SizedBox(height: 8),
            buildDropdownField(
              'ที่อยู่',
              Icons.location_on,
              ['ที่อยู่ 1', 'ที่อยู่ 2', 'ที่อยู่ 3'],
              selectedAddress,
              (newValue) {
                setState(() {
                  selectedAddress = newValue;
                });
              },
            ),
            SizedBox(height: 8),
            buildTextField('รูปโปรไฟล์', Icons.image,
                profileImageController), // สำหรับการรับรูปโปรไฟล์
            SizedBox(height: 8),
            buildTextField('รหัสผ่าน', Icons.lock, passwordController,
                obscureText: true), // สำหรับการรับรหัสผ่าน
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 145, 0),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('ลงทะเบียน',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, IconData icon, TextEditingController controller,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      obscureText: obscureText,
    );
  }

  Widget buildDropdownField(String labelText, IconData icon, List<String> items,
      String? selectedItem, Function(String?) onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Row(
            children: [
              Icon(icon, color: Colors.grey),
              SizedBox(width: 12),
              Text(labelText, style: TextStyle(color: Colors.grey)),
            ],
          ),
          value: selectedItem,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
