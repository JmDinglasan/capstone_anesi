import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  double get totalPrice {
    return _items.fold(
      0,
      (sum, item) =>
          sum +
          item['price'] +
          (item['addons'] as List<Map<String, dynamic>>)
              .fold(0, (addonSum, addon) => addonSum + addon['price']),
    );
  }

  void addToCart(String name, double price,
      {List<Map<String, dynamic>>? addons}) {
    _items.add({
      'name': name,
      'price': price,
      'addons': addons ?? [],
    });
    notifyListeners();
  }

  void addAddonToItem(Map<String, dynamic> item, Map<String, dynamic> addon) {
    final itemIndex = _items.indexWhere((i) => i['name'] == item['name']);
    if (itemIndex != -1) {
      _items[itemIndex]['addons'].add(addon);
      notifyListeners();
    }
  }

  void removeAddonFromItem(
      Map<String, dynamic> item, Map<String, dynamic> addon) {
    final itemIndex = _items.indexWhere((i) => i['name'] == item['name']);
    if (itemIndex != -1) {
      _items[itemIndex]['addons']
          .removeWhere((a) => a['name'] == addon['name']);
      notifyListeners();
    }
  }

  void removeItem(Map<String, dynamic> item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

class CartItem {
  final String itemName;
  final double itemPrice;

  CartItem({required this.itemName, required this.itemPrice});
}

class Cart {
  List<CartItem> items = [];
  double totalAmount = 0.0;

  void addItem(CartItem item) {
    items.add(item);
    totalAmount += item.itemPrice;
  }

  void clearCart() {
    items.clear();
    totalAmount = 0.0;
  }
}

