import 'package:flutter/material.dart';

class OrderModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _orders = [];
  double _totalBill = 0.0;
  double grossSales = 0.0;
  double cashOnHand = 0.0; // Cash on hand field
  double totalExpenses = 0.0; // Expense field
  double cashPayment = 0.0;
  double noncashPayment = 0.0;

  // List to track daily and weekly sales
  List<double> _dailySales = List.generate(7, (index) => 0.0);
  List<double> _weeklySales = List.generate(4, (index) => 0.0);

  // Map to track product prices and sales
  Map<String, double> _productPrices = {};
  Map<String, int> _productSales = {};

  List<Map<String, dynamic>> get orders => _orders;
  double get totalBill => _totalBill;
  List<double> get dailySales => _dailySales;
  List<double> get weeklySales => _weeklySales;

  // Getter for top-selling products
  List<Map<String, dynamic>> get bestSellingProducts {
    List<Map<String, dynamic>> sortedProducts = _productSales.entries
        .map((entry) => {'product': entry.key, 'sales': entry.value})
        .toList();
    sortedProducts.sort((a, b) => b['sales'].compareTo(a['sales']));
    return sortedProducts.take(3).toList();
  }

  // Method to update the cash on hand value
  void updateCashOnHand(double value) {
    cashOnHand = value;
    notifyListeners();
  }

  // Method to update the expenses value
  void updateExpenses(double value) {
    totalExpenses = value;
    notifyListeners();
  }

  void updateCashPayment(double amount) {
    cashPayment += amount;
    notifyListeners();
  }

  void updateNonCashPayment(double amount) {
    noncashPayment += amount;
    notifyListeners();
  }

  void addOrder(Map<String, dynamic> order) {
    _orders.add(order);
    _totalBill += order['price'];
    grossSales += order['price'];

    // Check if the order is a valid product (not 'Cash' or 'Non-cash')
    if (order['name'] != 'Cash' && order['name'] != 'Non-cash') {
      String productName = order['name']; // Assuming 'name' is the product name
      double productPrice = order['price']; // Assuming 'price' is in the order

      // Track product sales
      if (_productSales.containsKey(productName)) {
        _productSales[productName] = _productSales[productName]! + 1;
      } else {
        _productSales[productName] = 1;
      }

      // Store product price
      _productPrices[productName] = productPrice;
    } else {
      // Handle 'Cash' or 'Non-cash' payments
      if (order['name'] == 'Cash') {
        cashPayment += order['price'];
      } else if (order['name'] == 'Non-cash') {
        noncashPayment += order['price'];
      }
    }

    // Update daily and weekly sales
    int currentDay = DateTime.now().weekday - 1;
    if (currentDay >= 0 && currentDay < 7) {
      _dailySales[currentDay] += order['price'];
    }

    int currentWeek = ((DateTime.now().day - 1) ~/ 7);
    if (currentWeek >= 0 && currentWeek < 4) {
      _weeklySales[currentWeek] += order['price'];
    }

    notifyListeners();
  }

  void clearOrders() {
    _orders.clear();
    _totalBill = 0.0;
    grossSales = 0.0;
    _dailySales = List.generate(7, (index) => 0.0);
    _weeklySales = List.generate(4, (index) => 0.0);
    _productSales.clear();
    notifyListeners();
  }
}

class Order {
  final String itemName;
  final double itemPrice;

  Order({required this.itemName, required this.itemPrice});
}

class Transaction {
  final DateTime date;
  final double totalAmount;
  final List<Order> orders; // List to store the order details

  Transaction({
    required this.date,
    required this.totalAmount,
    required this.orders,
  });
}
