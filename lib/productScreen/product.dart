import 'package:capstone_anesi/constant.dart';
import 'package:capstone_anesi/productScreen/categories/coffee.dart';
import 'package:capstone_anesi/productScreen/categories/noodles.dart';
import 'package:capstone_anesi/productScreen/categories/snacks.dart';
import 'package:flutter/material.dart';
import 'package:capstone_anesi/inventoryScreen/inventorymodel.dart';
import 'package:provider/provider.dart';

void checkAndShowLowStockDialog(BuildContext context) {
  final inventory = Provider.of<InventoryModel>(context, listen: false);

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

  for (String item in itemsToCheck) {
    int stock = inventory.getItemStock(item); // Get current stock level
    bool isLowStock = stock <= 50; // Define low-stock threshold

    if (isLowStock) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLowStockDialog2(context, item, stock);
      });
    }
  }
}

void _showLowStockDialog2(BuildContext context, String itemName, int stock) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: kprimaryColor,
              size: 28,
            ),
            SizedBox(width: 10),
            Text(
              'Low Stock Alert',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'The stock of "$itemName" is low.',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Current stock: $stock',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: kprimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'OK',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


class Product extends StatelessWidget {
  // Remove the `const` keyword from the constructor here.
  Product({super.key});

  @override
  Widget build(BuildContext context) {
    // Call the checkAndShowLowStockDialog function when the Product screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndShowLowStockDialog(context);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              // Categories
              Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              // Categories Column with padding on each card
              Column(
                 children: [
                  Center(
                    child: CategoryCard('DRINKS', 'assets/drinks.png', Coffee()),
                  ),
                  Center(
                    child: CategoryCard('NOODLES', 'assets/noodles.png', Noodles()),
                  ),
                  Center(
                    child: CategoryCard('MEALS / SNACKS', 'assets/snacks.png', Snacks()),
                  ),
                ],
              ),
              SizedBox(height: 16), // Added some space at the end
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Widget nextScreen;

  // Remove `const` to make this constructor non-constant
  CategoryCard(this.title, this.imagePath, this.nextScreen, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width *
            0.75, // Adjusted width to 90% of screen width
        margin:
            const EdgeInsets.symmetric(vertical: 8.0), // Space between cards
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 200, // Adjusted height for a smaller card
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
