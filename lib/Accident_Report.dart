import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AccidentReportPage(),
      debugShowCheckedModeBanner: false, // ปิดคำว่า "Debug"
    );
  }
}

class AccidentReportPage extends StatefulWidget {
  @override
  _AccidentReportPageState createState() => _AccidentReportPageState();
}

class _AccidentReportPageState extends State<AccidentReportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  String _selectedCategory = 'กรุณาเลือกประเภทอุบัติเหตุ';

  Future<void> _pickImage() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('ไม่ได้เลือกรูปภาพ')));
    }
  }

  Future<void> _takePhoto() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.5.50.82/omni/Accident_report.php'));

      // ส่งข้อมูลฟอร์ม
      request.fields['category'] = _selectedCategory;
      request.fields['headline'] = _nameController.text;
      request.fields['date'] = _dateController.text;
      request.fields['details'] = _detailsController.text;
      request.fields['accident_vehicle'] = _vehicleController.text;
      request.fields['accident_distance'] = _distanceController.text;
      request.fields['accident_time'] = _timeController.text;
      request.fields['accident_location'] = _locationController.text;

      // เพิ่มรูปภาพลงใน request
      for (var image in _images) {
        request.files
            .add(await http.MultipartFile.fromPath('images[]', image.path));
      }

      try {
        var response = await request.send();

        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          var responseData = json.decode(responseBody);

          if (responseData['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('รายงานอุบัติเหตุถูกส่งสำเร็จ')));

            // After successful submission, send notification to server
            _sendNotificationToServer(responseData['notification_id']);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('เกิดข้อผิดพลาด: ${responseData['message']}')));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'เกิดข้อผิดพลาดในการส่งรายงาน (Status Code: ${response.statusCode})')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เกิดข้อผิดพลาดในการส่งรายงาน: $e')));
      }
    }
  }

  Future<void> _sendNotificationToServer(int notificationId) async {
    try {
      var response = await http.post(
        Uri.parse('http://10.5.50.82/omni/AddNotification.php'),
        body: {
          'user_id': '1', // แทนที่ด้วย user_id ของผู้ใช้ที่ล็อกอิน
          'notification_id': notificationId.toString(),
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          print('Notification saved successfully');
        } else {
          print('Error saving notification: ${responseData['message']}');
        }
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending notification to server: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายงานอุบัติเหตุ'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'หมวดหมู่',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                items: [
                  'กรุณาเลือกประเภทอุบัติเหตุ',
                  'อุบัติเหตุรถยนต์',
                  'อุบัติเหตุจากรถจักรยานยนต์',
                  'อุบัติเหตุจากรถบรรทุก',
                  'อุบัติเหตุจากรถไฟ'
                ]
                    .map((label) =>
                        DropdownMenuItem(child: Text(label), value: label))
                    .toList(),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'หัวข้อข่าว',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'กรุณาใส่หัวข้อข่าว';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'สถานที่เกิดเหตุ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'กรุณาใส่สถานที่เกิดเหตุ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'เวลาเกิดเหตุ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'กรุณาใส่เวลาเกิดเหตุ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _vehicleController,
                decoration: InputDecoration(
                  labelText: 'ยานพาหนะที่เกี่ยวข้อง',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'กรุณาใส่ยานพาหนะที่เกี่ยวข้อง';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _distanceController,
                decoration: InputDecoration(
                  labelText: 'ระยะห่าง',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'กรุณาใส่ระยะห่าง';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _detailsController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'รายละเอียด',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'กรุณาใส่รายละเอียด';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.image),
                    label: Text('เลือกรูปภาพจากแกลเลอรี'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _takePhoto,
                    icon: Icon(Icons.camera),
                    label: Text('ถ่ายภาพด้วยกล้อง'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('ส่งรายงาน'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
