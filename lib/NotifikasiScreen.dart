import 'package:flutter/material.dart';
import 'package:okto_bloom/CartPage.dart';
import 'package:okto_bloom/ChatPage.dart';

class NotifikasiScreen extends StatelessWidget {
  const NotifikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Tombol untuk membuka ChatPage
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatPage()),
              );
            },
          ),
          // Tombol untuk membuka CartPage
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildNotificationItem(
            context,
            icon: Icons.local_offer,
            iconColor: Colors.red,
            title: 'Promo Spesial untuk Kamu!',
            description:
                'Dapatkan diskon hingga 50% untuk produk pilihan. Berlaku sampai 31 Desember!',
            date: '2 jam yang lalu',
          ),
          const Divider(height: 30, thickness: 1, color: Colors.grey),
          _buildNotificationItem(
            context,
            icon: Icons.delivery_dining,
            iconColor: Colors.green,
            title: 'Pesanan Sedang Dikirim',
            description: 'Pesanan #123456 sedang dalam perjalanan.',
            date: '5 jam yang lalu',
          ),
          const Divider(height: 30, thickness: 1, color: Colors.grey),
          _buildNotificationItem(
            context,
            icon: Icons.wallet,
            iconColor: Colors.orange,
            title: 'Top Up Berhasil',
            description: 'Top up saldo sebesar Rp100.000 telah berhasil.',
            date: '1 hari yang lalu',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context,
      {required IconData icon,
      required Color iconColor,
      required String title,
      required String description,
      required String date}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
