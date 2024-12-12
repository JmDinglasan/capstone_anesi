//ADD PRODUCT SCREEN
import 'package:capstone_anesi/app.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:capstone_anesi/inventoryScreen/inventorymodel.dart';
import 'package:flutter/material.dart';

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
  final _minMilkController = TextEditingController();
  final _minSweetenerController = TextEditingController();
  final _minVanillaController = TextEditingController();
  final _minChocoController = TextEditingController();
  final _minCaramelController = TextEditingController();
  final _minUbeController = TextEditingController();
  final _minStrawberryController = TextEditingController();
  final _minWhiteChocoController = TextEditingController();
  final List<Map<String, dynamic>> _ingredients = [];

  void _addIngredient(String name, int initialStock) {
    setState(() {
      _ingredients.add({'name': name, 'stock': initialStock});
    });
  }

  Future<void> _saveProduct() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _categoryController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Incomplete Form'),
            content: const Text('Please provide the product details.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final category = _categoryController.text.toUpperCase();
    final newProduct = {
      'name': _nameController.text,
      'price': double.tryParse(_priceController.text) ?? 0.0,
      'category': category,
      'minCoffee': int.tryParse(_minCoffeeController.text) ?? 0,
      'minMilk': int.tryParse(_minMilkController.text) ?? 0,
      'minVanilla': int.tryParse(_minVanillaController.text) ?? 0,
      'minSweetener': int.tryParse(_minSweetenerController.text) ?? 0,
      'minChoco': int.tryParse(_minChocoController.text) ?? 0,
      'minCaramel': int.tryParse(_minCaramelController.text) ?? 0,
      'minStrawberry': int.tryParse(_minStrawberryController.text) ?? 0,
      'minUbe': int.tryParse(_minUbeController.text) ?? 0,
      'minWhiteChoco': int.tryParse(_minWhiteChocoController.text) ?? 0,
    };
    widget.updateItems(newProduct);

    // Save ingredients to inventory
    final inventoryModel = InventoryModel();
    for (var ingredient in _ingredients) {
      await inventoryModel.addItem(ingredient['name'], ingredient['stock']);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('A new product has been created successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Drink Product'),
        backgroundColor: kprimaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Product Details:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: kprimaryColor,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Sub-Category',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 26.0),
              const Text(
                'Enter Amount of Ingredients (leave blank if n/a):',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: kprimaryColor,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minCoffeeController,
                decoration: const InputDecoration(
                  labelText: 'Coffee',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minMilkController,
                decoration: const InputDecoration(
                  labelText: 'Milk',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minSweetenerController,
                decoration: const InputDecoration(
                  labelText: 'Sweetener',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minVanillaController,
                decoration: const InputDecoration(
                  labelText: 'Vanilla',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minChocoController,
                decoration: const InputDecoration(
                  labelText: 'Chocolate Syrup',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minCaramelController,
                decoration: const InputDecoration(
                  labelText: 'Caramel Syrup',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minStrawberryController,
                decoration: const InputDecoration(
                  labelText: 'Strawberry Syrup',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minUbeController,
                decoration: const InputDecoration(
                  labelText: 'Ube Syrup',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minWhiteChocoController,
                decoration: const InputDecoration(
                  labelText: 'White Chocolate Syrup',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text(
                'Add New Ingredients:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: kprimaryColor,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = _ingredients[index];
                  return ListTile(
                    title: Text(ingredient['name']),
                    subtitle: Text('Initial Stock: ${ingredient['stock']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _ingredients.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      final nameController = TextEditingController();
                      final stockController = TextEditingController();
                      final deductionController =
                          TextEditingController(); // Add this controller

                      return AlertDialog(
                        title: const Text('Add Ingredient'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: 'Ingredient Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              controller: stockController,
                              decoration: const InputDecoration(
                                labelText: 'Initial Stock',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              controller: deductionController,
                              decoration: const InputDecoration(
                                labelText: 'Deduction Amount',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              final name = nameController.text;
                              final stock =
                                  int.tryParse(stockController.text) ?? 0;
                              // final deductionAmount =
                              //     int.tryParse(deductionController.text) ?? 0;

                              if (name.isNotEmpty && stock > 0) {
                                _addIngredient(name, stock);

                                // if (deductionAmount > 0) {
                                //   _deductStock(name,
                                //       deductionAmount); // Apply the deduction
                                // }
                              }

                              Navigator.of(context).pop();
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Add Ingredient'),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 12.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: _saveProduct,
                  child: const Text(
                    'Add Product',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
