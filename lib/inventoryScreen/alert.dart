import 'package:capstone_anesi/inventoryScreen/inventorymodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Function to show a low stock dialog
void checkAndShowLowStockDialog(BuildContext context) {
  // Access the InventoryModel from the context
  final inventory = Provider.of<InventoryModel>(context, listen: false);

  // List of items to check for low stock
  List<String> itemsToCheck = [
    'Coffee',
    'Ice',
    'Chocolate Syrup',
    'Caramel Syrup',
    'Ube Syrup',
    'Strawberry Syrup',
    'Milk',
    'White Chocolate Syrup',
    'Vanilla Syrup',
    'Sweetener',
    'Melted Cheese',
    'Fries',
    'Cheesy Spicy Samyang Noodles',
    'Cheesy Spicy Samyang Carbonara',
    'Cheesy Samyang Noodles',
    'Chicken Karaage',
    'Spam',
    'Egg',
    'Nori',
  ];

  // Check stock for each item and show alert if it's low
  for (String item in itemsToCheck) {
    int stock = inventory.getItemStock(item); // Get current stock level
    bool isLowStock = stock <= 100; // Define low-stock threshold

    // If stock is low, show the dialog
    if (isLowStock) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLowStockDialog(context, item, stock);
      });
    }
  }
}

// Function to display the low stock dialog
void _showLowStockDialog(BuildContext context, String itemName, int stock) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Low Stock Alert"),
      content: Text(
        "The stock for '$itemName' is low. Current stock level: $stock.",
        style: TextStyle(color: Colors.black87),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "OK",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
