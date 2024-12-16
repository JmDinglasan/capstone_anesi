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
      // 'name': 'Snickers Iced Coffee',
      // 'price': 130.00,
      // 'category': 'COFFEE',
      // 'minCoffee': 150,
      // 'minCaramel': 40,
      // 'minSweetener': 30,
      // 'minChoco': 20,
      // 'minIce': 15,
      // 'minMilk': 200
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
                      _buildSection('COFFEE', isWideScreen, isSmallScreen),
                      const SizedBox(height: 35),
                      _buildSection('NON-COFFEE', isWideScreen, isSmallScreen),
                      const SizedBox(height: 35),
                      _buildSection(
                          'ADD-ONS DRINKS', isWideScreen, isSmallScreen),
                      const SizedBox(height: 35),
                      _buildSection('TEA', isWideScreen, isSmallScreen),
                      const SizedBox(height: 35),
                      _buildSection('FRAPPUCCINO', isWideScreen, isSmallScreen),
                      const SizedBox(height: 35),
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
              index: index,
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
  final int index;

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
    required this.index,
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
      'Coffee': widget.minCoffee,
      'Milk': widget.minMilk,
      'Chocolate Syrup': widget.minChoco,
      'Caramel Syrup': widget.minCaramel,
      'Strawberry Syrup': widget.minStrawberry,
      'Ube Syrup': widget.minUbe,
      'Sweetener': widget.minSweetener,
      'Vanilla Syrup': widget.minVanilla,
      'White Chocolate Syrup': widget.minWhiteChoco,
      'Ice': widget.minIce,
      'deductionAmount': widget.deductionAmount,
    };

    return Container(
      decoration: BoxDecoration(
        color: kprimaryColor, // Replace with kprimaryColor if defined
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.name,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.price.toStringAsFixed(2),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
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
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
          const SizedBox(height: 30),
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
