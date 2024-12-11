// ADD PRODUCT SCREEN
import 'package:capstone_anesi/app.dart';
import 'package:capstone_anesi/constant.dart';
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
  final _minMeltedCheeseController = TextEditingController();
  final _minCSNController = TextEditingController();
  final _minCSCController = TextEditingController();
  final _minCNController = TextEditingController();
  final _minEggController = TextEditingController();
  final _minKaraageController = TextEditingController();
  final _minSpamController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Noodles Product'),
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
                controller: _minCSNController,
                decoration: const InputDecoration(
                  labelText: 'Cheesy Spicy Samyang Noodles',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minCSCController,
                decoration: const InputDecoration(
                  labelText: 'Cheesy Spicy Samyang Carbonara',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minCNController,
                decoration: const InputDecoration(
                  labelText: 'Cheesy Samyang Noodles',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
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
                controller: _minMeltedCheeseController,
                decoration: const InputDecoration(
                  labelText: 'Melted Cheese',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
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
                  onPressed: () {
                    if (_nameController.text.isEmpty ||
                        _priceController.text.isEmpty ||
                        _categoryController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Incomplete Form'),
                            content: const Text(
                                'Please fill in all the required fields.'),
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
                    } else {
                      final category = _categoryController.text.toUpperCase();
                      final newProduct = {
                        'name': _nameController.text,
                        'price': double.tryParse(_priceController.text) ?? 0.0,
                        'category': category,
                        'minMeltedCheese':
                            int.tryParse(_minMeltedCheeseController.text) ?? 0,
                        'minCSN': int.tryParse(_minCSNController.text) ?? 0,
                        'minCSC': int.tryParse(_minCSCController.text) ?? 0,
                        'minCN': int.tryParse(_minCNController.text) ?? 0,
                        'minEgg': int.tryParse(_minEggController.text) ?? 0,
                        'minSpam': int.tryParse(_minSpamController.text) ?? 0,
                        'minKaraage': int.tryParse(_minKaraageController.text) ?? 0,

                      };
                      widget.updateItems(newProduct);

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Success'),
                            content: const Text(
                                'A new product has been created successfully.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainScreen()),
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
