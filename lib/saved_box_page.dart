import 'package:flutter/material.dart';

class SavedBoxPage extends StatelessWidget {
  const SavedBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Box'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: const Center(
        child: Text(
          'This is the Saved Box Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
