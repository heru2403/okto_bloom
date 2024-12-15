import 'package:flutter/material.dart';
import 'dashboardpage.dart'; // Import the DashboardPage
import 'chatpage.dart'; // Import ChatPage
import 'notifikasiscreen.dart'; // Import the NotifikasiScreen
import 'saved_box_page.dart'; // Import the SavedBoxPage
import 'cartpage.dart'; // Import the CartPage

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(), // Halaman Home/Dashboard
    const CartPage(), // Halaman Keranjang/CartPage
    const ChatPage(), // Halaman Chat
    const NotifikasiScreen(), // Halaman Notifikasi
    const SavedBoxPage(), // Halaman Saved Box
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'), // Cart Tab
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Saved Box'),
        ],
      ),
    );
  }
}
