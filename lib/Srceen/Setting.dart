import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  bool nightModeEnabled = false;
  double fontSize = 50;
  String securitySetting = 'High';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button press
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Handle search button press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('ความเป็นส่วนตัว', 'แก้ไขข้อมูล โปรไฟล์ ชื่อ ข้อมูลต่างๆ และตรวจสอบข้อมูลให้ถูกต้อง'),
            _buildTextField('ชื่อ', 'PANITA PINATHA'),
            _buildTextField('Email', 'warren.01@gmail.com'),
            _buildTextField('ที่อยู่', 'จ.บางบก จ.มหาสารคาม'),
            _buildTextField('เบอร์โทรศัพท์', '0647657562'),
            SizedBox(height: 20),
            _buildSwitch('การแจ้งเตือน', notificationsEnabled, (value) {
              setState(() {
                notificationsEnabled = value;
              });
            }),
            _buildSwitch('โหมด', nightModeEnabled, (value) {
              setState(() {
                nightModeEnabled = value;
              });
            }),
            SizedBox(height: 20),
            _buildSlider('ขนาดตัวอักษร', fontSize, 0, 100, (value) {
              setState(() {
                fontSize = value;
              });
            }),
            SizedBox(height: 20),
            _buildDropdown('การตั้งค่าความปลอดภัย', securitySetting, [
              'High',
              'Medium',
              'Low'
            ], (value) {
              setState(() {
                securitySetting = value!;
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return ListTile(
      leading: Icon(Icons.security, color: Colors.black),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildTextField(String label, String initialValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        controller: TextEditingController(text: initialValue),
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSlider(String title, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: 100,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdown(String title, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        DropdownButton<String>(
          value: value,
          isExpanded: true,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
