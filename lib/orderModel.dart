import 'package:flutter/material.dart';

class OrderModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _orders = [];
  double _totalBill = 0.0;
  double cashOnHand = 0.0; // Cash on hand field
  double totalExpenses = 0.0; //Expense field
  

  List<Map<String, dynamic>> get orders => _orders;
  double get totalBill => _totalBill;

  // Method to update the cash on hand value
  void updateCashOnHand(double value) {
    cashOnHand = value;
    notifyListeners(); // Notify listeners that the value has changed
  }

  // Method to update the expenses value
  void updateExpenses(double value) {
    totalExpenses = value;
    notifyListeners(); // Notify listeners that the value has changed
  }

  void addOrder(Map<String, dynamic> order) {
    _orders.add(order);
    _totalBill += order['price'];
    notifyListeners();
  }

  void clearOrders() {
    _orders.clear();
    _totalBill = 0.0;
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

