import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String name;
  final int stock;

  // Constructor
  InventoryItem({required this.name, required this.stock});

  // Factory constructor to create an InventoryItem from a Firestore document
  factory InventoryItem.fromFirestore(DocumentSnapshot doc) {
    return InventoryItem(
      name: doc.id, // The document ID represents the item name
      stock: doc['stock'] ??
          0, // Access the 'stock' field from the Firestore document
    );
  }
}

class InventoryModel with ChangeNotifier {
  final CollectionReference _inventoryRef =
      FirebaseFirestore.instance.collection('inventory');

  Map<String, int> _inventory = {};

  InventoryModel() {
    _loadInventory(); // Load inventory data when initialized
  }

  int getItemStock(String itemName) => _inventory[itemName] ?? 0;

  // Public getter for inventory
  Map<String, int> get inventory => _inventory;

  // Stream to fetch the inventory items
  Stream<List<InventoryItem>> get inventoryStream {
    return _inventoryRef.snapshots().map((snapshot) {
      List<InventoryItem> items = [];
      for (var doc in snapshot.docs) {
        items.add(InventoryItem.fromFirestore(
            doc)); // Convert Firestore document to InventoryItem
      }
      return items;
    });
  }

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

  //NEW METHOD FOR INCREMENTING STOCKS AMOUNT
  Future<void> incrementItemStock(String itemName, int amount) async {
    try {
      final DocumentReference docRef =
          FirebaseFirestore.instance.collection('inventory').doc(itemName);

      // Get the current stock
      final DocumentSnapshot docSnapshot = await docRef.get();
      int currentStock = 0;

      if (docSnapshot.exists && docSnapshot.data() != null) {
        currentStock = docSnapshot.get('stock') ?? 0;
      }

      // Increment the stock
      int newStock = currentStock + amount;

      // Update Firebase
      await docRef.update({'stock': newStock});

      // Update local inventory map
      _inventory[itemName] = newStock;
      notifyListeners();
    } catch (e) {
      print("Error updating stock: $e");
      rethrow;
    }
  }

  Future<void> deductItem(String itemName, int amount) async {
    // Deduct the item stock and update the local inventory map
    _inventory[itemName] =
        (_inventory[itemName]! - amount).clamp(0, _inventory[itemName]!);
    notifyListeners();

    // Update Firestore
    await _inventoryRef.doc(itemName).update({'stock': _inventory[itemName]!});
  }

  // New method for deducting multiple items
  Future<void> deductIngredients(Map<String, int> ingredients) async {
    for (var entry in ingredients.entries) {
      String name = entry.key;
      int amount = entry.value;

      // Check if the ingredient exists before deducting
      if (_inventory.containsKey(name)) {
        _inventory[name] =
            (_inventory[name]! - amount).clamp(0, _inventory[name]!);
        await _inventoryRef.doc(name).update({'stock': _inventory[name]!});
      }
    }
    notifyListeners();
  }

  // New method for adding an ingredient
  Future<void> addItem(String itemName, int initialStock) async {
    // Check if the item already exists before adding
    if (!_inventory.containsKey(itemName)) {
      _inventory[itemName] = initialStock;
      notifyListeners(); // Notify listeners to update the UI

      // Add the item to Firestore
      await _inventoryRef.doc(itemName).set({'stock': initialStock});
    }
  }

  // New method for updating an existing item stock
  Future<void> updateItem(String itemName, int newStock) async {
    if (_inventory.containsKey(itemName)) {
      // Update the stock in the local inventory map
      _inventory[itemName] = newStock;
      notifyListeners(); // Notify listeners to update the UI

      // Update the stock in Firestore
      await _inventoryRef.doc(itemName).update({'stock': newStock});
    }
  }

  // New method for deleting an item
  Future<void> deleteItem(String itemName) async {
    // Check if the item exists in the local inventory map
    if (_inventory.containsKey(itemName)) {
      // Remove from the local inventory map
      _inventory.remove(itemName);
      notifyListeners(); // Notify listeners to update the UI

      // Delete the item from Firestore
      await _inventoryRef.doc(itemName).delete();
    }
  }

  
}
