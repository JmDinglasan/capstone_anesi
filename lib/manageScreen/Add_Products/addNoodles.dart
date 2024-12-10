// ADD PRODUCT SCREEN
import 'package:capstone_anesi/app.dart';
import 'package:flutter/material.dart';

class AddProductFormNoodles extends StatefulWidget {
  final List<Map<String, dynamic>> allItems;
  final Function(Map<String, dynamic>) updateItems;

  const AddProductFormNoodles({
    super.key,
    required this.allItems,
    required this.updateItems,
  });

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductFormNoodles> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _minCSNController = TextEditingController();

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
              controller: _minCSNController,
              decoration: const InputDecoration(labelText: 'CSN'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                // Check if any text field is empty
                if (_nameController.text.isEmpty ||
                    _priceController.text.isEmpty ||
                    _categoryController.text.isEmpty ||
                    _minCSNController.text.isEmpty) {
                  // Show an alert dialog if any text field is empty
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Incomplete Form'),
                        content: const Text('Please fill in all the required fields.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // If all fields are filled, create a new product
                  final newProduct = {
                    'name': _nameController.text,
                    'price': double.tryParse(_priceController.text) ?? 0.0,
                    'category': _categoryController.text,
                    'minCSN': int.tryParse(_minCSNController.text) ?? 0,
                  };
                  widget.updateItems(newProduct);

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
                              // Proceeds to main screen after creation
                              Navigator.push(
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
              },
              child: const Text('Add Product'),
            ),
          ],
        ),
      ),
    );
  }
}
