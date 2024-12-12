import 'package:capstone_anesi/orderModel.dart';
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

  void removeItem(Map<String, dynamic> item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Method to finalize the cart as an order and update the order model
  void checkout(OrderModel orderModel, String paymentType) {
  // This paymentType can be 'Cash' or 'Non-cash', based on the user’s choice
  for (var item in _items) {
    // Add each item to the order model as a product
    orderModel.addOrder({
      'name': item['name'],  // Correct product name
      'price': item['price'], // Price of the product
      'paymentType': paymentType, // Payment type: 'Cash' or 'Non-cash'
    });
  }
  clearCart();  // Clear the cart after checkout
}

}
