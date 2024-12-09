// ADD PRODUCT SCREEN
import 'package:capstone_anesi/inventoryScreen/inventorymodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddProductForm extends StatefulWidget {
  final List<Map<String, dynamic>> allItems;
  final Function(Map<String, dynamic>) updateItems;

  const AddProductForm({
    super.key,
    required this.allItems,
    required this.updateItems,
  });

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _minCoffeeController = TextEditingController();
  final Map<String, Map<String, int>> _productIngredients = {}; // Stores both amount and deduction amount

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            TextField(
              controller: _minCoffeeController,
              decoration: const InputDecoration(labelText: 'Coffee'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                // Show dialog to add ingredients before creating the product
                bool? shouldAddIngredients = await _showAddIngredientDialog(context);

                if (shouldAddIngredients != null && shouldAddIngredients) {
                  // Proceed with creating the product if ingredients were added successfully
                  final newProduct = {
                    'name': _nameController.text,
                    'price': double.tryParse(_priceController.text) ?? 0.0,
                    'category': _categoryController.text,
                    'minCoffee': int.tryParse(_minCoffeeController.text) ?? 0,
                    'ingredients': _productIngredients, // Store the added ingredients
                  };

                  // Add the new product to the list of items
                  widget.updateItems(newProduct);

                  // Deduct the deduction amount from the inventory only after product is added
                  final inventory = Provider.of<InventoryModel>(context, listen: false);
                  for (var entry in _productIngredients.entries) {
                    String ingredientName = entry.key;
                    int deductionAmount = entry.value['deductionAmount'] ?? 0;

                    if (deductionAmount > 0) {
                      await inventory.deductItem(ingredientName, deductionAmount);
                    }
                  }

                  // Show success dialog after creating the product
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Success'),
                        content: const Text('A new product has been created successfully.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showAddIngredientDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController deductionAmountController = TextEditingController(); // New controller for deduction amount

    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Ingredient"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Ingredient Name"),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
              ),
              TextField(
                controller: deductionAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Deduction Amount"), // New field for deduction amount
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final String name = nameController.text.trim();
                final int? amount = int.tryParse(amountController.text.trim());
                final int? deductionAmount = int.tryParse(deductionAmountController.text.trim());

                if (name.isNotEmpty && amount != null && deductionAmount != null) {
                  final inventory = Provider.of<InventoryModel>(context, listen: false);

                  // Check if the ingredient already exists in the inventory
                  if (!inventory.inventory.containsKey(name)) {
                    inventory.addItem(name, amount);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Ingredient added successfully")),
                    );
                  } else {
                    inventory.updateItem(name, amount);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Ingredient updated successfully")),
                    );
                  }

                  // Add the ingredient and deduction amount to the product's ingredients list
                  setState(() {
                    _productIngredients[name] = {
                      'amount': amount,
                      'deductionAmount': deductionAmount,
                    };
                  });

                  Navigator.of(context).pop(true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter valid details")),
                  );
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
