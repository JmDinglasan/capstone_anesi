import 'package:capstone_anesi/historyScreen/transactionModel.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//import 'package:capstone_anesi/orderModel.dart' as OrderModel; // Prefix this one as OrderModel
import 'package:shared_preferences/shared_preferences.dart';

class HistoryTransactionScreen extends StatefulWidget {
  const HistoryTransactionScreen({super.key});

  @override
  _HistoryTransactionScreenState createState() =>
      _HistoryTransactionScreenState();
}

class _HistoryTransactionScreenState extends State<HistoryTransactionScreen> {
  DateTime? selectedDate;
  double cashOnHand = 0.0;
  double expense = 0.0;

  Future<void> _loadCashOnHand() async {
    final prefs = await SharedPreferences.getInstance();
    String selectedDateKey = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now());
    double storedCashOnHand =
        prefs.getDouble('cash_on_hand_$selectedDateKey') ?? 0.0;
    setState(() {
      cashOnHand = storedCashOnHand;
    });
  }

  Future<void> _loadExpense() async {
    final prefs = await SharedPreferences.getInstance();
    String selectedDateKey = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now());
    double storedExpense = prefs.getDouble('expense$selectedDateKey') ?? 0.0;
    setState(() {
      expense = storedExpense;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCashOnHand();
    _loadExpense();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HISTORY TRANSACTION',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                });
                _loadCashOnHand();
                _loadExpense();
              }
            },
          ),
        ],
      ),
      body: Consumer<TransactionModel>(
        builder: (context, transactionModel, child) {
          // Filter transactions based on the selected date
          final filteredTransactions = selectedDate == null
              ? transactionModel.transactions.where((transaction) {
                  final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  final transactionDate =
                      DateFormat('yyyy-MM-dd').format(transaction.date);
                  return transactionDate == today;
                }).toList()
              : transactionModel.transactions.where((transaction) {
                  final transactionDate =
                      DateFormat('yyyy-MM-dd').format(transaction.date);
                  final selectedDateFormatted =
                      DateFormat('yyyy-MM-dd').format(selectedDate!);
                  return transactionDate == selectedDateFormatted;
                }).toList();

          // Calculate total sales for the selected date
          final double totalSales = filteredTransactions.fold(
            0.0,
            (sum, transaction) => sum + transaction.totalAmount,
          );
          // Calculate cash on hand including total sales
          final double totalCashOnHand = cashOnHand + totalSales;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Income Section
              const Text(
                'Income',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cash on Hand: ₱${totalCashOnHand.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        selectedDate != null
                            ? DateFormat('MMMM dd, yyyy').format(selectedDate!)
                            : DateFormat('MMMM dd, yyyy')
                                .format(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  if (totalSales > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total Sales',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          '₱${totalSales.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 20),

              // Transactions List
              if (filteredTransactions.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'No transactions for the selected date.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              else
                ...filteredTransactions.map((transaction) {
                  final String transactionDateTime =
                      DateFormat('MM/dd/yyyy hh:mm a').format(transaction.date);

                  return GestureDetector(
                    onTap: () {
                      _showOrderDetails(context, transaction, transactionModel);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: kprimaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        title: Text(
                          '₱${transaction.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        subtitle: Text(
                          transactionDateTime,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white70),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  );
                }).toList(),

              const SizedBox(height: 10),
// Expense Section
              if (expense > 0) ...[
                const Text(
                  'Expenses',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Handle any onTap functionality you might need
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: kprimaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(
                        '₱${expense.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        selectedDate != null
                            ? DateFormat('MM/dd/yyyy').format(selectedDate!)
                            : DateFormat('MM/dd/yyyy').format(DateTime.now()),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

//WITH REFUND BUTTON
  void _showOrderDetails(BuildContext context, Transaction transaction,
      TransactionModel transactionModel) {
    // Calculate the total amount
    double totalAmount =
        transaction.orders.fold(0, (sum, order) => sum + order.itemPrice);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Rounded corners for the dialog
          ),
          title: const Row(
            children: [
              Icon(Icons.receipt_long, color: kprimaryColor),
              SizedBox(width: 10),
              Text(
                'Order Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SizedBox(
            height: 250.0, // Adjusted height for better viewing
            width: 320.0, // Adjusted width for better viewing
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display Payment Method
                Text(
                  'Payment Method: ${transaction.paymentMethod}', // Show payment method
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: transaction.orders.length,
                    itemBuilder: (context, index) {
                      final order = transaction.orders[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          order.itemName,
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: Text(
                          '₱${order.itemPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(thickness: 1.3),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₱${totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kprimaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton.icon(
              icon: const Icon(Icons.undo, color: Colors.white),
              label: const Text('Refund'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: kprimaryColor, // Refund button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                // Show confirmation dialog before refund
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Refund'),
                      content: const Text(
                          'Are you sure you want to refund this transaction?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close confirmation dialog
                          },
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.red)),
                        ),
                        TextButton(
                          onPressed: () {
                            // Perform the refund and close the dialogs
                            _refundTransaction(transaction, transactionModel);
                            Navigator.of(context)
                                .pop(); // Close confirmation dialog
                            Navigator.of(context)
                                .pop(); // Close order details dialog
                          },
                          child: const Text('Confirm',
                              style: TextStyle(color: kprimaryColor)),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Close'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: kprimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

//REFUND FUNCTION
  void _refundTransaction(
      Transaction transaction, TransactionModel transactionModel) {
    setState(() {
      double refundAmount =
          transaction.orders.fold(0, (sum, order) => sum + order.itemPrice);
      print("Refund Amount: ₱$refundAmount"); // Debug print

      cashOnHand - refundAmount;
      print("Updated Cash On Hand: ₱$cashOnHand"); // Debug print

      transactionModel.transactions
          .remove(transaction); // Remove refunded transaction
    });
  }
}
