import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Add-Ons',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.green, // Primary color for the theme
        ),
      ),
      home: AddOnsListPage(), // Start with the add-ons list page
    );
  }
}

class AddOnsListPage extends StatelessWidget {
  // List of add-ons with their prices
  final List<Map<String, dynamic>> addOns = [
    {'name': 'Caramel Drizzle', 'price': 20.00},
    {'name': 'Chocolate Drizzle', 'price': 20.00},
    {'name': 'Brown Sugar Drizzle', 'price': 20.00},
    {'name': 'Cheesy Fries', 'price': 125.00},
    {'name': 'Chicken Karaage', 'price': 120.00},
    {'name': 'Salted Fries', 'price': 90.00},
  ];

   AddOnsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Ons'),
      ),
      body: ListView.builder(
        itemCount: addOns.length,
        itemBuilder: (context, index) {
          final addOn = addOns[index];
          return ListTile(
            title: Text(addOn['name']),
            subtitle: Text('₱${addOn['price'].toStringAsFixed(2)}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Pass the add-on name and price dynamically when the pencil icon is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAddOnPage(
                      addOnName: addOn['name'],  // Pass the specific add-on name
                      addOnPrice: addOn['price'], // Pass the specific add-on price
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class EditAddOnPage extends StatefulWidget {
  final String addOnName;
  final double addOnPrice;

  const EditAddOnPage({super.key, required this.addOnName, required this.addOnPrice}); // Accept parameters

  @override
  _EditAddOnPageState createState() => _EditAddOnPageState();
}

class _EditAddOnPageState extends State<EditAddOnPage> {
  late TextEditingController productNameController;
  late TextEditingController sellingPriceController;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the passed values
    productNameController = TextEditingController(text: widget.addOnName);
    sellingPriceController = TextEditingController(text: widget.addOnPrice.toStringAsFixed(2));
  }

  @override
  void dispose() {
    productNameController.dispose();
    sellingPriceController.dispose();
    super.dispose();
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
        title: const Text(
          'EDIT ADD ONS',
          style: TextStyle(
            color: Color(0xFF0F3830), // Title color
            fontSize: 18, // Slightly smaller font size
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0), // Reduce overall padding
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Details Product',
                style: TextStyle(
                  fontSize: 18, // Slightly smaller font size
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12), // Reduced space between elements
              const Text(
                'Name Add ons',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 6), // Reduced space between elements
              TextField(
                controller: productNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[250], // Grey background color for TextField
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Smaller border radius
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12), // Reduced padding inside TextField
                ),
              ),
              const SizedBox(height: 12), // Reduced space between elements
              const Text(
                'Selling Price',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 6), // Reduced space between elements
              TextField(
                controller: sellingPriceController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[250], // Grey background color for TextField
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Smaller border radius
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Reduced padding inside TextField
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 18), // Reduced space between elements
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Logic to save the updated add-on details
                      print("Saving: ${productNameController.text}, ${sellingPriceController.text}");
                    });
                    // Show a SnackBar after saving
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Changes saved successfully!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F3830), // Button background color to #0F3830
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12), // Smaller padding for the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // Smaller border radius for the button
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white, // White text color
                      fontSize: 14, // Slightly smaller font size
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18), // Reduced space between elements
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete Product"),
                          content: const Text("Are you sure you want to delete this product?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  // Logic to delete the product
                                  print("Deleting: ${productNameController.text}");
                                });
                                Navigator.pop(context); // Close the dialog
                                // Show a SnackBar after deletion
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Product deleted successfully!')),
                                );
                                Navigator.pop(context); // Go back after deletion
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    'Delete Product',
                    style: TextStyle(
                      color: Colors.red, // Make the text red
                      fontSize: 14, // Slightly smaller font size
                    ),
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
