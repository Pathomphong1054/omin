import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatPage extends StatefulWidget {
  final int groupId;
  final String groupName;
  final int userId;
  final String userName;

  ChatPage({
    required this.groupId,
    required this.groupName,
    required this.userId,
    required this.userName,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, dynamic>> messages = [];
  TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    final response = await http.get(Uri.parse(
        'http://10.5.50.82/omni/fetch_messages.php?group_id=${widget.groupId}'));

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          var decoded = json.decode(response.body);
          if (decoded is List) {
            messages = List<Map<String, dynamic>>.from(decoded);
          } else if (decoded is Map) {
            messages = [Map<String, dynamic>.from(decoded)];
          }
        });

        // Scroll to the bottom of the list
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('http://10.5.50.82/omni/send_message.php'),
      body: {
        'group_id': widget.groupId.toString(),
        'user_id': widget.userId.toString(),
        'message': message,
      },
    );

    if (response.statusCode == 200) {
      _controller.clear();
      _fetchMessages();
    }
  }

  Future<void> _sendImage(File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.5.50.82/omni/send_message.php'),
    );
    request.fields['group_id'] = widget.groupId.toString();
    request.fields['user_id'] = widget.userId.toString();
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      _fetchMessages();
    }
  }

  void _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _sendImage(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isMe = message['user_id'] == widget.userId.toString();
                String? imageUrl = message['image_path']; // ดึง image_path
                print("Image URL for message $index: $imageUrl");
                return _buildMessage(
                  message['message'],
                  isMe,
                  message['profile_image'],
                  message['name'],
                  imageUrl, // ใช้ image_path สำหรับรูปภาพที่ส่ง
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(String message, bool isMe, String? profileImage,
      String name, String? imageUrl) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isMe && profileImage != null) ...[
                  CircleAvatar(
                    backgroundImage: profileImage.isNotEmpty
                        ? NetworkImage('http://10.5.50.82/omni/$profileImage')
                        : AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                    radius: 20,
                    onBackgroundImageError: (_, __) =>
                        Image.asset('assets/default_avatar.png'),
                  ),
                  SizedBox(width: 10),
                ],
                Container(
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blueAccent : Colors.grey[300],
                    borderRadius: isMe
                        ? BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          )
                        : BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'http://10.5.50.82/omni/$imageUrl',
                            fit: BoxFit.cover,
                            width: 200,
                            height: 300,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image,
                                  color: Colors.red);
                            },
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return CircularProgressIndicator(
                                value: progress.expectedTotalBytes != null
                                    ? progress.cumulativeBytesLoaded /
                                        progress.expectedTotalBytes!
                                    : null,
                              );
                            },
                          ),
                        )
                      : Text(
                          message,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                          ),
                        ),
                ),
                if (isMe && profileImage != null) ...[
                  SizedBox(width: 10),
                  CircleAvatar(
                    backgroundImage: profileImage.isNotEmpty
                        ? NetworkImage('http://10.5.50.82/omni/$profileImage')
                        : AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                    radius: 20,
                    onBackgroundImageError: (_, __) =>
                        Image.asset('assets/default_avatar.png'),
                  )
                ],
              ],
            ),
            SizedBox(height: 5),
            Text(
              name,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo_camera),
            color: Colors.blueAccent,
            onPressed: () {
              _pickImage(ImageSource.camera);
            },
          ),
          IconButton(
            icon: Icon(Icons.photo),
            color: Colors.blueAccent,
            onPressed: () {
              _pickImage(ImageSource.gallery);
            },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(
                hintText: 'Enter your message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Colors.blueAccent,
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                _sendMessage(_controller.text);
              }
            },
          ),
        ],
      ),
    );
  }
}
