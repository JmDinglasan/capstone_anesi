import 'dart:convert';
import 'package:capstone_anesi/cartScreen/cartmodel.dart';
import 'package:capstone_anesi/inventoryScreen/inventorymodel.dart';
// import 'package:capstone_anesi/productScreen/CRUD_Drinks/deleteCoffee.dart';
// import 'package:capstone_anesi/productScreen/CRUD_Drinks/editCoffee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_anesi/cartScreen/cart.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Noodles extends StatefulWidget {
  const Noodles({super.key});

  @override
  _NoodlesState createState() => _NoodlesState();
}

class _NoodlesState extends State<Noodles> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> allItems = [
    {
      'name': 'Cheesy Spicy Samyang Noodles',
      'price': 150.00,
      'category': 'SOLO',
      'minMeltedCheese': 35,
      'minCSN': 1
    },
  ];

  List<Map<String, dynamic>> filteredItems = [];

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
        title: const Text('Noodles'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Determine whether to use grid or list based on screen width
            final isWideScreen = constraints.maxWidth > 600;
            final isSmallScreen = constraints.maxWidth <= 600;

            return Column(
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
                      _buildSection('NOODLES', isWideScreen, isSmallScreen),
                      const SizedBox(height: 35),
                      _buildSection('PASTA', isWideScreen, isSmallScreen),
                      const SizedBox(height: 35),
                      _buildSection('ADD-ONS', isWideScreen, isSmallScreen),
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(String category, bool isWideScreen, bool isSmallScreen) {
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
        // Adjust the grid based on screen size
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isSmallScreen
                ? 2
                : (isWideScreen
                    ? 5
                    : 2), // 2 items on mobile, 4 on wide screens
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
              minMeltedCheese: item['minMeltedCheese'] ?? 0,
              minCSN: item['minCSN'] ?? 0,
              minCSC: item['minCSC'] ?? 0,
              minCN: item['minCN'] ?? 0,
              minEgg: item['minEgg'] ?? 0,
              minSpam: item['minSpam'] ?? 0,
              minKaraage: item['minKaraage'] ?? 0,
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
  final int minMeltedCheese;
  final int minCSN;
  final int minCSC;
  final int minCN;
  final int minEgg;
  final int minSpam;
  final int minKaraage;
  final int index; // Added index to identify the product

  const CoffeeCard({
    super.key,
    required this.name,
    required this.price,
    this.minMeltedCheese = 0,
    this.minCSN = 0,
    this.minCSC = 0,
    this.minCN = 0,
    this.minEgg = 0,
    this.minSpam = 0,
    this.minKaraage = 0,
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
      'Melted Cheese': widget.minMeltedCheese,
      'Cheesy Spicy Samyang Noodles': widget.minCSN,
      'Cheesy Spicy Samyang Carbonara': widget.minCSC,
      'Cheesy Samyang Noodles': widget.minCN,
      'Egg': widget.minEgg,
      'Spam': widget.minSpam,
      'Chicken Karaage': widget.minKaraage,
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

