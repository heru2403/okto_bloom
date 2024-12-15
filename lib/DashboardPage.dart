import 'package:flutter/material.dart';
import 'package:okto_bloom/DetailProductPage.dart';
import 'package:okto_bloom/MainPage.dart';
import 'package:okto_bloom/api/api_service.dart';
import 'package:okto_bloom/product_card.dart';
import 'package:okto_bloom/profile_page.dart'; // Import DetailProductPage

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ApiService apiService = ApiService();
  List<dynamic> products = [];
  bool isLoading = true;
  String errorMessage = '';

  List<String> categories = ["All", "Bouquet", "Custom"];
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    fetchProducts(''); // Load products initially
  }

  void fetchProducts(String searchQuery) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final data = await apiService.fetchProducts(searchQuery);
      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void fetchProductsByCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    String searchQuery = category == "All" ? '' : category;
    fetchProducts(searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.pink.shade100,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // Navigate to MainPage when menu icon is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const MainPage()), // Ensure you navigate correctly
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              // Navigate to ProfilePage when profile icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hallow semuanya",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Experience fashion with our shoe lineup",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.pink.shade50,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      onSubmitted: (value) {
                                        fetchProducts(value);
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Search",
                                        hintStyle:
                                            TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.search, color: Colors.black),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Rekomendasi",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: categories.map((category) {
                              bool isSelected = category == selectedCategory;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                  onTap: () =>
                                      fetchProductsByCategory(category),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.pink
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return GestureDetector(
                              onTap: () {
                                // Navigate to DetailProductPage when product is tapped
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailProductPage(
                                      product: product,
                                      productName: '',
                                      productImage: '',
                                      productPrice: '',
                                      productColor: '',
                                    ),
                                  ),
                                );
                              },
                              child: ProductCard(
                                image: product['image_url'],
                                name: product['name'],
                                price: "Rp. ${product['price']}",
                                product: const {},
                              ),
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
