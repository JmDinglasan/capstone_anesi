import 'dart:convert';

import 'package:capstone_anesi/cartScreen/cartmodel.dart';
import 'package:capstone_anesi/inventoryScreen/inventorymodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_anesi/cartScreen/cart.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Snacks extends StatefulWidget {
  const Snacks({super.key});

  @override
  _SnacksState createState() => _SnacksState();
}

class _SnacksState extends State<Snacks> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allItems = [
    {
      'name': 'Karaage Fries',
      'price': 180.00,
      'category': 'MEALS',
      'minKaraage': 5
    },
    // {'name': 'Sriracha Spam Garlic Rice', 'price': 180.00, 'category': 'MEALS', 'minSpam': 3},
    // {'name': 'Chicken Karaage Rice', 'price': 155.00, 'category': 'MEALS', 'minKaraage': 4},
    // {'name': 'Cheesy Fries', 'price': 125.00, 'category': 'SNACKS', 'minFries': 250},
    // {'name': 'Chicken Karaage (6 pcs)', 'price': 130.00, 'category': 'SNACKS', 'minKaraage': 6},
    // {'name': 'Salted Fries', 'price': 90.00, 'category': 'SNACKS', 'minFries': 250},

    // {'name': 'Egg', 'price': 25.00, 'category': 'ADD-ONS', 'minEgg': 1},
    // {'name': 'Spam Slice', 'price': 30.00, 'category': 'ADD-ONS', 'minSpam': 1},
    // {'name': 'Extra Cheese Sauce', 'price': 40.00, 'category': 'ADD-ONS', 'minMeltedCheese': 35},
    // {'name': 'Nori', 'price': 20.00, 'category': 'ADD-ONS', 'minNori': 1},
  ];

  List<Map<String, dynamic>> filteredItems = [];
  final List<Map<String, dynamic>> _ingredients = [];

  void _addIngredient(String name, int initialStock) {
    setState(() {
      _ingredients.add({'name': name, 'stock': initialStock});
    });
  }

  void _deductStock(String ingredientName, int deductionAmount) {
    setState(() {
      for (var ingredient in _ingredients) {
        if (ingredient['name'] == ingredientName) {
          int currentStock = ingredient['stock'];
          int newStock = currentStock - deductionAmount;
          ingredient['stock'] =
              newStock < 0 ? 0 : newStock; // Ensure stock doesn't go negative
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
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
      title: const Text('Meals/Snacks'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ),
    body: Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05), // Adjust padding for responsiveness
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
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
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
                          Text('Total: ${cartModel.totalPrice.toStringAsFixed(2)}'),
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
      // Responsive GridView
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 2, // 3 items per row on large screens, 2 on small
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
          childAspectRatio: 0.75,
        ),
        itemCount: categoryItems.length,
        itemBuilder: (context, index) {
          final item = categoryItems[index];
          return CoffeeCard(
            name: item['name'],
            price: item['price'],
            minCheese: item['minCheese'] ?? 0,
            minEgg: item['minEgg'] ?? 0,
            minSpam: item['minSpam'] ?? 0,
            minKaraage: item['minKaraage'] ?? 0,
            minNori: item['minNori'] ?? 0,
            minFries: item['minFries'] ?? 0,
            index: index, // Pass the index to identify which item to delete
          );
        },
      ),
    ],
  );
}

}

class CoffeeCard extends StatefulWidget {
  final String name;
  final double price;
  final int minCheese;
  final int minEgg;
  final int minSpam;
  final int minKaraage;
  final int minNori;
  final int minFries;
  final int index; // Added index to identify the product

  const CoffeeCard({
    super.key,
    required this.name,
    required this.price,
    this.minCheese = 0,
    this.minFries = 0,
    this.minEgg = 0,
    this.minSpam = 0,
    this.minKaraage = 0,
    this.minNori = 0,
    required this.index, // Receive the index
  });

  @override
  _CoffeeCardState createState() => _CoffeeCardState();
}

class _CoffeeCardState extends State<CoffeeCard> {
  bool _isStockSufficient = true; // Track stock availability

  @override
  Widget build(BuildContext context) {
    // Create a map of ingredients with their amounts
    Map<String, int> ingredients = {
      'Cheese': widget.minCheese,
      'Egg': widget.minEgg,
      'Spam': widget.minSpam,
      'Chicken Karaage': widget.minKaraage,
      'Nori': widget.minNori,
      'Fries': widget.minFries,
    };

    return Container(
      decoration: BoxDecoration(
        color: kprimaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Vertically center the content
        crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center the content
        children: [
          Text(
            widget.name,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            widget.price.toStringAsFixed(2),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: _isStockSufficient
                ? () async {
                    // Check if stock is sufficient before proceeding
                    bool stockAvailable =
                        await _checkStockAvailability(ingredients, context);

                    if (!stockAvailable) {
                      // If stock is insufficient, show the dialog
                      _showOutOfStockDialog(context);
                    } else {
                      // Add product to cart and deduct ingredients if stock is sufficient
                      Provider.of<CartModel>(context, listen: false)
                          .addToCart(widget.name, widget.price);

                      // Deduct ingredients from the inventory
                      final inventory =
                          Provider.of<InventoryModel>(context, listen: false);
                      for (var entry in ingredients.entries) {
                        String ingredientName = entry.key;
                        int amount = entry.value;

                        if (amount > 0) {
                          await inventory.deductItem(ingredientName, amount);
                        }
                      }

                      // Show confirmation message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Added to cart")),
                      );
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: _isStockSufficient
                  ? const Color.fromARGB(255, 11, 91, 78)
                  : Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _isStockSufficient ? 'Add' : 'Out of stock',
              style: TextStyle(
                color: _isStockSufficient ? Colors.white : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to show the "Out of Stock" dialog
  void _showOutOfStockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Insufficient Ingredients"),
          content: const Text("Sorry, this product is out of stock or ingredients are insufficient."),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Reload the page or refresh the button by changing the state
                setState(() {
                  _isStockSufficient = false; // Button becomes disabled
                });
              },
            ),
          ],
        );
      },
    );
  }

  // Modified _checkStockAvailability to check against local inventory
  Future<bool> _checkStockAvailability(
      Map<String, int> ingredients, BuildContext context) async {
    final inventory = Provider.of<InventoryModel>(context, listen: false);

    // Check the stock of each ingredient
    for (var entry in ingredients.entries) {
      String ingredientName = entry.key;
      int requiredAmount = entry.value;

      if (requiredAmount > 0) {
        // Get current stock from local inventory (no need to query Firestore)
        int currentStock = inventory.getItemStock(ingredientName);

        if (currentStock < requiredAmount) {
          return false; // If any ingredient has insufficient stock
        }
      }
    }
    return true; // All ingredients are sufficient
  }
}
