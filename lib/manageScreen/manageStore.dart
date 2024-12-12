import 'dart:convert';
import 'package:capstone_anesi/app.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:capstone_anesi/manageScreen/Add_Products/MainAddProduct.dart';
import 'package:capstone_anesi/manageScreen/product_List.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manage Store',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.green, // Primary color for the theme
        ),
      ),
      home: const ManageStorePage(),
    );
  }
}

class ManageStorePage extends StatefulWidget {
  const ManageStorePage({super.key});

  @override
  _ManageStorePageState createState() => _ManageStorePageState();
}

class _ManageStorePageState extends State<ManageStorePage> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Load the products when the screen is initialized
    filteredItems = List.from(allItems); // Initially show all items
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredItems = allItems
          .where((item) => item['name'].toLowerCase().contains(query))
          .toList();
    });
  }

  // Function to update the allItems list from AddProductForm
  void _updateItems(Map<String, dynamic> newProduct) {
    setState(() {
      allItems.add(newProduct);
      filteredItems = List.from(allItems); // Update filtered items
      _saveProducts(); // Save the updated list to SharedPreferences
    });
  }

  // Function to edit a product
  void _editItem(int index, Map<String, dynamic> updatedProduct) {
    setState(() {
      allItems[index] = updatedProduct;
      filteredItems = List.from(allItems);
      _saveProducts(); // Save the updated list to SharedPreferences
    });
  }

  // Function to delete a product
  void _deleteItem(int index) {
    setState(() {
      allItems.removeAt(index);
      filteredItems = List.from(allItems);
      _saveProducts(); // Save the updated list to SharedPreferences
    });
  }

// Load products from SharedPreferences
  Future<void> _loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? productsJson = prefs.getString('products');
    if (productsJson != null) {
      List<dynamic> productList = json.decode(productsJson);
      setState(() {
        allItems = List<Map<String, dynamic>>.from(productList);
        filteredItems =
            List.from(allItems); // Ensure filtered items are updated
      });
    }
  }

  // Save products to SharedPreferences
  Future<void> _saveProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encoded = json.encode(allItems); // Convert list to JSON string
    await prefs.setString('products', encoded); // Save it
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MANAGE STORE'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('Manage Products'),
          _buildListTile(context, 'Create Product', '', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainAddProduct(
                  allItems: allItems, // Pass the current list
                  updateItems: _updateItems, // Pass the update function
                ),
              ),
            );
          }),
          //if (allItems.isNotEmpty)
          _buildListTile(context, 'View All Products', '', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductList(
                  products: allItems,
                  onEdit: _editItem,
                  onDelete: _deleteItem,
                ),
              ),
            );
          }),
          // _buildListTile(context, 'Add New Drink Product', '', () {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => AddProductForm(
          //         allItems: allItems, // Pass the current list
          //         updateItems: _updateItems, // Pass the update function
          //       ),
          //     ),
          //   );
          // }),
          // //add for noodles
          // _buildListTile(context, 'Add New Noodles Product', '', () {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => AddProductFormNoodles(
          //         allItems: allItems, // Pass the current list
          //         updateItems: _updateItems, // Pass the update function
          //       ),
          //     ),
          //   );
          // }),
          // //add for meals/snacks
          // _buildListTile(context, 'Add New Meal/Snack Product', '', () {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => AddProductFormMeals(
          //         allItems: allItems, // Pass the current list
          //         updateItems: _updateItems, // Pass the update function
          //       ),
          //     ),
          //   );
          // }),
          // if (allItems.isNotEmpty)
          //   ListTile(
          //     title: _buildProductList(),
          //     tileColor: Colors.white10, // Optional, to make it distinct
          //   ),
          const SizedBox(height: 16),
          _buildSectionHeader('Set Printer & Receipt'),
          _buildListTile(context, 'Printer', '', () {}),
          _buildListTile(context, 'Receipt', '', () {}),
          const SizedBox(height: 16),
          _buildSectionHeader('History Transaction'),
          _buildListTile(context, 'Cash on Hand', '', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditCashOnHandPage(),
              ),
            );
          }),
          _buildListTile(context, 'Expenses', '', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditExpensesPage(),
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildListTile(
      BuildContext context, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
} //END POINT

// Cash on Hand Page
class EditCashOnHandPage extends StatefulWidget {
  const EditCashOnHandPage({super.key});

  @override
  _EditCashOnHandPageState createState() => _EditCashOnHandPageState();
}

class _EditCashOnHandPageState extends State<EditCashOnHandPage> {
  final TextEditingController _cashOnHandController = TextEditingController();

  // Save cash on hand along with the date
  Future<void> saveChanges() async {
    if (_cashOnHandController.text.isEmpty) {
      // Show an error message if the field is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter a value for cash on hand.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('OK', style: TextStyle(color: kprimaryColor)),
              ),
            ],
          );
        },
      );
      return;
    }

    // Proceed to save if the field is not empty
    double cashOnHand = double.tryParse(_cashOnHandController.text) ?? 0.0;
    String date = DateTime.now()
        .toString()
        .split(" ")[0]; // Get current date as a string (yyyy-mm-dd)

    final prefs = await SharedPreferences.getInstance();

    // Save the cash on hand value for the current date
    await prefs.setDouble('cash_on_hand_$date', cashOnHand);

    // Show a dialog to confirm that the cash on hand has been set
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Cash on hand has been successfully set.'),
          actions: [
            TextButton(
              onPressed: () {
                //PROCEEDS TO MAIN SCREEN AFTER SET
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
              child: const Text('OK', style: TextStyle(color: kprimaryColor)),
            ),
          ],
        );
      },
    );
  }

//EDIT CASH ON HAND
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Cash on Hand'),
        backgroundColor: kprimaryColor, // Modern color for AppBar
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.teal.shade50, // Light background color for contrast
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Text
                Text(
                  'Set Cash on Hand',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kprimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Input Field
                TextField(
                  controller: _cashOnHandController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter initial cash on hand',
                    labelStyle: TextStyle(color: Colors.teal.shade700),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.teal.shade700),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.teal.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
                    ),
                  ),
                  style: TextStyle(color: Colors.teal.shade800),
                ),
                
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity, // Full width button
                  child: ElevatedButton(
                    onPressed: saveChanges,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: kprimaryColor, // Custom button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// expense page
class EditExpensesPage extends StatefulWidget {
  const EditExpensesPage({super.key});

  @override
  _EditExpensesPageState createState() => _EditExpensesPageState();
}

class _EditExpensesPageState extends State<EditExpensesPage> {
  final TextEditingController expenseController = TextEditingController();

  // Save total expenses for the selected date
  Future<void> saveChanges() async {
    if (expenseController.text.isEmpty) {
      // Show an error message if the field is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter a value for total expenses.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('OK', style: TextStyle(color: kprimaryColor)),
              ),
            ],
          );
        },
      );
      return;
    }

    // Proceed to save if the field is not empty
    double expense = double.tryParse(expenseController.text) ?? 0.0;
    String date = DateTime.now()
        .toString()
        .split(" ")[0]; // Get current date as a string (yyyy-mm-dd)

    final prefs = await SharedPreferences.getInstance();

    // Save the total expenses value for the current date
    await prefs.setDouble('expense$date', expense);

    // Show a dialog to confirm that the expenses have been set
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set expenses made'),
          content: const Text('Expenses have been successfully set.'),
          actions: [
            TextButton(
              onPressed: () {
                //PROCEEDS TO MAIN SCREEN AFTER SET
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
              child: const Text('OK', style: TextStyle(color: kprimaryColor)),
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
        title: const Text('Edit Total Expenses'),
        backgroundColor: kprimaryColor,
        foregroundColor: Colors.white, // Updated color for AppBar
        elevation: 0,
      ),
      body: Container(
        color: Colors.teal.shade100, // Subtle background color
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Text
                const Text(
                  'Set Total Expenses',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kprimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Input Field
                TextField(
                  controller: expenseController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total Expenses',
                    labelStyle: TextStyle(color: kprimaryColor),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: kprimaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: kprimaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: kprimaryColor, width: 2),
                    ),
                  ),
                  style: TextStyle(color: kprimaryColor),
                ),

                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity, // Full width button
                  child: ElevatedButton(
                    onPressed: saveChanges,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: kprimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

