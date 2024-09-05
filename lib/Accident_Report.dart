import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omni/Home.dart';

class AccidentReportPage extends StatefulWidget {
  @override
  _AccidentReportPageState createState() => _AccidentReportPageState();
}

class _AccidentReportPageState extends State<AccidentReportPage> {
  int _selectedIndex = 0;
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

  LatLng _initialPosition = LatLng(13.7563, 100.5018); // Bangkok
  LatLng _selectedPosition = LatLng(13.7563, 100.5018);
  GoogleMapController? _mapController;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _pickImage() async {
    try {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการเลือกภาพ: $e')));
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _images.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการถ่ายภาพ: $e')));
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.5.50.82/omni/Accident_report.php'));

      request.fields['category'] = _selectedCategory;
      request.fields['headline'] = _nameController.text;
      request.fields['date'] = _dateController.text;
      request.fields['details'] = _detailsController.text;
      request.fields['accident_vehicle'] = _vehicleController.text;
      request.fields['accident_distance'] = _distanceController.text;
      request.fields['accident_time'] = _timeController.text;
      request.fields['accident_location'] = _locationController.text;
      request.fields['latitude'] = _selectedPosition.latitude.toString();
      request.fields['longitude'] = _selectedPosition.longitude.toString();

      // Upload only one image (first image if exists)
      if (_images.isNotEmpty) {
        request.files.add(
            await http.MultipartFile.fromPath('image', _images.first.path));
      }

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          var responseData = json.decode(responseBody);
          if (responseData['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('รายงานอุบัติเหตุถูกส่งสำเร็จ')));
            // นำทางไปยังหน้าถัดไป เช่น InfoPage
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

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedPosition = position;
      _mapController?.animateCamera(CameraUpdate.newLatLng(position));
    });
  }

  Widget _buildTextField(
      TextEditingController controller, String labelText, IconData icon,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(fontSize: 18),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณาใส่$labelText';
        }
        return null;
      },
    );
  }

  Widget _buildGoogleMap() {
    return SizedBox(
      height: 200,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 14.0,
        ),
        onTap: _onMapTap,
      ),
    );
  }

  Widget _buildImagePreview() {
    return _images.isNotEmpty
        ? GridView.builder(
            shrinkWrap: true,
            itemCount: _images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Image.file(_images[index], fit: BoxFit.cover);
            },
          )
        : Container();
  }

  Widget _buildImageButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _pickImage,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo),
                SizedBox(width: 8),
                Text('เพิ่มรูปภาพ', style: TextStyle(color: Colors.orange)),
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
                Text('ถ่ายภาพ', style: TextStyle(color: Colors.orange)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายงานอุบัติเหตุ',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
                  labelStyle: TextStyle(fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                value: _selectedCategory == 'กรุณาเลือกประเภทอุบัติเหตุ'
                    ? null
                    : _selectedCategory,
                hint: Text('กรุณาเลือกประเภทอุบัติเหตุ'),
                items: <String>[
                  'อุบัติเหตุจากรถยนต์',
                  'อุบัติเหตุจากจักรยานยนต์',
                  'อุบัติเหตุจากจักรยาน',
                  'อุบัติเหตุจากคนเดินเท้า'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณาเลือกประเภทอุบัติเหตุ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildTextField(_nameController, 'หัวข้อ', Icons.edit),
              SizedBox(height: 16),
              _buildTextField(_dateController, 'วันที่', Icons.calendar_today),
              SizedBox(height: 16),
              _buildTextField(_timeController, 'เวลา', Icons.access_time),
              SizedBox(height: 16),
              _buildTextField(
                  _vehicleController, 'ยานพาหนะ', Icons.directions_car),
              SizedBox(height: 16),
              _buildTextField(_distanceController, 'ระยะทาง', Icons.map),
              SizedBox(height: 16),
              _buildTextField(
                  _locationController, 'สถานที่', Icons.location_on),
              SizedBox(height: 16),
              _buildTextField(
                  _detailsController, 'รายละเอียด', Icons.description,
                  maxLines: 4),
              SizedBox(height: 16),
              _buildGoogleMap(),
              SizedBox(height: 16),
              _buildImageButtons(),
              SizedBox(height: 16),
              _buildImagePreview(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  'ส่งรายงาน',
                  style: TextStyle(color: Colors.orange),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box), label: 'รายงานอุบัติเหตุ'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }
}
