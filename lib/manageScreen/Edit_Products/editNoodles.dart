//EDIT PRODUCT PAGE
import 'package:capstone_anesi/app.dart';
//import 'package:capstone_anesi/main.dart';
import 'package:flutter/material.dart';

class EditProductFormNoodles extends StatefulWidget {
  final Map<String, dynamic> product;
  final int index;
  final Function(int, Map<String, dynamic>) onUpdate;

  const EditProductFormNoodles({
    required this.product,
    required this.index,
    required this.onUpdate,
    super.key,
  });

  @override
  _EditProductFormState createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductFormNoodles> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _minCSNController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product['name']);
    _priceController =
        TextEditingController(text: widget.product['price'].toString());
    _minCSNController =
        TextEditingController(text: widget.product['minCSN'].toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _minCSNController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedProduct = {
      'name': _nameController.text,
      'price':
          double.tryParse(_priceController.text) ?? widget.product['price'],
      'category': widget.product['category'],
      'minCSN':
          int.tryParse(_minCSNController.text) ?? widget.product['minCSN'],
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
      appBar: AppBar(title: const Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _minCSNController,
              decoration: const InputDecoration(
                  labelText: 'Edit Cheesy Spicy Samyang Noodles Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                _saveChanges(); // Call the save changes function
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
