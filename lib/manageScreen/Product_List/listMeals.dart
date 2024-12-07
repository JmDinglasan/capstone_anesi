// import 'package:capstone_anesi/main.dart';
// import 'package:capstone_anesi/manageScreen/Edit_Products/editMeals.dart';
// //import 'package:capstone_anesi/manageScreen/manageStore.dart';
// import 'package:flutter/material.dart';

// class ListMeals extends StatelessWidget {
//   final List<Map<String, dynamic>> products;
//   final Function(int, Map<String, dynamic>) onEdit;
//   final Function(int) onDelete;

//   const ListMeals({
//     super.key,
//     required this.products,
//     required this.onEdit,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Product List'),
//         centerTitle: true,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: products.asMap().entries.map((entry) {
//           int index = entry.key;
//           Map<String, dynamic> product = entry.value;
//           return Card(
//             child: ListTile(
//               title: Text(product['name']),
//               subtitle: Text('Category: \ ${product['category']}'),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.blue),
//                     onPressed: () {
//                       // Navigate to EditProductForm when the edit icon is clicked
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => EditProductFormMeals(
//                             product: product,
//                             index: index,
//                             onUpdate: onEdit,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     onPressed: () {
//                       // Call onDelete function passed from the main page
//                       onDelete(index);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const MainScreen()),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
