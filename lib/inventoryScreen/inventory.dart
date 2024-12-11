import 'package:capstone_anesi/constant.dart';
import 'package:capstone_anesi/inventoryScreen/inventorymodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Stocks")),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [

          // DRINK INGREDIENTS TITLE
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Drink Ingredients',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // DRINK INGREDIENTS
          _buildInventoryItemForG(context, 'Coffee'),
          _buildInventoryItem(context, 'Chocolate Syrup'),
          _buildInventoryItem(context, 'Caramel Syrup'),
          _buildInventoryItem(context, 'Ube Syrup'),
          _buildInventoryItem(context, 'Strawberry Syrup'),
          _buildInventoryItem(context, 'Milk'),
          _buildInventoryItem(context, 'White Chocolate Syrup'),
          _buildInventoryItem(context, 'Vanilla Syrup'),
          _buildInventoryItem(context, 'Sweetener'),

          const SizedBox(height: 20),

          // FOOD INGREDIENTS TITLE
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Food Ingredients',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // FOOD INGREDIENTS
          _buildInventoryItemForG(context, 'Melted Cheese'),
          _buildInventoryItemForG(context, 'Fries'),
          _buildInventoryItemForPc(context, 'Cheesy Spicy Samyang Noodles'),
          _buildInventoryItemForPc(context, 'Cheesy Spicy Samyang Carbonara'),
          _buildInventoryItemForPc(context, 'Cheesy Samyang Noodles'),
          _buildInventoryItemForPc(context, 'Chicken Karaage'),
          _buildInventoryItemForPc(context, 'Spam'),
          _buildInventoryItemForPc(context, 'Egg'),
        ],
      ),
    );
  }

Widget _buildInventoryItem(BuildContext context, String itemName) {
  return Consumer<InventoryModel>(
    builder: (context, inventory, child) {
      int stock = inventory.getItemStock(itemName); // Get current stock level
      bool isLowStock = stock <= 100; // Define low-stock threshold

      // Check if stock is low and show the dialog
      if (isLowStock) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showLowStockDialog(context, itemName, stock);
        });
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$stock ml",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: kprimaryColor),
              onPressed: () => _showInputDialog(context, inventory, itemName),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildInventoryItemForPc(BuildContext context, String itemName) {
  return Consumer<InventoryModel>(
    builder: (context, inventory, child) {
      int stock = inventory.getItemStock(itemName); // Get current stock level
      bool isLowStock = stock <= 50; // Define low-stock threshold

      // Check if stock is low and show the dialog
      if (isLowStock) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showLowStockDialogForPC(context, itemName, stock);
        });
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$stock pcs",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: kprimaryColor),
              onPressed: () => _showInputDialog(context, inventory, itemName),
            ),
          ],
        ),
      );
    },
  );
}


Widget _buildInventoryItemForG(BuildContext context, String itemName) {
  return Consumer<InventoryModel>(
    builder: (context, inventory, child) {
      int stock = inventory.getItemStock(itemName); // Get current stock level
      bool isLowStock = stock <= 100; // Define low-stock threshold

      // Check if stock is low and show the dialog
      if (isLowStock) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showLowStockDialogForG(context, itemName, stock);
        });
      }

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$stock grams",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: kprimaryColor),
              onPressed: () => _showInputDialog(context, inventory, itemName),
            ),
          ],
        ),
      );
    },
  );
}


// Function to show low-stock dialog FOR ML
void _showLowStockDialog(BuildContext context, String itemName, int stock) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          "Low Stock Warning",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          "The stock for $itemName is low.\nCurrent stock: $stock ml.\nPlease consider restocking soon.",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
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
      );
    },
  );
}

// Function to show low-stock dialog FOR GRAMS
void _showLowStockDialogForG(BuildContext context, String itemName, int stock) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          "Low Stock Warning",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          "The stock for $itemName is low.\nCurrent stock: $stock grams.\nPlease consider restocking soon.",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
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
      );
    },
  );
}

// Function to show low-stock dialog for PC
void _showLowStockDialogForPC(BuildContext context, String itemName, int stock) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          "Low Stock Warning",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          "The stock for $itemName is low.\nCurrent stock: $stock pcs.\nPlease consider restocking soon.",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
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
      );
    },
  );
}
  

void _showInputDialog(BuildContext context, InventoryModel inventory, String itemName) {
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          "Set Initial $itemName Amount",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter Initial Amount",
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              int? amount = int.tryParse(controller.text);
              if (amount != null) {
                await inventory.setItemStock(itemName, amount);
              }
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: kprimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Set"),
          ),
        ],
      );
    },
  );
}

}
