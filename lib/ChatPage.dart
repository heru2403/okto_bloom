import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ChatDetailPage.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Map<String, String>> chatUsers = [];
  List<Map<String, String>> filteredChatUsers = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchChatUsers();
    searchController.addListener(_filterChatUsers);
  }

  Future<void> _fetchChatUsers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('https://payapp.web.id/get_users.php'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        if (decodedJson['user'] != null && decodedJson['user'].isNotEmpty) {
          final List<dynamic> data = decodedJson['user'];
          setState(() {
            chatUsers = data
                .map((item) => <String, String> {
                      "id": item["id"].toString(),
                      "name": item["username"],
                    })
                .toList();
            filteredChatUsers = chatUsers;
          });
        } else {
          setState(() {
            chatUsers = [];
          });
        }
      } else {
        print("Failed to fetch chat users. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching chat users: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterChatUsers() {
    setState(() {
      filteredChatUsers = chatUsers
          .where((user) => user['name']!
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "CHAT",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : chatUsers.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada pengguna yang dapat diajak chat.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Cari Kontak, Penjual, & Pesan",
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredChatUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredChatUsers[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://picsum.photos/200/200?random=$index'),
                                backgroundColor: Colors.grey.shade300,
                              ),
                              title: Text(
                                user['name']!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatDetailPage(
                                      userId: user['id']!,
                                      userName: user['name']!,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
