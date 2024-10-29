import 'package:flutter/material.dart';
//import 'package:capstone_anesi/manageScreen/manageStore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Add Ons',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0F3830), // Primary color
        ),
      ),
      home: const AddAddOnsPage(),
    );
  }
}

class AddAddOnsPage extends StatefulWidget {
  const AddAddOnsPage({super.key});

  @override
  _AddAddOnsPageState createState() => _AddAddOnsPageState();
}

class _AddAddOnsPageState extends State<AddAddOnsPage> {
  TextEditingController addOnNameController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back logic here
          },
        ),
        title: const Text(
          'ADD ADD ONS',
          style: TextStyle(color: Color(0xFF0F3830)), // Title color
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // AppBar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            // Label and Text Field for "Name Add ons"
            const Text(
              'Name Add ons',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: addOnNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Slightly rounded edges
                ),
                filled: true,
                fillColor: Colors.grey[250], // Gray background color
              ),
            ),
            const SizedBox(height: 40),
            // Label and Text Field for "Selling Price"
            const Text(
              'Selling Price',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: sellingPriceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Slightly rounded edges
                ),
                filled: true,
                fillColor: Colors.grey[250], // Gray background color
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 50),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddAddOnsPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                     backgroundColor: const Color(0xFF0F3830),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Add New Add Ons',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ),
            const SizedBox(height: 30),
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
        ),
      ),
    );
  }
}
