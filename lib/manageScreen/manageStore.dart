import 'package:capstone_anesi/manageScreen/addon.dart';
import 'package:capstone_anesi/manageScreen/addproduct.dart';
import 'package:capstone_anesi/manageScreen/editaddon.dart';
import 'package:capstone_anesi/orderModel.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:capstone_anesi/manageScreen/editproduct.dart';
import 'package:provider/provider.dart';

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

class ManageStorePage extends StatelessWidget {
  const ManageStorePage({super.key});

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
          _buildSectionHeader('Set Product'),
          _buildListTile(context, 'Category/Product', '3 Categories 25 Items', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SetProductPage()));
          }),
          _buildListTile(context, 'Sub Category', '', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SetSubCategoryPage()));
          }),
          const SizedBox(height: 16),
          _buildSectionHeader('Cashier & Payment'),
          _buildListTile(context, 'Payment Method', '', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethodPage()));
          }),
          _buildListTile(context, 'Cash on Hand', '', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EditCashOnHandPage()));
          }),
          const SizedBox(height: 16),
          _buildSectionHeader('Set Printer & Receipt'),
          _buildListTile(context, 'Printer', '', () {}),
          _buildListTile(context, 'Receipt', '', () {}),
          const SizedBox(height: 16),
          _buildSectionHeader('History Transaction'),
          _buildListTile(context, 'Expenses', '', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>const EditExpensesPage()));
          }),
          const SizedBox(height: 16),
          _buildSectionHeader('Inventory'),
          _buildListTile(context, 'Manage Stocks', '', () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageStocksPage()));
          }),
        ],
      ),
    );
  }

Widget _buildSectionHeader(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F3830)),
    ),
  );
}
  Widget _buildListTile(BuildContext context, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}

// Set Product Page with Products and Add-ons
class SetProductPage extends StatefulWidget {
  const SetProductPage({super.key});

  @override
  _SetProductPageState createState() => _SetProductPageState();
}

class _SetProductPageState extends State<SetProductPage> {
  String selectedCategory = 'Drinks';
    String _searchTerm = '';

  final Map<String, List<Map<String, dynamic>>> categoryProducts = {
    'Drinks': [
      {'name': 'Snickers Iced Coffee', 'price': 130.00},
      {'name': 'Marshmallow Iced Coffee', 'price': 125.00},
      {'name': 'Double Caramel Macchiato', 'price': 120.00},
      {'name': 'Ube Iced Coffee', 'price': 120.00},
      {'name': 'Marble Macchiato', 'price': 150.00},
      {'name': 'Brown Sugar Iced Coffee', 'price': 115.00},
      {'name': 'Caramel White Mocha', 'price': 110.00},
      {'name': 'Anesi Iced Coffee', 'price': 105.00},
      {'name': 'Iced Mocha', 'price': 100.00},
      {'name': 'Iced Vanilla Latte', 'price': 95.00},
      {'name': 'Iced Cappuchino', 'price': 90.00},
      {'name': 'Iced Cafe Latte', 'price': 85.00},
      {'name': 'Iced Strong Black Coffee', 'price': 80.00},
      {'name': 'Strawberry Choco', 'price': 110.00},  
      {'name': 'Ube Milk', 'price': 110.00},
      {'name': 'Strawberry Milk', 'price': 105.00},
      {'name': 'Anesi Iced Choco', 'price': 100.00},
      {'name': 'Vanilla Milk', 'price': 90.00},
    ],
    'Meals and Snacks': [
      {'name': 'Garlic Pepper Beef', 'price': 150.00},
      {'name': 'Karaage Fries', 'price': 180.00},
      {'name': 'Chicken Karaage Fries', 'price': 130.00},
      {'name': 'Sriracha Spam Garlic Rice', 'price': 150.00},
    ],
    'Noodles': [
      {'name': 'Cheesy Spicy Samyang Noodles (Solo)', 'soloPrice': 150.00, 'sharingPrice': 299.00},
      {'name': 'Cheesy Spicy Samyang Carbonara (Solo)', 'soloPrice': 150.00, 'sharingPrice': 299.00},
      {'name': 'Cheesy Samyang Noodles (Solo)', 'soloPrice': 150.00, 'sharingPrice': 299.00},
    ],
  };

  final List<Map<String, dynamic>> addOnsForDrinks = [
    {'name': 'Caramel Drizzle', 'price': 20.00},
    {'name': 'Chocolate Drizzle', 'price': 20.00},
    {'name': 'Brown Sugar Drizzle', 'price': 20.00},
    {'name': 'Anesi House Blend Syrup', 'price': 5.00},
    {'name': 'Vanilla Syrup', 'price': 5.00},
  ];

  final List<Map<String, dynamic>> addOnsForMealsAndSnacks = [
    {'name': 'Cheesy Fries', 'price': 125.00},
    {'name': 'Chicken Karaage', 'price': 120.00},
    {'name': 'Salted Fries', 'price': 90.00},
  ];

  final List<Map<String, dynamic>> addOnsForNoodles = [
    {'name': 'Chicken Karaage', 'price': 50.00},
    {'name': 'Extra Cheese Sauce', 'price': 40.00},
    {'name': 'Spam Slice', 'price': 30.00},
    {'name': 'Egg', 'price': 5.00},
  ];

  //search
List<Map<String, dynamic>> _getFilteredProducts() {
    return categoryProducts[selectedCategory]!.where((product) {
      return product['name'].toLowerCase().contains(_searchTerm.toLowerCase());
    }).toList();
  }

//clickable pencil icon sa loob ng Choose Category
void _showCategoryDialog() {
  TextEditingController categoryController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF0F3830), // Background color of the dialog
            title: const Text(
              "Choose Category",
              style: TextStyle(color: Colors.grey), // Grey color for the title
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Display the current categories with delete buttons
                Column(
                  children: categoryProducts.keys.map((category) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category,
                          style: const TextStyle(color: Colors.white), // White color for category names
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white), // White color for delete icon
                          onPressed: () {
                            setState(() {
                              categoryProducts.remove(category);
                            });
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                // Container for adding a new category
                Container(
                  padding: const EdgeInsets.all(16.0), // Padding inside the box
                  child: Column(
                    children: [
                      // TextField to add a new category
                      TextField(
                        controller: categoryController,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.white), // White color for hint text
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // White underline for input field
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // White underline when focused
                          ),
                        ),
                        style: const TextStyle(color: Colors.white), // White color for input text
                      ),
                      const SizedBox(height: 16),
                      // Centering the button to add the new category
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            String newCategory = categoryController.text;
                            if (newCategory.isNotEmpty && !categoryProducts.containsKey(newCategory)) {
                              setState(() {
                                categoryProducts[newCategory] = [];
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // Grey background for the button
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: Colors.white), // White color for "+" icon
                              SizedBox(width: 1), // Space between icon and text
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              // Centering the Save Changes button
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey, // Grey background for the button
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Add padding
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white), // White color for the button text
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SET PRODUCT'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search name product',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                       setState(() {
                          _searchTerm = value;
                      });
                      },
                    ),
                  ),
                  const Icon(Icons.search, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 16),  // Space between search bar and dropdown

            // Dropdown for choosing category
              DropdownButtonFormField<String>(
  decoration: InputDecoration(
    labelText: 'Choose Category',
    labelStyle: const TextStyle(color: Colors.grey, fontSize: 18),
    filled: true,
    fillColor: const Color(0xFF0F3830), // Changed dropdown background color
    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12), // Adjusted padding for more space
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF0F3830), width: 10),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF0F3830), width: 10),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF0F3830), width: 10),
    ),
  ),
  value: selectedCategory,
  icon: GestureDetector(
    onTap: () {
      _showCategoryDialog(); // Function to show dialog when pencil is clicked
    },
    child: const Icon(Icons.edit, color: Colors.grey), // Changed to pencil icon and made clickable
  ),
  dropdownColor: const Color(0xFF0F3830),
  style: const TextStyle(color: Colors.white, fontSize: 16),
  items: const [
    DropdownMenuItem(value: 'Drinks', child: Text('Drinks', style: TextStyle(color: Colors.white))),
    DropdownMenuItem(value: 'Meals and Snacks', child: Text('Meals and Snacks', style: TextStyle(color: Colors.white))),
    DropdownMenuItem(value: 'Noodles', child: Text('Noodles', style: TextStyle(color: Colors.white))),
  ],
  onChanged: (value) {
    setState(() {
      selectedCategory = value!;
    });
  },
),


            const SizedBox(height: 16),  // Space between dropdown and product list
            //Design ng PRODUCTS!
            // List of products based on selected category
      Expanded(
  child: ListView.builder(
    // Use the filtered product list for itemCount
    itemCount: _getFilteredProducts().length,
    itemBuilder: (context, index) {
      // Get the product from the filtered list
      final product = _getFilteredProducts()[index];

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedCategory == 'Noodles'
                            ? '₱${product['soloPrice']?.toStringAsFixed(2) ?? product['price'].toStringAsFixed(2)} (Solo)'
                            : '₱${product['price'].toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  // Icon for editing products
                 IconButton(
  icon: const Icon(Icons.edit, color: Colors.grey),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(
          productName: product['name'],
          soloPrice: product['soloPrice'] ?? 0.0,  // Default to 0.0 if null
          sharingPrice: product['sharingPrice'] ?? 0.0,  // Default to 0.0 if null
          productPrice: product['price'] ?? 0.0,  // Default to 0.0 if null
          productCategory: selectedCategory,
        ),
      ),
    );
  },
),

                ],
              ),
            ),  
          ),

          // Add-ons section based on category and product name
          if (selectedCategory == 'Noodles' && product['name'] == 'Cheesy Samyang Noodles (Solo)')
            _buildAddOnsSectionForNoodles(),
          if (selectedCategory == 'Meals and Snacks' && product['name'] == 'Sriracha Spam Garlic Rice')
            _buildAddOnsSectionForMealsAndSnacks(),
          if (selectedCategory == 'Drinks' && product['name'] == 'Vanilla Milk')
            _buildAddOnsSectionForDrinks(),
        ],
      );
    },
  ),
),

            // Space between product list and add-ons buttons
            const SizedBox(height: 16),

            // Buttons to add new product/add ons
         ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF0F3830), // Changed button color
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 70),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
  ),
  onPressed: () {
   Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddAddOnsPage()),
    );// Logic to add new product
  },
  child: const Text(
    'Add New Add Ons',
    style: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  ),
),
const SizedBox(height: 8),
//add new product 
          ElevatedButton(
       style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF0F3830), // Button color
       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 70),
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
     ),
   ),
        onPressed: () {
         // Ensure that the correct category is passed when adding a new product
        print('Adding a new product for category: $selectedCategory');
         Navigator.push(
      context,
     MaterialPageRoute(
        builder: (context) => AddProductPage(selectedCategory: selectedCategory), // Pass the selected category correctly
      ),
    );
  },
  child: const Text(
    'Add New Product',
    style: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  ),
),
          ],
        ),
      ),
    );
  }

  Widget _buildAddOnsSectionForNoodles() {
    return _buildAddOnsSection(addOnsForNoodles);
  }

  Widget _buildAddOnsSectionForMealsAndSnacks() {
    return _buildAddOnsSection(addOnsForMealsAndSnacks);
  }

  Widget _buildAddOnsSectionForDrinks() {
    return _buildAddOnsSection(addOnsForDrinks);
  }

  Widget _buildAddOnsSection(List<Map<String, dynamic>> addOns) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Ons',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            children: addOns.map((addOn) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      addOn['name'],
                      style: const TextStyle(fontSize: 12),
                    ),
                    Row(
                      children: [
                        Text(
                          '₱' + addOn['price'].toStringAsFixed(2),
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
  icon: const Icon(Icons.edit, color: Colors.grey), // Pencil icon
  onPressed: () {
    // Replace '' and 0 with the actual addOnName and addOnPrice values from your product list
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAddOnPage(
          addOnName: addOn['name'],  // Pass the actual product name
          addOnPrice: addOn['price'], // Pass the actual product price
        ),
      ),
    );
  },
),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ),
  );
}
}



// SubCategory Management Page
class SetSubCategoryPage extends StatefulWidget {
  const SetSubCategoryPage({super.key});

  @override
  _SetSubCategoryPageState createState() => _SetSubCategoryPageState();
}

class _SetSubCategoryPageState extends State<SetSubCategoryPage> {
  Map<String, List<String>> subCategories = {
    'Drinks': ['Coffee', 'Non-Coffee'],
    'Meals and Snacks': ['Meals', 'Snacks'],
    'Noodles': [],
  };

  String selectedCategory = 'Drinks';
  TextEditingController subCategoryController = TextEditingController();

  void addSubCategory() {
    String newSubCategory = subCategoryController.text;
    if (newSubCategory.isNotEmpty &&
        !subCategories[selectedCategory]!.contains(newSubCategory)) {
      setState(() {
        subCategories[selectedCategory]!.add(newSubCategory);
        subCategoryController.clear();
      });
    }
  }

  void deleteSubCategory(String subCategory) {
    setState(() {
      subCategories[selectedCategory]!.remove(subCategory);
    });
  }

  void saveChanges() {
    print("Changes saved for $selectedCategory: ${subCategories[selectedCategory]}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SET SUB CATEGORY',
          style: TextStyle(color: Color(0xFF0F3830)), // Set the text color here
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // Change background color if needed
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Choose Category',
                labelStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                filled: true,
                fillColor: const Color(0xFF0F3830), // Dropdown background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0F3830), width: 10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0F3830), width: 10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF0F3830), width: 10),
                ),
              ),
              dropdownColor: const Color(0xFF0F3830), // Dropdown color
              value: selectedCategory,
              items: subCategories.keys.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Gray box for subcategories
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[400], // Gray background color
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Subcategory list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: subCategories[selectedCategory]!.length,
                    itemBuilder: (context, index) {
                      final subCategory = subCategories[selectedCategory]![index];
                      return ListTile(
                        title: Text(subCategory),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black), // Red trash icon
                          onPressed: () {
                            deleteSubCategory(subCategory); // Call delete method
                          },
                        ),
                        onTap: () {
                          // Additional logic if needed when tapping the subcategory
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 8), // Small spacing between the list and text field

                  // Reduced width TextField inside the grey box
                  SizedBox(
                    width: 200, // Set a specific width for the TextField
                    child: TextField(
                      controller: subCategoryController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16), // Space between TextField and "+" button

                  // Centered "+" button
                  SizedBox(
                    height: 55, // Set the height for the button container
                    child: Center(
                      child: ElevatedButton(
                        onPressed: addSubCategory,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F3830), // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4), // Less rounded corners
                          ),
                          fixedSize: const Size(25, 30), // Increased size for the button
                        ),
                        child: const Text(
                          '+',
                          style: TextStyle(
                            fontSize: 20, // Font size for the "+"
                            color: Colors.white, // White color for the "+"
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 36), // Space after grey box

            // "Save Changes" button outside the grey background, aligned with "+"
            Center(
              child: SizedBox(
                width: 400, // Decreased button width
                child: ElevatedButton(
                  onPressed: saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F3830), // Updated to #0F3830
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // Sharp edges for button
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 24), // Thicker button
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white, // White text
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// Payment Method Page
class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _nonCashController = TextEditingController();
  List<String> cashMethods = ['CASH'];
  List<String> nonCashMethods = ['G-CASH'];

  void addCashMethod() {
    if (_cashController.text.isNotEmpty) {
      setState(() {
        cashMethods.add(_cashController.text);
        _cashController.clear();
      });
    }
  }

  void addNonCashMethod() {
    if (_nonCashController.text.isNotEmpty) {
      setState(() {
        nonCashMethods.add(_nonCashController.text);
        _nonCashController.clear();
      });
    }
  }

  Widget _buildPaymentSection(String title, List<String> methods, TextEditingController controller, VoidCallback onAdd) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            for (var method in methods)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      method,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold, // Make "CASH" and "G-CASH" bold
                      ),
                    ),
                  ],
                ),
              ),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Center( // Center the button horizontally
              child: ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3830), // Set the color to #0F3830
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Add border radius for nicer button appearance
                  ),
                ),
                child: const Text(
                  '+',
                  style: TextStyle(
                    color: Colors.white, // White "+" symbol
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EDIT PAYMENT METHOD',
          style: TextStyle(
            color: Color(0xFF0F3830), // Set the color to #0F3830
            fontWeight: FontWeight.bold, // Make it bold
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // Set the background to white
        iconTheme: const IconThemeData(color: Color(0xFF0F3830)), // Icon color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Cash', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildPaymentSection('Cash', cashMethods, _cashController, addCashMethod),
            const Text('Non Cash', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildPaymentSection('Non Cash', nonCashMethods, _nonCashController, addNonCashMethod),
          ],
        ),
      ),
    );
  }
}



// Cash on Hand Page
class EditCashOnHandPage extends StatefulWidget {
  const EditCashOnHandPage({super.key});

  @override
  _EditCashOnHandPageState createState() => _EditCashOnHandPageState();
}

class _EditCashOnHandPageState extends State<EditCashOnHandPage> {
  final TextEditingController _cashOnHandController = TextEditingController();

  void saveChanges() {
    double cashOnHand = double.tryParse(_cashOnHandController.text) ?? 0.0;
    
    // Update the cash on hand in the shared model
    Provider.of<OrderModel>(context, listen: false).updateCashOnHand(cashOnHand);

    // Navigate back or show a success message
    Navigator.pop(context); // Pop the screen after saving changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Cash on Hand')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cashOnHandController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cash on Hand',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}


// Cash on Hand Page
class EditExpensesPage extends StatefulWidget {
  const EditExpensesPage({super.key});

  @override
  _EditExpensesPageState createState() => _EditExpensesPageState();
}

class _EditExpensesPageState extends State<EditExpensesPage> {
  final TextEditingController _totalExpensesController = TextEditingController();

  void saveChanges() {
    double totalExpenses = double.tryParse(_totalExpensesController.text) ?? 0.0;
    
    // Update the expenses in the shared model
    Provider.of<OrderModel>(context, listen: false).updateExpenses(totalExpenses);

    // Navigate back or show a success message
    Navigator.pop(context); // Pop the screen after saving changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Total Expenses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _totalExpensesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Expenses',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}


//Manage Stocks Page
class ManageStocksPage extends StatefulWidget {
  const ManageStocksPage({super.key});

  @override
  _ManageStocksPageState createState() => _ManageStocksPageState();
}

class _ManageStocksPageState extends State<ManageStocksPage> {
  final TextEditingController _nameController = TextEditingController(text: '');
  final TextEditingController _quantityController = TextEditingController(text: '');
  String _selectedCategory = 'DRINKS';

  final Map<String, bool> _selectedDrinks = {
    'Snickers Iced Coffee': false,
    'Marshmallow Iced Coffee': false,
    'Double Caramel Macchiato': false,
    'UBE Iced Coffee': false,
    'Marble Macchiato': false,
    'Brown Sugar Iced Coffee': false,
    'Caramel White Mocha': false,
    'Anesi Iced Coffee': false,
    'Iced Mocha': false,
    'Iced Vanilla Latte': false,
    'Iced Cappuccino': false,
    'Iced Cafe Latte': false,
    'Iced Strong Black Coffee': false,
    'Strawberry Choco': false,
    'UBE Milk': false,
    'Strawberry Milk': false,
    'Anesi Iced Choco': false,
    'Vanilla Milk': false,
    'Caramel Drizzle': false,
    'Chocolate Drizzle': false,
    'Brown Sugar Drizzle': false,
    'Anesi House Blend Syrup': false,
    'Vanilla Syrup': false,
  };

 final Map<String, bool> _selectedMealsAndSnacks = {
    'Garlic Pepper Beef': false,
    'Karaage Fries': false,
    'Chicken Karaage Fries': false,
    'Sriracha Spam Garlic Rice': false,
    'Chicken Karaage': false,
    'Extra Cheese Sauce': false,
    'Spam Slice': false,
    'Egg': false,
  };

  final Map<String, bool> _selectedNoodles = {
    'Cheesy Spicy Samyang Noodles': false,
    'Cheesy Spicy Samyang Carbonara': false,
    'Cheesy Samyang Noodles': false,
  };

  void saveChanges() {
    print('Item: ${_nameController.text}, Quantity: ${_quantityController.text} ml, Category: $_selectedCategory');
  }

  void addStock() {
    print('Adding new stock');
  }

  // Show Category Modal in Center
  void _showCategoryDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F3830),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Choose Category',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const Divider(color: Colors.white),
              ListTile(
                title: const Text(
                  'DRINKS',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDrinksDialog(context);  // Show the Drinks Modal
                },
              ),
              ListTile(
                title: const Text(
                  'MEALS AND SNACKS',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  setState(() {
                    _selectedCategory = 'MEALS AND SNACKS';
                  });
                  Navigator.pop(context);
                  _showMealsAndSnacksDialog(context);
                },
              ),
              ListTile(
                title: const Text(
                  'NOODLES',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  setState(() {
                    _selectedCategory = 'NOODLES';
                  });
                  Navigator.pop(context);
                  _showNoodlesDialog(context);  // Corrected: This will now show the Noodles Modal
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

  // Show Drinks Modal
 void _showDrinksDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
           color: const Color(0xFF0F3830),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                            _showCategoryDialog(context);
                          },
                        ),
                        const Text(
                          'DRINKS',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('ICED COFFEE', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                            ..._buildCheckboxList('ICED COFFEE', setState),
                            const SizedBox(height: 16),
                            const Text('NON COFFEE', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                            ..._buildCheckboxList('NON COFFEE', setState),
                            const SizedBox(height: 16),
                            const Text('ADD-ONS', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                            ..._buildCheckboxList('ADD-ONS', setState),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,  // Grey background color
                      padding: const EdgeInsets.symmetric(vertical: 12),  // Vertical padding
                      fixedSize: const Size(100, 50),  // Set smaller width (100) and height (50)
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white),  // White text color
                    ),
                  ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}


    //Show Meals and Snacks Modal
 void _showMealsAndSnacksDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
               color: const Color(0xFF0F3830),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                            _showCategoryDialog(context);
                          },
                        ),
                        const Text(
                          'MEALS AND SNACKS',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('MEALS', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                            ..._buildCheckboxListMealsAndSnacks('MEALS', setState),
                            const SizedBox(height: 16),
                            const Text('SNACKS', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                            ..._buildCheckboxListMealsAndSnacks('SNACKS', setState),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,  // Grey background color
                      padding: const EdgeInsets.symmetric(vertical: 16),  // Vertical padding
                      fixedSize: const Size(100, 50),  // Set smaller width (100) and height (50)
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white),  // White text color
                    ),
                  ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

// Show Noodles MODAL
void _showNoodlesDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
               color: const Color(0xFF0F3830),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                            _showCategoryDialog(context);
                          },
                        ),
                        const Text(
                          'NOODLES',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('NOODLES', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                            ..._buildCheckboxListNoodles(setState),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,  // Grey background color
                        padding: const EdgeInsets.symmetric(vertical: 16),  // Vertical padding
                        fixedSize: const Size(100, 50),  // Set smaller width (100) and height (50)
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text(
                        'SAVE',
                        style: TextStyle(color: Colors.white),  // White text color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

  //WIDGET DRINKS
 List<Widget> _buildCheckboxList(String category, StateSetter setState) {
  List<String> items;
  if (category == 'ICED COFFEE') {
    items = _selectedDrinks.keys
        .where((key) => key.contains('Iced') || key.contains('Coffee'))
        .toList();
  } else if (category == 'NON COFFEE') {
    items = _selectedDrinks.keys
        .where((key) => key.contains('Milk') || key.contains('Choco'))
        .toList();
  } else {
    items = _selectedDrinks.keys
        .where((key) => key.contains('Drizzle') || key.contains('Syrup'))
        .toList();
  }

  return items.map((item) {
    return CheckboxListTile(
      title: Text(
        item,
        style: const TextStyle(color: Colors.white),
      ),
      value: _selectedDrinks[item],
      onChanged: (bool? value) {
        setState(() {
          _selectedDrinks[item] = value ?? false;
        });
      },
      activeColor: Colors.white, // Change the checked box color to white
      checkColor: Colors.black, // Color of the checkmark
      tileColor: Colors.black, // Background color of the tile
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white), // Border color
        borderRadius: BorderRadius.circular(4), // Optional: Round the corners
      ),
    );
  }).toList();
}

//WIDGET MEALS AND SNACKS
List<Widget> _buildCheckboxListMealsAndSnacks(String category, StateSetter setState) {
  List<String> items;
  if (category == 'MEALS') {
    items = ['Garlic Pepper Beef', 'Karaage Fries', 'Chicken Karaage Fries', 'Sriracha Spam Garlic Rice'];
  } else {
    items = ['Chicken Karaage', 'Extra Cheese Sauce', 'Spam Slice', 'Egg'];
  }

  return items.map((item) {
    return CheckboxListTile(
      title: Text(item, style: const TextStyle(color: Colors.white)),
      value: _selectedMealsAndSnacks[item],
      onChanged: (bool? value) {
        setState(() {
          _selectedMealsAndSnacks[item] = value ?? false;
        });
      },
      activeColor: Colors.white, // Change the checked box color to white
      checkColor: Colors.black, // Color of the checkmark
      tileColor: Colors.black, // Background color of the tile
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white), // Border color
        borderRadius: BorderRadius.circular(4), // Optional: Round the corners
      )
    );
  }).toList();
}

  //WIDGET NOODLES
List<Widget> _buildCheckboxListNoodles(StateSetter setState) {
  List<String> items = [
    'Cheesy Spicy Samyang Noodles',
    'Cheesy Spicy Samyang Carbonara',
    'Cheesy Samyang Noodles',
  ];

  return items.map((item) {
    return CheckboxListTile(
      title: Text(item, style: const TextStyle(color: Colors.white)),
      value: _selectedNoodles[item],
      onChanged: (bool? value) {
        setState(() {
          _selectedNoodles[item] = value ?? false;
        });
      },
      activeColor: Colors.white, // Change the checked box color to white
      checkColor: Colors.black, // Color of the checkmark
      tileColor: Colors.black, // Background color of the tile
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white), // Border color
        borderRadius: BorderRadius.circular(4), // Optional: Round the corners
      )
    );
  }).toList();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
  title: const Text(
    'EDIT STOCKS',
    style: TextStyle(color: Color(0xFF0F3830)),  // Apply color #0F3830 to 'EDIT STOCKS'
  ),
  centerTitle: true,
  backgroundColor: Colors.white,  // Keep the app bar background color as default or change it
  leading: IconButton(
    icon: const Icon(Icons.arrow_back),  // Back button icon
    onPressed: () {
      Navigator.of(context).pop();  // Action to go back
    },
  ),
),

    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 8),
              const Text('ml'),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Include to:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _showCategoryDialog(context),  // Show Category Dialog in center
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedCategory,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // "+" icon
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F3830),  // Background color of the box
                shape: BoxShape.rectangle,   // Set shape to rectangle (box)
                borderRadius: BorderRadius.circular(4),  // Slight rounded corners
              ),
              padding: const EdgeInsets.all(4),    // Reduced padding to make the box smaller
              constraints: const BoxConstraints(
                minWidth: 75,  // Smaller width
                minHeight: 10, // Smaller height
              ),
              child: IconButton(
                icon: const Icon(Icons.add),
                color: Colors.white,         // Icon color set to white
                iconSize: 20,                // Reduced icon size
                onPressed: addStock,         // Action when button is pressed
              ),
            ),
          ),
          const SizedBox(height: 16),
          // "Save Changes" button
          Center(
            child: ElevatedButton(
              onPressed: saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3830), // Set background color to #0F3830
                foregroundColor: Colors.white, // Set text color to white
                padding: const EdgeInsets.symmetric(vertical: 16),
                fixedSize: const Size(350, 50),  // Fixed smaller width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),  // Make sharp edges
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Optional: make the text bold
                ),
              ),
              child: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    ),
  );
}
}
