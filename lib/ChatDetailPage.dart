import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatDetailPage extends StatefulWidget {
  final String userId;  // ID pengguna customer
  final String userName; // Nama pengguna customer

  const ChatDetailPage({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> messages = []; // Ubah tipe menjadi dynamic
  bool isLoading = false;
  String adminId = '2'; // ID admin yang login, bisa disesuaikan jika admin ID berubah

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  // Fungsi untuk mengambil pesan
  Future<void> _fetchMessages() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://payapp.web.id/get_messages.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': adminId, // ID admin yang login
          'partner_id': widget.userId, // ID customer yang dipilih
        }),
      );

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        if (decodedJson['messages'] != null) {
          setState(() {
            // Ubah list tipe data menjadi List<Map<String, dynamic>> agar bisa menangani berbagai tipe data
            messages = List<Map<String, dynamic>>.from(decodedJson['messages']);
          });
        }
      } else {
        print('Gagal mengambil pesan');
      }
    } catch (e) {
      print("Error fetching messages: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk mengirim pesan
  Future<void> _sendMessage() async {
    final message = messageController.text;
    if (message.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse('https://payapp.web.id/send_message.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'sender_id': adminId, // ID admin
          'receiver_id': widget.userId, // ID customer
          'message': message,
        }),
      );

      final result = json.decode(response.body);
      if (result['success']) {
        setState(() {
          // Menambahkan pesan yang dikirim ke dalam list pesan
          messages.add({
            'sender': 'Admin',
            'message': message,
            'sender_id': adminId,
            'receiver_id': widget.userId,
          });
        });
        messageController.clear();
        _fetchMessages();
      } else {
        print('Gagal mengirim pesan');
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isAdminMessage =
                          message['sender_id'] == adminId; // Cek apakah pesan dari admin
                      return ListTile(
                        title: Align(
                          alignment: isAdminMessage
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isAdminMessage
                                  ? Colors.green.shade100
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(message['message'] ?? ''),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: const InputDecoration(
                            hintText: 'Ketik pesan...',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
