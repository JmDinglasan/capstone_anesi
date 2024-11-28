import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Transaction {
  final DateTime date;
  final double totalAmount;
  final List<Order> orders;
  final String paymentMethod;

  Transaction({
    required this.date,
    required this.totalAmount,
    required this.orders,
    required this.paymentMethod,
  });

  // Convert a Transaction to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalAmount': totalAmount,
      'orders': orders.map((order) => order.toJson()).toList(),
      'paymentMethod': paymentMethod,
    };
  }

  // Create a Transaction from a JSON Map
  static Transaction fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: DateTime.parse(json['date']),
      totalAmount: json['totalAmount'],
      orders: (json['orders'] as List)
          .map((orderJson) => Order.fromJson(orderJson))
          .toList(),
      paymentMethod: json['paymentMethod'],
    );
  }
}

class Order {
  final String itemName;
  final double itemPrice;

  Order({required this.itemName, required this.itemPrice});

  get totalAmount => null;

  Map<String, dynamic> toJson() => {
        'itemName': itemName,
        'itemPrice': itemPrice,
      };

  static Order fromJson(Map<String, dynamic> json) {
    return Order(
      itemName: json['itemName'],
      itemPrice: json['itemPrice'],
    );
  }
}

class TransactionModel extends ChangeNotifier {
  List<Transaction> transactions = [];

  TransactionModel() {
    loadTransactions(); // Load transactions when the model is created
  }

  Future<void> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedTransactions = prefs.getStringList('transactions');

    if (storedTransactions != null) {
      transactions = storedTransactions
          .map((transactionJson) =>
              Transaction.fromJson(jsonDecode(transactionJson)))
          .toList();
      notifyListeners();
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    transactions.add(transaction);
    await _saveTransactions(); // Save to SharedPreferences
    notifyListeners();
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> transactionJsonList = transactions
        .map((transaction) => jsonEncode(transaction.toJson()))
        .toList();
    await prefs.setStringList('transactions', transactionJsonList);
  }
}
