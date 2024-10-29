import 'package:capstone_anesi/cartScreen/transactionModel.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:capstone_anesi/orderModel.dart' as OrderModel; // Prefix this one as OrderModel
  
class HistoryTransactionScreen extends StatefulWidget {
  const HistoryTransactionScreen({super.key});

  @override
  _HistoryTransactionScreenState createState() => _HistoryTransactionScreenState();
}

  List<Map<String, String>> expenses = [];
  DateTime selectedDate = DateTime.now(); // To store the selected date
  double cashOnHand = 0; // Default value
  double expense = 0; // Default value

class _HistoryTransactionScreenState extends State<HistoryTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    
    final orders = Provider.of<OrderModel.OrderModel>(context).orders; // Use prefixed OrderModel
    final cashOnHand = Provider.of<OrderModel.OrderModel>(context).cashOnHand; 
    final totalExpenses = Provider.of<OrderModel.OrderModel>(context).totalExpenses;
    double totalSales = orders.fold(0, (sum, order) => sum + order['price']); 

    return Scaffold(
      appBar: AppBar(
        title: const Text('History Transaction'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => _selectDate(context), // Filter button for date picker
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Income',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Cash on Hand: ₱${cashOnHand.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Selected Date: ${selectedDate.toLocal().toString().split(' ')[0]}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      // Total Sales and Total Expenses aligned in the same row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Sales: ₱${totalSales.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total Expenses: ₱${totalExpenses.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), // Adjust space between sections
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Orders List Section with dynamic data
            Expanded(
              child: Consumer<TransactionModel>(
                builder: (context, transactionModel, child) {
                  return ListView.builder(
                    itemCount: transactionModel.transactions.length, // Correct length for transactions
                    itemBuilder: (context, index) {
                      // Format the current date without the time
                      final formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                      // Use Transaction from transactionModel
                      final Transaction transaction = transactionModel.transactions[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: kprimaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12, // Shadow for a more modern look
                              blurRadius: 6.0,
                              offset: Offset(0, 2), // Slight shadow offset
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            '₱${transaction.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white, // Text color for better contrast
                              fontSize: 18, // Slightly larger font size
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Colors.white70, // Subtle color for the subtitle
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios, // Add an arrow icon to indicate more details
                            color: Colors.white70, // Match the color to the subtitle
                            size: 18,
                          ),
                          onTap: () {
                            // Add navigation to order details if needed
                            _showOrderDetails(context, transaction);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

void _showOrderDetails(BuildContext context, Transaction transaction) {
  // Calculate the total amount
  double totalAmount = transaction.orders.fold(0, (sum, order) => sum + order.itemPrice);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Rounded corners for the dialog
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
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '₱${totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kprimaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Close'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: kprimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}




 // Method to show DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020), // Set range as needed
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked; 
      });
    }
    }
}

