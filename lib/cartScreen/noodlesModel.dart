import 'package:flutter/foundation.dart';

class CartItem {
  final String title;
  final double price;

  CartItem({required this.title, required this.price});
}

class CartModelNoodles extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice =>
      _items.fold(0.0, (total, item) => total + item.price);

  void addItem(String title, double price) {
    _items.add(CartItem(title: title, price: price));
    notifyListeners(); // Notify listeners to update the UI
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners(); // Notify listeners to update the UI
  }

  void clearCart() {
    _items.clear();
    notifyListeners(); // Notify listeners to update the UI
  }
}
