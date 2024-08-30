import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'Home.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameSurnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? selectedGender;
  String? selectedAgencyId;

  bool _obscureText = true;
  bool _obscureConfirmText = true;

  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> register(BuildContext context) async {
    final String userType = 'User';
    final String user_nameSurname = _nameSurnameController.text;
    final String user_email = _emailController.text;
    final String user_password = _passwordController.text;
    final String user_confirmPassword = _confirmPasswordController.text;
    final String user_gender = selectedGender ?? '';
    final String user_birthday = _birthdayController.text;
    final String user_phone = _phoneController.text;
    final String user_address = _addressController.text;
    final String user_agency = selectedAgencyId ?? '';

    if (user_nameSurname.isEmpty ||
        user_email.isEmpty ||
        user_password.isEmpty ||
        user_confirmPassword.isEmpty ||
        user_gender.isEmpty ||
        user_birthday.isEmpty ||
        user_phone.isEmpty ||
        user_address.isEmpty ||
        user_agency.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')));
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.5.50.82/omni/Register_users.php'),
    );

    request.fields['userType'] = userType;
    request.fields['name_surname'] = user_nameSurname;
    request.fields['email'] = user_email;
    request.fields['password'] = user_password;
    request.fields['confirm_password'] = user_confirmPassword;
    request.fields['gender'] = user_gender;
    request.fields['birthday'] = user_birthday;
    request.fields['phone'] = user_phone;
    request.fields['address'] = user_address;
    request.fields['agency'] = user_agency;

    if (_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', _image!.path),
      );
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      int userId = jsonResponse['user_id'] ?? 0;

      if (jsonResponse['status'] == 'success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userName: user_nameSurname,
              userId: userId,
              userType: 'user',
              agencyData: {},
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse['message'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server error: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _nameSurnameController,
                    labelText: 'Name-Surname',
                    icon: Icons.person,
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                  ),
                  SizedBox(height: 16.0),
                  _buildDropdownField(
                    labelText: 'Gender',
                    icon: Icons.wc_rounded,
                    items: [
                      'Male',
                      'Female',
                      'Other',
                    ],
                    selectedValue: selectedGender,
                    onChanged: (newValue) {
                      setState(() {
                        selectedGender = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _birthdayController,
                    labelText: 'Birthday (YYYY-MM-DD)',
                    icon: Icons.cake,
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _phoneController,
                    labelText: 'Phone',
                    icon: Icons.phone,
                  ),
                  SizedBox(height: 16.0),
                  _buildDropdownField(
                    labelText: 'Agency',
                    icon: Icons.business,
                    items: [
                      {'id': '1', 'name': 'หน่วยงานที่เกี่ยวข้องที่ 1'},
                      {'id': '2', 'name': 'หน่วยงานที่เกี่ยวข้องที่ 2'},
                      {'id': '3', 'name': 'หน่วยงานที่เกี่ยวข้องที่ 3'},
                      {'id': '4', 'name': 'หน่วยงานที่เกี่ยวข้องที่ 4'},
                      {'id': '5', 'name': 'หน่วยงานที่เกี่ยวข้องที่ 5'},
                    ],
                    selectedValue: selectedAgencyId,
                    onChanged: (newValue) {
                      setState(() {
                        selectedAgencyId = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField(
                    controller: _addressController,
                    labelText: 'Address',
                    icon: Icons.home,
                  ),
                  SizedBox(height: 16.0),
                  _buildPasswordField(
                    controller: _passwordController,
                    labelText: 'Password',
                    obscureText: _obscureText,
                    toggleObscureText: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    obscureText: _obscureConfirmText,
                    toggleObscureText: () {
                      setState(() {
                        _obscureConfirmText = !_obscureConfirmText;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  if (_image != null)
                    Image.file(_image!, height: 200, width: 200)
                  else
                    Icon(Icons.image, size: 200, color: Colors.grey[300]),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _pickImage,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.photo),
                              SizedBox(width: 8),
                              Text('เพิ่มรูปภาพ',
                                  style: TextStyle(color: Colors.orange)),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _takePhoto,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera),
                              SizedBox(width: 8),
                              Text('ถ่ายภาพ',
                                  style: TextStyle(color: Colors.orange)),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  _buildSignUpButton(context),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Forgot your password?',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอก$labelText';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required VoidCallback toggleObscureText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.orange,
          ),
          onPressed: toggleObscureText,
        ),
        prefixIcon: Icon(Icons.lock),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอก$labelText';
        }
        if (labelText == 'Confirm Password' &&
            value != _passwordController.text) {
          return 'รหัสผ่านไม่ตรงกัน';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField({
    required String labelText,
    required IconData icon,
    required List<dynamic> items,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: Text('$labelText'),
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        prefixIcon: Icon(icon),
      ),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((dynamic value) {
        if (value is String) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        } else if (value is Map<String, String>) {
          return DropdownMenuItem<String>(
            value: value['id'],
            child: Text(value['name']!),
          );
        } else {
          throw Exception('Invalid item type');
        }
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณาเลือก$labelText';
        }
        return null;
      },
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            register(context);
          }
        },
        child: Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0),
        ),
      ),
    );
  }
}
