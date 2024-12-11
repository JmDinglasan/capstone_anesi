import 'package:capstone_anesi/app.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:capstone_anesi/manageScreen/Edit_Products/editCoffee.dart';
import 'package:capstone_anesi/manageScreen/Edit_Products/editMeals.dart';
import 'package:capstone_anesi/manageScreen/Edit_Products/editNoodles.dart';
//import 'package:capstone_anesi/manageScreen/manageStore.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final Function(int, Map<String, dynamic>) onEdit;
  final Function(int) onDelete;

  const ProductList({
    super.key,
    required this.products,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late List<Map<String, dynamic>> filteredProducts;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = widget.products; // Initially show all products
    _searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredProducts = widget.products
          .where((product) =>
              product['name'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, int index, String productName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete "$productName"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDelete(index);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
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
        title: const Text('Product List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Products',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: filteredProducts.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> product = entry.value;
                return Card(
                  child: ListTile(
                    title: Text(product['name']),
                    subtitle: Text('Category: ${product['category']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: kprimaryColor),
                          onPressed: () {
                            if (product['category'] == 'COFFEE' ||
                                product['category'] == 'NON-COFFEE' ||
                                product['category'] == 'ADD-ONS DRINKS') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProductFormCoffee(
                                    product: product,
                                    index: index,
                                    onUpdate: widget.onEdit,
                                  ),
                                ),
                              );
                            } else if (product['category'] == 'NOODLES' ||
                                product['category'] == 'ADD-ONS') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProductFormNoodles(
                                    product: product,
                                    index: index,
                                    onUpdate: widget.onEdit,
                                  ),
                                ),
                              );
                            } else if (product['category'] == 'MEALS' ||
                                product['category'] == 'SNACKS' ||
                                product['category'] == 'ADD-ONS') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProductFormMeals(
                                    product: product,
                                    index: index,
                                    onUpdate: widget.onEdit,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(
                                context, index, product['name']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
