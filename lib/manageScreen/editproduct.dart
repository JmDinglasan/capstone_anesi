import 'package:flutter/material.dart';

class EditProductPage extends StatefulWidget {
  final String productName;
  final double soloPrice;
  final double sharingPrice;
  final double productPrice;
  final String productCategory;

  const EditProductPage({
    super.key,
    required this.productName,
    this.soloPrice = 0.0,  // Default to 0.0 if not provided
    this.sharingPrice = 0.0,  // Default to 0.0 if not provided
    this.productPrice = 0.0,  // Default to 0.0 if not provided
    required this.productCategory,
  });

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _soloPriceController;
  late TextEditingController _sharingPriceController;
  late TextEditingController _priceController; // For other categories
  String? selectedSubCategory;

  final Map<String, List<String>> subCategoryOptions = {
    'Drinks': ['Coffee', 'Non-Coffee'],
    'Meals and Snacks': ['Meals', 'Snacks'],
    'Noodles': ['Noodles'],
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productName);

    if (widget.productCategory == 'Noodles') {
      _soloPriceController = TextEditingController(text: widget.soloPrice.toStringAsFixed(2));
      _sharingPriceController = TextEditingController(text: widget.sharingPrice.toStringAsFixed(2));
    } else {
      _priceController = TextEditingController(text: widget.productPrice.toStringAsFixed(2));
    }

    selectedSubCategory = subCategoryOptions[widget.productCategory]?.first;
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EDIT PRODUCT/${widget.productCategory.toUpperCase()}',
          style: const TextStyle(
            color: Color(0xFF0F3830), // Title color
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          textAlign: TextAlign.center, // Center the title
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: widget.productCategory == 'Noodles'
              ? buildNoodlesLayout()
              : buildDefaultLayout(),
        ),
      ),
    );
  }
  // Layout for editing Noodles category with solo and sharing prices
  Widget buildNoodlesLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Details Product (Noodles)',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Name Product',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[250],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Selling Price/Solo',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _soloPriceController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[250],
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        const Text(
          'Selling Price/Sharing',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _sharingPriceController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[250],
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        buildSubCategoryDropdown(),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Logic to save product
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3830),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton.icon(
            onPressed: () {
              // Logic to delete product
            },
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text(
              'Delete Product',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  // Default layout for categories like Drinks and Meals & Snacks
  Widget buildDefaultLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Details Product',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Name Product',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[250],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Selling Price',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _priceController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[250],
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        buildSubCategoryDropdown(),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Logic to save product
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3830),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton.icon(
            onPressed: () {
              // Logic to delete product
            },
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text(
              'Delete Product',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  // Subcategory dropdown method
  Widget buildSubCategoryDropdown() {
    return GestureDetector(
      onTap: () {
        _showSubCategoryModal(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedSubCategory ?? 'Select Subcategory',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showSubCategoryModal(BuildContext context) {
    final subCategories = subCategoryOptions[widget.productCategory] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            color: const Color(0xFF0F3830),
            padding: const EdgeInsets.all(16),
            height: 250,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Choose Sub Category',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: subCategories.map((category) {
                      return ListTile(
                        title: Text(
                          category,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          setState(() {
                            selectedSubCategory = category;
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
