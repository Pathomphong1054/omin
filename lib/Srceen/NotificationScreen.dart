import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.5.50.82/omni/fetch_notifications.php'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          notifications = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Failed to load notifications');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: notifications.isEmpty
          ? Center(child: Text('No notifications available'))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Accident Report',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Accident reported: ${notification['accident_name']},',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Location: ${notification['accident_location']},',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Time: ${notification['accident_time']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Details: ${notification['accident_details']}',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        notification['accident_image'] != null
                            ? Image.network(
                                'http://10.5.50.82/omni/' +
                                    notification['accident_image'],
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print(
                                      'Error loading image: http://10.5.50.82/omni/' +
                                          notification['accident_image']);
                                  return Icon(Icons.broken_image, size: 100);
                                },
                              )
                            : Icon(Icons.image, size: 100),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            notification['created_at'],
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
