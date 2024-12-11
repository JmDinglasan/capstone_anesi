//EDIT PRODUCT PAGE
import 'package:capstone_anesi/app.dart';
import 'package:capstone_anesi/constant.dart';
//import 'package:capstone_anesi/main.dart';
import 'package:flutter/material.dart';

class EditProductFormMeals extends StatefulWidget {
  final Map<String, dynamic> product;
  final int index;
  final Function(int, Map<String, dynamic>) onUpdate;

  const EditProductFormMeals({
    required this.product,
    required this.index,
    required this.onUpdate,
    super.key,
  });

  @override
  _EditProductFormState createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductFormMeals> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _minMeltedCheeseController;
  late TextEditingController _minFriesController;
  late TextEditingController _minSpamController;
  late TextEditingController _minEggController;
  late TextEditingController _minKaraageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product['name']);
    _categoryController =
        TextEditingController(text: widget.product['category']);
    _priceController =
        TextEditingController(text: widget.product['price'].toString());
    _minMeltedCheeseController = TextEditingController(
        text: widget.product['minMeltedCheese'].toString());
    _minFriesController =
        TextEditingController(text: widget.product['minFries'].toString());
    _minSpamController =
        TextEditingController(text: widget.product['minSpam'].toString());
    _minEggController =
        TextEditingController(text: widget.product['minEgg'].toString());
    _minKaraageController =
        TextEditingController(text: widget.product['minKaraage'].toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _minMeltedCheeseController.dispose();
    _minFriesController.dispose();
    _minEggController.dispose();
    _minSpamController.dispose();
    _minKaraageController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final category = _categoryController.text.toUpperCase();
    final updatedProduct = {
      'name': _nameController.text,
      'category': category,
      'price':
          double.tryParse(_priceController.text) ?? widget.product['price'],
      'minMeltedCheese': int.tryParse(_minMeltedCheeseController.text) ??
          widget.product['minMeltedCheese'],
      'minEgg':
          int.tryParse(_minEggController.text) ?? widget.product['minEgg'],
      'minSpam':
          int.tryParse(_minSpamController.text) ?? widget.product['minSpam'],
      'minKaraage': int.tryParse(_minKaraageController.text) ??
          widget.product['minKaraage'],
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
            children: [ const
              Text(
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
              const SizedBox(height: 16),
              const Text(
                'Edit Product Quantity (leave blank if n/a):',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minMeltedCheeseController,
                decoration: InputDecoration(
                  labelText: 'Edit Melted Cheese Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minFriesController,
                decoration: InputDecoration(
                  labelText: 'Edit Fries Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minEggController,
                decoration: InputDecoration(
                  labelText: 'Edit Egg Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minSpamController,
                decoration: InputDecoration(
                  labelText: 'Edit Spam Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _minKaraageController,
                decoration: InputDecoration(
                  labelText: 'Edit Chicken Karaage Quantity',
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
