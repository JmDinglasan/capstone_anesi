//ADD PRODUCT SCREEN
import 'package:capstone_anesi/app.dart';
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
              onPressed: () {
                final newProduct = {
                  'name': _nameController.text,
                  'price': double.tryParse(_priceController.text) ?? 0.0,
                  'category': _categoryController.text,
                  'minCoffee': int.tryParse(_minCoffeeController.text) ?? 0,
                };
                widget.updateItems(newProduct);

                // Show success dialog after CREATING
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Success'),
                      content:
                          const Text('A new product has been created successfully.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            //PROCEEDS TO MAIN SCREEN AFTER EDIT
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()),
                            );
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
