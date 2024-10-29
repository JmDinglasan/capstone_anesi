import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  final String selectedCategory;

  const AddProductPage({super.key, required this.selectedCategory});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController soloPriceController = TextEditingController();
  TextEditingController sharingPriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController(); // For drinks and meals

  String? selectedSubCategory;
  final Map<String, List<String>> subCategoryOptions = {
    'Drinks': ['Coffee', 'Non-Coffee'],
    'Meals and Snacks': ['Meals', 'Snacks'],
    'Noodles': ['NOODLES'],
  };

  @override
  void initState() {
    super.initState();
    selectedSubCategory ??= subCategoryOptions[widget.selectedCategory]?.first;

    print('Selected Category: ${widget.selectedCategory}');
    print('Sub Category Options: ${subCategoryOptions[widget.selectedCategory]}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add Product/${widget.selectedCategory.toUpperCase()}',
          style: const TextStyle(color: Color(0xFF0F3830)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Custom layout for "Noodles" category, default for others
          child: widget.selectedCategory == 'Noodles'
              ? buildNoodlesLayout() // Show the custom Noodles layout
              : buildDefaultLayout(), // Show default layout for Drinks, Meals, Snacks
        ),
      ),
    );
  }

  // Custom Noodles layout
  Widget buildNoodlesLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Details Product (Noodles)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Name Product',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: productNameController,
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
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: soloPriceController,
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
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: sharingPriceController,
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
              // Add new product logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3830),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text(
              'Add New Product',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton.icon(
            onPressed: () {
              // Delete product logic
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            label: const Text(
              'Delete Product',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Default layout for categories like Drinks, Meals, Snacks
  Widget buildDefaultLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Details Product',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Name Product',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: productNameController,
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
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: sellingPriceController,
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
              // Add new product logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F3830),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            child: const Text(
              'Add New Product',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton.icon(
            onPressed: () {
              // Delete product logic
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            label: const Text(
              'Delete Product',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
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
    final subCategories = subCategoryOptions[widget.selectedCategory] ?? [];

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
