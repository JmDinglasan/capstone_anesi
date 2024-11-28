import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class InventoryModel with ChangeNotifier {
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _inventoryRef = FirebaseFirestore.instance.collection('inventory');

  Map<String, int> _inventory = {};

  InventoryModel({required int inventorystock}) {
    _loadInventory(); // Load inventory data when initialized
  }

  int getItemStock(String itemName) => _inventory[itemName] ?? 0;

  Future<void> _loadInventory() async {
    // Fetch data from Firestore
    _inventoryRef.get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _inventory = {};
        for (var doc in snapshot.docs) {
          _inventory[doc.id] = doc['stock'];
        }
      }
      notifyListeners();
    });
  }

  Future<void> setItemStock(String itemName, int amount) async {
    // Update the local inventory map
    _inventory[itemName] = amount;
    notifyListeners();

    // Update Firestore
    await _inventoryRef.doc(itemName).set({'stock': amount});
  }

  Future<void> deductItem(String itemName, int amount) async {
    // Deduct the item stock and update the local inventory map
    _inventory[itemName] = (_inventory[itemName]! - amount).clamp(0, _inventory[itemName]!);
    notifyListeners();

    // Update Firestore
    await _inventoryRef.doc(itemName).update({'stock': _inventory[itemName]!});
  }
}
