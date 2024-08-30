import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final int userId;
  final String userType;

  ProfilePage({required this.userId, required this.userType});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isProfileSelected = true;
  File? _image;
  final picker = ImagePicker();

  // ข้อมูลโปรไฟล์
  String name = '';
  String birthdate = '';
  String gender = '';
  String agency = '';
  String email = '';
  String phone = '';
  String address = '';
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    String fetchUrl =
        'http://10.5.50.82/omni/Get_profile.php?id=${widget.userId}&type=${widget.userType}';
    print('กำลังดึงข้อมูลโปรไฟล์จาก: $fetchUrl');

    try {
      var response = await http.get(Uri.parse(fetchUrl));

      print('สถานะการตอบกลับ: ${response.statusCode}');
      print('เนื้อหาการตอบกลับ: "${response.body}"');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var responseData = json.decode(response.body);
        print('ข้อมูลการตอบกลับ: $responseData');

        if (responseData['status'] == 'success') {
          setState(() {
            var data = responseData['data'];
            name = data['name'] ?? 'ไม่ทราบชื่อ';
            email = data['email'] ?? 'ไม่มีอีเมล';
            phone = data['phone'] ?? 'ไม่มีเบอร์โทร';
            profileImageUrl = data['profile_image'] != null &&
                    data['profile_image'].isNotEmpty
                ? 'http://10.5.50.82/omni/' + data['profile_image']
                : 'http://10.5.50.82/omni/uploads/default.png';

            if (widget.userType == 'user') {
              birthdate = data['birthdate'] ?? 'ไม่มีวันเกิด';
              gender = data['gender'] ?? 'ไม่มีข้อมูลเพศ';
              agency = data['agency_id']?.toString() ?? 'ไม่มีหน่วยงาน';
              address = data['address'] ?? 'ไม่มีที่อยู่';
            }
          });
        } else {
          print('ข้อผิดพลาด: ${responseData['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('การดึงข้อมูลโปรไฟล์ล้มเหลว: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('ข้อผิดพลาดในการดึงข้อมูลโปรไฟล์: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ข้อผิดพลาดในการดึงข้อมูลโปรไฟล์')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('ไม่มีรูปภาพถูกเลือก.');
      }
    });
  }

  Future<void> _updateProfile() async {
    String updateUrl = 'http://10.5.50.82/omni/Update_profile.php';
    var request = http.MultipartRequest('POST', Uri.parse(updateUrl));

    // ใส่ข้อมูลผู้ใช้ลงในฟอร์ม
    request.fields['id'] = widget.userId.toString();
    request.fields['user_type'] = widget.userType;
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['phone'] = phone;

    if (_image != null) {
      request.files.add(
          await http.MultipartFile.fromPath('profile_image', _image!.path));
    }

    if (widget.userType == 'User') {
      request.fields['birthdate'] = birthdate;
      request.fields['gender'] = gender;
      request.fields['address'] = address;
    } else if (widget.userType == 'Agency') {
      request.fields['agency_details'] = agency;
    }

    try {
      var res = await request.send();
      var response = await http.Response.fromStream(res);

      if (res.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          setState(() {
            profileImageUrl = 'http://10.5.50.82/omni/uploads/profile_image/' +
                responseData['image_url'];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('อัปเดตรูปโปรไฟล์เรียบร้อยแล้ว')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('การอัปโหลดรูปภาพล้มเหลว: ${res.statusCode}')),
        );
      }
    } catch (e) {
      print('ข้อผิดพลาดในการอัปโหลดรูปภาพ: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ข้อผิดพลาดในการอัปโหลดรูปภาพ')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : NetworkImage(profileImageUrl) as ImageProvider,
                ),
              ),
              SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isProfileSelected = true;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              isProfileSelected ? Colors.orange : Colors.white,
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20)),
                        ),
                        child: Text(
                          widget.userType == 'user'
                              ? 'โปรไฟล์ผู้ใช้'
                              : 'โปรไฟล์หน่วยงาน',
                          style: TextStyle(
                            color:
                                isProfileSelected ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isProfileSelected = false;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color:
                              !isProfileSelected ? Colors.orange : Colors.white,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(20)),
                        ),
                        child: Text(
                          'แก้ไขโปรไฟล์',
                          style: TextStyle(
                            color:
                                !isProfileSelected ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              isProfileSelected ? _buildProfileView() : _buildEditProfileView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    return widget.userType == 'user'
        ? _buildUserProfileView()
        : _buildAgencyProfileView();
  }

  Widget _buildUserProfileView() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.cake),
          title: Text('วันเกิด'),
          subtitle: Text(birthdate),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('เพศ'),
          subtitle: Text(gender),
        ),
        ListTile(
          leading: Icon(Icons.business),
          title: Text('หน่วยงาน'),
          subtitle: Text(agency),
        ),
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text('ที่อยู่'),
          subtitle: Text(address),
        ),
        ListTile(
          leading: Icon(Icons.email),
          title: Text('อีเมล'),
          subtitle: Text(email),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('เบอร์โทร'),
          subtitle: Text(phone),
        ),
      ],
    );
  }

  Widget _buildAgencyProfileView() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.business),
          title: Text('ชื่อหน่วยงาน'),
          subtitle: Text(name),
        ),
        ListTile(
          leading: Icon(Icons.email),
          title: Text('อีเมล'),
          subtitle: Text(email),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text('เบอร์โทร'),
          subtitle: Text(phone),
        ),
      ],
    );
  }

  Widget _buildEditProfileView() {
    return widget.userType == 'user'
        ? _buildEditUserProfileView()
        : _buildEditAgencyProfileView();
  }

  Widget _buildEditUserProfileView() {
    return Column(
      children: [
        _buildTextField('ชื่อ', name, (value) => setState(() => name = value)),
        _buildTextField(
            'วันเกิด', birthdate, (value) => setState(() => birthdate = value)),
        _buildTextField(
            'เพศ', gender, (value) => setState(() => gender = value)),
        _buildTextField(
            'หน่วยงาน', agency, (value) => setState(() => agency = value)),
        _buildTextField(
            'ที่อยู่', address, (value) => setState(() => address = value)),
        _buildTextField(
            'อีเมล', email, (value) => setState(() => email = value)),
        _buildTextField(
            'เบอร์โทร', phone, (value) => setState(() => phone = value)),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _updateProfile,
          child: Text('บันทึก'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          ),
        ),
      ],
    );
  }

  Widget _buildEditAgencyProfileView() {
    return Column(
      children: [
        _buildTextField(
            'ชื่อหน่วยงาน', name, (value) => setState(() => name = value)),
        _buildTextField(
            'อีเมล', email, (value) => setState(() => email = value)),
        _buildTextField(
            'เบอร์โทร', phone, (value) => setState(() => phone = value)),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _updateProfile,
          child: Text('บันทึก'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label, String initialValue, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
