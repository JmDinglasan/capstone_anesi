// ADD PRODUCT SCREEN
import 'package:capstone_anesi/app.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:capstone_anesi/inventoryScreen/inventorymodel.dart';
import 'package:flutter/material.dart';

class AddProductFormMeals extends StatefulWidget {
  final List<Map<String, dynamic>> allItems;
  final Function(Map<String, dynamic>) updateItems;

  const AddProductFormMeals({
    super.key,
    required this.allItems,
    required this.updateItems,
  });

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductFormMeals> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _minKaraageController = TextEditingController();
  final _minMeltedCheeseController = TextEditingController();
  final _minFriesController = TextEditingController();
  final _minEggController = TextEditingController();
  final _minSpamController = TextEditingController();
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
        ingredient['stock'] = newStock < 0 ? 0 : newStock; // Ensure stock doesn't go negative
      }
    }
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
            content: const Text('Please fill in all the required fields.'),
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
      'minMeltedCheese': int.tryParse(_minMeltedCheeseController.text) ?? 0,
      'minEgg': int.tryParse(_minEggController.text) ?? 0,
      'minSpam': int.tryParse(_minSpamController.text) ?? 0,
      'minKaraage': int.tryParse(_minKaraageController.text) ?? 0,
      'ingredients': _ingredients,
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
        title: const Text('New Meal / Snack Product'),
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
                'Enter Product Details',
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
                'Enter Required Amount of Items (leave blank if n/a):',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: kprimaryColor,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minEggController,
                decoration: const InputDecoration(
                  labelText: 'Egg',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minSpamController,
                decoration: const InputDecoration(
                  labelText: 'Spam',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minKaraageController,
                decoration: const InputDecoration(
                  labelText: 'Chicken Karaage',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minFriesController,
                decoration: const InputDecoration(
                  labelText: 'Fries',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minMeltedCheeseController,
                decoration: const InputDecoration(
                  labelText: 'Melted Cheese',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24.0),
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
              const SizedBox(height: 24.0),
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
