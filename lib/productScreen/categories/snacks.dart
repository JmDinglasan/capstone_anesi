import 'package:capstone_anesi/cartScreen/cartmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_anesi/cartScreen/cart.dart';
import 'package:capstone_anesi/constant.dart';

class Snacks extends StatefulWidget {
  const Snacks({super.key});

  @override
  _SnacksState createState() => _SnacksState();
}

class _SnacksState extends State<Snacks> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allItems = [
    {'name': 'Karaage Fries', 'price': 180.00, 'category': 'MEALS'},
    {'name': 'Sriracha Spam Garlic Rice', 'price': 180.00, 'category': 'MEALS'},
    {'name': 'Chicken Karaage Rice', 'price': 155.00, 'category': 'MEALS'},
    {'name': 'Cheesy Fries', 'price': 125.00, 'category': 'SNACKS'},
    {'name': 'Chicken Karaage (6 pcs)', 'price': 130.00, 'category': 'SNACKS'},
    {'name': 'Salted Fries', 'price': 90.00, 'category': 'SNACKS'},
    {'name': 'Egg', 'price': 25.00, 'category': 'ADD-ONS'},
    {'name': 'Spam Slice', 'price': 30.00, 'category': 'ADD-ONS'},
    {'name': 'Chicken Karaage (3pcs)', 'price': 50.00, 'category': 'ADD-ONS'},
    {'name': 'Extra Cheese Sauce', 'price': 40.00, 'category': 'ADD-ONS'},
  ];

  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(allItems); // Initially show all items
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredItems = allItems
          .where((item) => item['name'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals/Snacks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Menu...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildSection('MEALS'),
                  const SizedBox(height: 35),
                  _buildSection('SNACKS'),
                  const SizedBox(height: 35),
                  _buildSection('ADD-ONS'),
                ],
              ),
            ),
            Consumer<CartModel>(
              builder: (context, cartModel, child) {
                return cartModel.items.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.grey[200],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.shopping_cart),
                                const SizedBox(width: 8),
                                Text('${cartModel.items.length} Items'),
                              ],
                            ),
                            Text(
                                'Total: ${cartModel.totalPrice.toStringAsFixed(2)}'),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Carts(),
                                  ),
                                );
                              },
                              child: const Text('Go to Cart'),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String category) {
    final categoryItems =
        filteredItems.where((item) => item['category'] == category).toList();

    if (categoryItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.5,
          ),
          itemCount: categoryItems.length,
          itemBuilder: (context, index) {
            final item = categoryItems[index];
            return CoffeeCard(item['name'], item['price']);
          },
        ),
      ],
    );
  }
}

class CoffeeCard extends StatelessWidget {
  final String name;
  final double price;

  const CoffeeCard(this.name, this.price, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kprimaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            price.toStringAsFixed(2),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              Provider.of<CartModel>(context, listen: false).addToCart(name, price, addons: []);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 11, 91, 78),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
