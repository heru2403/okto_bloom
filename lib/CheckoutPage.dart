import 'package:flutter/material.dart';
import 'package:okto_bloom/AddressSettingPage.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;
  final Map<String, dynamic> selectedAddress;

  const CheckoutPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
    required this.selectedAddress,
  });

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late Map<String, dynamic> selectedAddress;

  @override
  void initState() {
    super.initState();
    selectedAddress = widget.selectedAddress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 175, 244),
        elevation: 1,
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/bg.png'), // Latar belakang
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Alamat Pengiriman
              Row(
                children: [
                  const Icon(Icons.location_pin, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${selectedAddress['name'] ?? 'Nama Tidak Tersedia'} (${selectedAddress['phone'] ?? 'Nomor Tidak Tersedia'})',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedAddress['address'] ?? 'Alamat Tidak Tersedia',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final updatedAddress = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddressSettingPage(),
                        ),
                      );
                      if (updatedAddress != null) {
                        setState(() {
                          selectedAddress = updatedAddress;
                        });
                      }
                    },
                  ),
                ],
              ),
              const Divider(height: 24),

              // Daftar Produk
              Expanded(
                child: ListView.builder(
                  itemCount: widget.cartItems.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = widget.cartItems[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200],
                            ),
                            child: Image.network(
                              item['image_url'] ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(item['name'] ?? 'Produk'),
                          subtitle: Text(
                              'Variation: ${item['color'] ?? 'No color'}\nQuantity: ${item['quantity'] ?? 0}'),
                          trailing: Text('Rp ${item['price']}'),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 16),

              // Opsi Pengiriman
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shipping Options'),
                  Row(
                    children: [
                      Icon(Icons.local_shipping, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Hemat', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Estimated Arrival: 24-25 Oct'),
                  Text('Rp 10.000', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(height: 16),

              // Pesan untuk Penjual
              const Row(
                children: [
                  Icon(Icons.message, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Message for Seller',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),

              // Total Order dan Metode Pembayaran
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Order:', style: TextStyle(fontSize: 16)),
                  Text(
                    'Rp ${widget.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payment Method'),
                  Text('COD', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),

              const SizedBox(height: 16),

              // Tombol Order Sekarang
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Logika untuk menempatkan pesanan
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[200],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Order Now',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
