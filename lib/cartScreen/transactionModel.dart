import 'package:flutter/material.dart';

class Order {
  final String itemName;
  final double itemPrice;

  Order({required this.itemName, required this.itemPrice});
}

class Transaction {
  final DateTime date;
  final double totalAmount;
  final List<Order> orders;
  final String paymentMethod; // Add this field

  Transaction({
    required this.date,
    required this.totalAmount,
    required this.orders,
    required this.paymentMethod,
  });
}

class TransactionModel extends ChangeNotifier {
  List<Transaction> transactions = [];

  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
    notifyListeners();
  }

  List<Transaction> get allTransactions => transactions;
}
