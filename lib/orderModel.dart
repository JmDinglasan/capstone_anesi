import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _orders = [];
  double _totalBill = 0.0;
  double grossSales = 0.0;
  double cashOnHand = 0.0;
  double totalExpenses = 0.0;
  double cashPayment = 0.0;
  double noncashPayment = 0.0;

  // Daily and weekly sales tracking
  List<double> _dailySales = List.filled(7, 0.0); // Mon-Sun
  List<double> _weeklySales = List.filled(4, 0.0); // 4 weeks
  List<double> _monthlySales = List.filled(12, 0.0); // Jan-Dec
   bool _isFetching = false; // To prevent multiple fetches
  bool _isLoading = false; 

  // Public getters
  List<double> get dailySales => _dailySales;
  List<double> get weeklySales => _weeklySales;
  List<double> get monthlySales => _monthlySales;

  // Product price and sales tracking
  final Map<String, double> _productPrices = {};
  final Map<String, int> _productSales = {};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> get orders => _orders;
  double get totalBill => _totalBill;
  
  
  // Fetch orders and related sales data from Firestore
  Future<void> fetchOrdersAndSales() async {
    try {
      // Reset data
      _orders.clear();
      _totalBill = 0.0;
      grossSales = 0.0;
      _dailySales = List.generate(7, (_) => 0.0);
      _weeklySales = List.generate(4, (_) => 0.0);
      

      // Fetch orders from Firestore
      final snapshot = await _firestore.collection('orders').get();
      for (var doc in snapshot.docs) {
        final order = doc.data();
        _orders.add(order);
        _totalBill += order['price'];
        grossSales += order['price'];
        _updateSalesData(order['price'], order['date']);
      }

      notifyListeners();
    } catch (e) {
      print('Error fetching orders and sales: $e');
    }
  }

  // Fetch daily sales by day from Firestore
 
  // Fetch payment methods (cash and non-cash)
  Future<void> fetchPaymentMethods() async {
    try {
      final cashNonCash = await getPaymentMethods();
      cashPayment = cashNonCash['Cash'] ?? 0.0;
      noncashPayment = cashNonCash['Non-cash'] ?? 0.0;
      notifyListeners(); // Notify listeners to update the UI
    } catch (e) {
      print('Error fetching payment methods: $e');
    }
  }

  Future<Map<String, double>> getPaymentMethods() async {
    try {
      final snapshot = await _firestore.collection('orders').get();

      double cashTotal = 0.0;
      double nonCashTotal = 0.0;

      for (var doc in snapshot.docs) {
        final order = doc.data();
        final productPrice = order['price'];
        final paymentType = order['paymentType']; // 'Cash' or 'Non-Cash'

        if (paymentType == 'Cash') {
          cashTotal += productPrice;
        } else {
          nonCashTotal += productPrice;
        }
      }

      return {
        'Cash': cashTotal,
        'Non-cash': nonCashTotal,
      };
    } catch (e) {
      print('Error fetching payment methods: $e');
      return {'Cash': 0.0, 'Non-cash': 0.0}; // Return 0 if error occurs
    }
  }
  
bool _isFetchingData = false;

  bool get isFetchingData => _isFetchingData;

  Future<void> fetchAndProcessSalesData() async {
    if (_isFetchingData) return; // Prevent multiple fetches

    _isFetchingData = true;
    notifyListeners(); // Notify UI to show loading spinner

    try {
      // Reset sales data before fetching new data
      _dailySales = List.generate(7, (_) => 0.0);
      _weeklySales = List.generate(4, (_) => 0.0);
      _monthlySales = List.generate(12, (_) => 0.0);

      print("Fetching orders from Firestore...");

      // Fetch orders from Firestore
      QuerySnapshot querySnapshot = await _firestore.collection('orders').get();

      print("Orders fetched: ${querySnapshot.docs.length}");

      // Process each order in the snapshot
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Log the order data for debugging
        print("Processing order: $data");

        // Make sure the document contains 'dateCreated' and 'price'
        if (data.containsKey('dateCreated') && data['dateCreated'] is Timestamp) {
          DateTime date = (data['dateCreated'] as Timestamp).toDate();
          double price = data['price'] ?? 0.0;

          // Log date and price for debugging
          print("Order Date: $date, Price: $price");

          // Calculate daily sales (0 = Sunday, 6 = Saturday)
          int dayIndex = date.weekday - 1; // Adjusting because week starts on Monday (1 = Monday, 7 = Sunday)
          if (dayIndex >= 0 && dayIndex < 7) {
            dailySales[dayIndex] += price;
            print("Updated daily sales for ${date.weekday}: ${dailySales[dayIndex]}");
          }

          // Calculate weekly sales (divide days into 4 weeks per month)
          int weekIndex = ((date.day - 1) ~/ 7); // Getting the week number (0 = first week, 1 = second week, etc.)
          if (weekIndex >= 0 && weekIndex < 4) {
            weeklySales[weekIndex] += price;
            print("Updated weekly sales for week $weekIndex: ${weeklySales[weekIndex]}");
          }

          // Calculate monthly sales (1 = January, 12 = December)
          int monthIndex = date.month - 1; // Adjusting because months are 1-based (1 = January, 12 = December)
          if (monthIndex >= 0 && monthIndex < 12) {
            monthlySales[monthIndex] += price;
            print("Updated monthly sales for month ${date.month}: ${monthlySales[monthIndex]}");
          }
        }
      }

      // Log final sales data
      print("Daily Sales: $dailySales");
      print("Weekly Sales: $weeklySales");
      print("Monthly Sales: $monthlySales");

      // Notify listeners that data has been updated
    
    } catch (e) {
      print('Error fetching and processing sales data: $e');
    } finally {
      _isFetchingData = false; // Reset the fetching status
      // Notify UI to hide loading spinner
    }
  }

  // Add a new order and update sales data
  Future<void> addOrder(Map<String, dynamic> order) async {
    try {
      // Fetch the price from the 'orders' collection
      final orderSnapshot = await _firestore
          .collection('orders')
          .doc(order['orderId'])  // Assuming each order has a unique 'orderId'
          .get();
    
      double productPrice = 0.0;
      if (orderSnapshot.exists) {
        // Extract the price from the order document
        productPrice = orderSnapshot['price'];
      }

      // Get the current date and calculate the day of the week (0 = Monday, 6 = Sunday)
      DateTime now = DateTime.now();
      int dayOfWeek = now.weekday - 1; // Convert to 0 (Monday) to 6 (Sunday)
      Timestamp dateCreated = Timestamp.fromDate(now);

      order['dateCreated'] = dateCreated;
     

      // Add the order to Firestore
      await _firestore.collection('orders').add(order);

      // Update local data
      _orders.add(order);
      _totalBill += productPrice; // Use the fetched price for the total bill
      grossSales += productPrice; // Add the fetched price to the gross sales

      // Update product sales
      _updateProductSales(order['name'], productPrice);

      // Handle payment type (cash or non-cash)
      if (order['paymentType'] == 'Cash') {
        cashPayment += productPrice;
      } else {
        noncashPayment += productPrice;
      }

      // Update daily and weekly sales data
      _updateSalesData(productPrice, dateCreated);

      // Notify listeners to update the UI
      notifyListeners();
    } catch (e) {
      print('Error adding order and saving sales data: ${e.toString()}');
    }
  }


  // Update daily and weekly sales data
  void _updateSalesData(double price, Timestamp orderDate) {
    DateTime date = orderDate.toDate();

    // Update daily sales
    int currentDay = date.weekday - 1; // 0 = Monday, 6 = Sunday
    if (currentDay >= 0 && currentDay < 7) {
      _dailySales[currentDay] += price;
    }

    // Update weekly sales
    int currentWeek = (date.day - 1) ~/ 7; // Week index (0-3)
    if (currentWeek >= 0 && currentWeek < 4) {
      _weeklySales[currentWeek] += price;
    }
  }

  // Update product sales and prices
  void _updateProductSales(String productName, double productPrice) {
    _productSales[productName] = (_productSales[productName] ?? 0) + 1;
    _productPrices[productName] = productPrice;
  }
  

  // Retrieve the gross sales from Firestore
  Future<double> getGrossSales() async {
    try {
      final snapshot = await _firestore.collection('orders').get();

      double totalGrossSales = 0.0;
      for (var doc in snapshot.docs) {
        final order = doc.data();
        final productPrice = order['price'];
        totalGrossSales += productPrice;
      }


      return totalGrossSales;
    } catch (e) {
      print('Error fetching gross sales: $e');
      return 0.0;
    }
  }

  // Retrieve the best-selling products
  Future<List<Map<String, dynamic>>> getBestSellingProducts() async {
    try {
      // Fetch orders from Firestore
      final snapshot = await _firestore.collection('orders').get();

      // Local variables for tracking product sales and prices
      final Map<String, int> productSales = {};
      final Map<String, double> productPrices = {};

      // Iterate through the orders and update the product sales and prices
      for (var doc in snapshot.docs) {
        final order = doc.data();
        final productName = order['name'];
        final productPrice = order['price'];

        // Update product sales count
        productSales[productName] = (productSales[productName] ?? 0) + 1;

        // Update product prices
        productPrices[productName] = productPrice;
      }

      // Prepare the list of best-selling products
      List<Map<String, dynamic>> bestSelling = productSales.entries.map((entry) {
        final productName = entry.key;
        final salesCount = entry.value;
        final productPrice = productPrices[productName] ?? 0.0;
        return {
          'product': productName,
          'sales': salesCount,
          'price': productPrice,
        };
      }).toList();

      // Sort the list by sales count in descending order
      bestSelling.sort((a, b) => b['sales'].compareTo(a['sales']));

      return bestSelling;
    } catch (e) {
      print('Error fetching best-selling products: $e');
      return [];
    }
  }
  // Get product price
  double getProductPrice(String productName) {
    return _productPrices[productName] ?? 0.0;
  }
}
