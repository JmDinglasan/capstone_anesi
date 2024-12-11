import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:capstone_anesi/cartScreen/cartmodel.dart';
//import 'package:capstone_anesi/manageScreen/manageStore.dart';
import 'package:capstone_anesi/cartScreen/cart.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:capstone_anesi/inventoryScreen/inventorymodel.dart';

class Coffee extends StatefulWidget {
  const Coffee({super.key});

  @override
  _CoffeeState createState() => _CoffeeState();
}

class _CoffeeState extends State<Coffee> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> allItems = [
    // Initial hardcoded items (as before)
    {
      'name': 'Snickers Iced Coffee',
      'price': 130.00,
      'category': 'COFFEE',
      'minCoffee': 150,
      'minCaramel': 40,
      'minSweetener': 30,
      'minChoco': 20,
      'minIce': 15,
      'minMilk': 200
    },
    // Add all other items here...
  ];

  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Load the products when the screen is initialized
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

  // Load products from SharedPreferences
  Future<void> _loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? productsJson = prefs.getString('products');
    if (productsJson != null) {
      List<dynamic> productList = json.decode(productsJson);
      setState(() {
        allItems = List<Map<String, dynamic>>.from(productList);
        filteredItems =
            List.from(allItems); // Ensure filtered items are updated
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drinks'),
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
                  _buildSection('COFFEE'),
                  const SizedBox(height: 35),
                  _buildSection('NON-COFFEE'),
                  const SizedBox(height: 35),
                  _buildSection('ADD-ONS DRINKS'),
                ],
              ),
            ),
            Consumer<CartModel>(builder: (context, cartModel, child) {
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
            }),
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
            mainAxisSpacing: 15,
            childAspectRatio: 0.89,
          ),
          itemCount: categoryItems.length,
          itemBuilder: (context, index) {
            final item = categoryItems[index];
            return CoffeeCard(
              name: item['name'],
              price: item['price'],
              minCoffee: item['minCoffee'] ?? 0,
              minSweetener: item['minSweetener'] ?? 0,
              minMilk: item['minMilk'] ?? 0,
              minCaramel: item['minCaramel'] ?? 0,
              minChoco: item['minChoco'] ?? 0,
              minStrawberry: item['minStrawberry'] ?? 0,
              minUbe: item['minUbe'] ?? 0,
              minWhiteChoco: item['minWhiteChoco'] ?? 0,
              minVanilla: item['minVanilla'] ?? 0,
              minIce: item['minIce'] ?? 0,
              deductionAmount: item['deductionAmount'] ?? 0,
              index: index, // Pass the index to identify which item to delete},
            );
          },
        ),
      ],
    );
  }
}

class CoffeeCard extends StatelessWidget {
  final String name;
  final double price;
  final int minCoffee;
  final int minMilk;
  final int minChoco;
  final int minCaramel;
  final int minStrawberry;
  final int minUbe;
  final int minVanilla;
  final int minWhiteChoco;
  final int minIce;
  final int minSweetener;
  final int deductionAmount;
  final int index; // Added index to identify the product

  const CoffeeCard({
    super.key,
    required this.name,
    required this.price,
    this.minCoffee = 0,
    this.minMilk = 0,
    this.minChoco = 0,
    this.minCaramel = 0,
    this.minStrawberry = 0,
    this.minUbe = 0,
    this.minVanilla = 0,
    this.minWhiteChoco = 0,
    this.minIce = 0,
    this.minSweetener = 0,
    this.deductionAmount = 0,
    required this.index, // Receive the index
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kprimaryColor, // Replace with kprimaryColor if defined
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            price.toStringAsFixed(2),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              // Add the product to the cart
              Provider.of<CartModel>(context, listen: false)
                  .addToCart(name, price);

              // Create a map of the ingredients with their amounts
              Map<String, int> ingredients = {
                'Coffee': minCoffee,
                'Milk': minMilk,
                'Chocolate Syrup': minChoco,
                'Caramel Syrup': minCaramel,
                'Strawberry Syrup': minStrawberry,
                'Ube Syrup': minUbe,
                'Sweetener': minSweetener,
                'Vanilla Syrup': minVanilla,
                'White Chocolate Syrup': minWhiteChoco,
                'Ice': minIce,
                'deductionAmount': deductionAmount,
              };

              // Deduct the ingredients from the inventory
              final inventory =
                  Provider.of<InventoryModel>(context, listen: false);
              for (var entry in ingredients.entries) {
                String ingredientName = entry.key;
                int amount = entry.value;

                if (amount > 0) {
                  await inventory.deductItem(ingredientName, amount);
                }
              }

              // Log or show a confirmation that the deduction occurred (optional)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("added to cart")),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 11, 91, 78),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Add'),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
