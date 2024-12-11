//EDIT PRODUCT PAGE
import 'package:capstone_anesi/app.dart';
import 'package:capstone_anesi/constant.dart';
//import 'package:capstone_anesi/main.dart';
import 'package:flutter/material.dart';

class EditProductFormCoffee extends StatefulWidget {
  final Map<String, dynamic> product;
  final int index;
  final Function(int, Map<String, dynamic>) onUpdate;

  const EditProductFormCoffee({
    required this.product,
    required this.index,
    required this.onUpdate,
    super.key,
  });

  @override
  _EditProductFormState createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductFormCoffee> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _minCoffeeController;
  late TextEditingController _minMilkController;
  late TextEditingController _minVanillaController;
  late TextEditingController _minSweetenerController;
  late TextEditingController _minChocoController;
  late TextEditingController _minCaramelController;
  late TextEditingController _minStrawberryController;
  late TextEditingController _minUbeController;
  late TextEditingController _minWhiteChocoController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product['name']);
    _categoryController =
        TextEditingController(text: widget.product['category']);
    _priceController =
        TextEditingController(text: widget.product['price'].toString());
    _minCoffeeController =
        TextEditingController(text: widget.product['minCoffee'].toString());
    _minMilkController =
        TextEditingController(text: widget.product['minMilk'].toString());
    _minVanillaController =
        TextEditingController(text: widget.product['minVanilla'].toString());
    _minSweetenerController =
        TextEditingController(text: widget.product['minSweetener'].toString());
    _minChocoController =
        TextEditingController(text: widget.product['minChoco'].toString());
    _minCaramelController =
        TextEditingController(text: widget.product['minCaramel'].toString());
    _minStrawberryController =
        TextEditingController(text: widget.product['minStrawberry'].toString());
    _minUbeController =
        TextEditingController(text: widget.product['minUbe'].toString());
    _minWhiteChocoController =
        TextEditingController(text: widget.product['minWhiteChoco'].toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _minCoffeeController.dispose();
    _minMilkController.dispose();
    _minVanillaController.dispose();
    _minSweetenerController.dispose();
    _minChocoController.dispose();
    _minCaramelController.dispose();
    _minStrawberryController.dispose();
    _minUbeController.dispose();
    _minWhiteChocoController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final category = _categoryController.text.toUpperCase();
    final updatedProduct = {
      'name': _nameController.text,
      'category': category,
      'price':
          double.tryParse(_priceController.text) ?? widget.product['price'],
      'minCoffee': int.tryParse(_minCoffeeController.text) ??
          widget.product['minCoffee'],
      'minMilk': int.tryParse(_minMilkController.text) ??
          widget.product['minMilk'],
      'minVanilla': int.tryParse(_minVanillaController.text) ??
          widget.product['minVanilla'],
      'minSweetener': int.tryParse(_minSweetenerController.text) ??
          widget.product['minSweetener'],
      'minChoco': int.tryParse(_minChocoController.text) ??
          widget.product['minChoco'],
      'minCaramel': int.tryParse(_minCaramelController.text) ??
          widget.product['minCaramel'],
      'minStrawberry': int.tryParse(_minStrawberryController.text) ??
          widget.product['minStrawberry'],
      'minUbe': int.tryParse(_minUbeController.text) ??
          widget.product['minUbe'],
      'minWhiteChoco': int.tryParse(_minWhiteChocoController.text) ??
          widget.product['minWhiteChoco'],
    };

    widget.onUpdate(widget.index, updatedProduct);

    // Show success dialog after updating
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Product has been successfully edited.'),
          actions: [
            TextButton(
              onPressed: () {
                //PROCEEDS TO MAIN SCREEN AFTER EDIT
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: kprimaryColor, // Primary color
        foregroundColor: Colors.white, // Text color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Product Details',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Edit Product Ingredients (leave blank if n/a):',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minCoffeeController,
                decoration: InputDecoration(
                  labelText: 'Edit Coffee Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minMilkController,
                decoration: InputDecoration(
                  labelText: 'Edit Milk Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minVanillaController,
                decoration: InputDecoration(
                  labelText: 'Edit Vanilla Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),const SizedBox(height: 16.0),
              TextField(
                controller: _minSweetenerController,
                decoration: InputDecoration(
                  labelText: 'Edit Sweetener Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minChocoController,
                decoration: InputDecoration(
                  labelText: 'Edit Chocolate Syrup Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minCaramelController,
                decoration: InputDecoration(
                  labelText: 'Edit Caramel Syrup Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minStrawberryController,
                decoration: InputDecoration(
                  labelText: 'Edit Strawberry Syrup Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minUbeController,
                decoration: InputDecoration(
                  labelText: 'Edit Ube Syrup Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minWhiteChocoController,
                decoration: InputDecoration(
                  labelText: 'Edit White Choco Syrup Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _saveChanges(); // Call the save changes function
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kprimaryColor, // Primary color
                    foregroundColor: Colors.white, // Text color
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
