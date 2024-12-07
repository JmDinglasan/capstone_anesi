import 'dart:convert';
import 'package:capstone_anesi/constant.dart';
import 'package:capstone_anesi/manageScreen/Add_Products/addCoffee.dart';
import 'package:capstone_anesi/manageScreen/Add_Products/addMeals.dart';
import 'package:capstone_anesi/manageScreen/Add_Products/addNoodles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainAddProduct extends StatefulWidget {
  final List<Map<String, dynamic>> allItems;
  final Function(Map<String, dynamic>) updateItems;

  const MainAddProduct({
    super.key,
    required this.allItems,
    required this.updateItems,
  });

  @override
  _MainAddProduct createState() => _MainAddProduct();
}

class _MainAddProduct extends State<MainAddProduct> {
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Load the products when the screen is initialized
    filteredItems = List.from(allItems); // Initially show all items
  }

  // Function to update the allItems list from AddProductForm
  void _updateItems(Map<String, dynamic> newProduct) {
    setState(() {
      allItems.add(newProduct);
      filteredItems = List.from(allItems); // Update filtered items
      _saveProducts(); // Save the updated list to SharedPreferences
    });
  }

  // Save products to SharedPreferences
  Future<void> _saveProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encoded = json.encode(allItems); // Convert list to JSON string
    await prefs.setString('products', encoded); // Save it
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
      title: const Text(
        'Create Products',
        style: TextStyle(
          color: Colors.white, // Set the title color to white
        ),
      ),
      centerTitle: true,
      elevation: 4,
      backgroundColor: kprimaryColor, // Green color for the app bar
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity, // Adjust width as needed for responsiveness
          constraints: BoxConstraints(
            maxWidth: 600, // Maximum width for larger screens
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Introductory text
                 Text(
                  'Choose a category to add a new product:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[800], // Darker green for the text
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Button container for better alignment and scrolling
                Expanded(
                  child: ListView(
                    children: [
                      // Button for adding a drink product
                      _buildProductButton(
                        icon: Icons.local_drink,
                        label: 'Add New Drink Product',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProductForm(
                                allItems: allItems,
                                updateItems: _updateItems,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Button for adding noodles product
                      _buildProductButton(
                        icon: Icons.fastfood,
                        label: 'Add New Noodles Product',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProductFormNoodles(
                                allItems: allItems,
                                updateItems: _updateItems,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Button for adding meal/snack product
                      _buildProductButton(
                        icon: Icons.restaurant_menu,
                        label: 'Add New Meal / Snack Product',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProductFormMeals(
                                allItems: allItems,
                                updateItems: _updateItems,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// A helper method to create buttons with consistent styling
  Widget _buildProductButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: kprimaryColor, // Green background color
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      onPressed: onPressed,
    );
  }

}
