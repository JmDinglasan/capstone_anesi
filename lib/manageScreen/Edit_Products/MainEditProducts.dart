// import 'dart:convert';
// // import 'package:capstone_anesi/manageScreen/Add_Products/addCoffee.dart';
// // import 'package:capstone_anesi/manageScreen/Add_Products/addMeals.dart';
// // import 'package:capstone_anesi/manageScreen/Add_Products/addNoodles.dart';
// import 'package:capstone_anesi/manageScreen/Product_List/listCoffee.dart';
// import 'package:capstone_anesi/manageScreen/Product_List/listMeals.dart';
// import 'package:capstone_anesi/manageScreen/Product_List/listNoodles.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MainEditProduct extends StatefulWidget {
//   // final List<Map<String, dynamic>> allItems;
//   // final Function(Map<String, dynamic>) updateItems;

//   const MainEditProduct({
//     super.key,
//     // required this.allItems,
//     // required this.updateItems,
//     required List<Map<String, dynamic>> products,
//     required void Function(int index, Map<String, dynamic> updatedProduct)
//         onEdit,
//     required void Function(int index) onDelete,
//   });

//   @override
//   _MainEditProduct createState() => _MainEditProduct();
// }

// class _MainEditProduct extends State<MainEditProduct> {
//   List<Map<String, dynamic>> allItems = [];
//   List<Map<String, dynamic>> filteredItems = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadProducts(); // Load the products when the screen is initialized
//     filteredItems = List.from(allItems); // Initially show all items
//   }

//   // Function to update the allItems list from AddProductForm
//   // void _updateItems(Map<String, dynamic> newProduct) {
//   //   setState(() {
//   //     allItems.add(newProduct);
//   //     filteredItems = List.from(allItems); // Update filtered items
//   //     _saveProducts(); // Save the updated list to SharedPreferences
//   //   });
//   // }

//   // Function to edit a product
//   void _editItem(int index, Map<String, dynamic> updatedProduct) {
//     setState(() {
//       allItems[index] = updatedProduct;
//       filteredItems = List.from(allItems);
//       _saveProducts(); // Save the updated list to SharedPreferences
//     });
//   }

//   // Function to delete a product
//   void _deleteItem(int index) {
//     setState(() {
//       allItems.removeAt(index);
//       filteredItems = List.from(allItems);
//       _saveProducts(); // Save the updated list to SharedPreferences
//     });
//   }

//   // Save products to SharedPreferences
//   Future<void> _saveProducts() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String encoded = json.encode(allItems); // Convert list to JSON string
//     await prefs.setString('products', encoded); // Save it
//   }

//   // Load products from SharedPreferences
//   Future<void> _loadProducts() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? productsJson = prefs.getString('products');
//     if (productsJson != null) {
//       List<dynamic> productList = json.decode(productsJson);
//       setState(() {
//         allItems = List<Map<String, dynamic>>.from(productList);
//         filteredItems =
//             List.from(allItems); // Ensure filtered items are updated
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('View All Products')),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ListCoffee(
//                     products: allItems,
//                     onEdit: _editItem, // Pass actual data as needed
//                     onDelete: _deleteItem,
//                   ),
//                 ),
//               );
//             },
//             child: const Text('View / Edit Drink Products'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ListNoodles(
//                     products: allItems,
//                     onEdit: _editItem, // Pass actual data as needed
//                     onDelete: _deleteItem,
//                   ),
//                 ),
//               );
//             },
//             child: const Text('View / Edit Noodles Products'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ListMeals(
//                     products: allItems,
//                     onEdit: _editItem, // Pass actual data as needed
//                     onDelete: _deleteItem,
//                   ),
//                 ),
//               );
//             },
//             child: const Text('View / Edit Meal & Snack Products'),
//           ),
    
//         ],
//       ),
//     );
//   }
// }
