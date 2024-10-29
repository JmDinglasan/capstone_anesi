//import 'package:capstone_anesi/main.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:capstone_anesi/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_anesi/cartScreen/cartmodel.dart'; // Corrected import path
import 'package:capstone_anesi/orderModel.dart' as OrderModel; // Import the OrderModel class
import 'package:capstone_anesi/cartScreen/transactionModel.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _cashInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cashInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Payment Page",
            style: TextStyle(
              fontWeight: FontWeight.bold,  // Set the font to bold
              fontSize: 20,                 // Optionally adjust the font size
            ),
          ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: kprimaryColor,           // Color for the selected tab (e.g., Cash)
          unselectedLabelColor: Colors.grey,  // Color for the unselected tabs (e.g., Non Cash)
           indicatorColor: kprimaryColor,       // Color for the indicator (underline)
          tabs: const [
            Tab(text: 'Cash'),
            Tab(text: 'Non-Cash'),
          ],
          
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCashPaymentTab(),
          _buildNonCashPaymentTab(),
        ],
      ),
    );
  }

  // Widget for the Cash Payment Tab
  Widget _buildCashPaymentTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<CartModel>(
            builder: (context, cart, child) {
              return Text(
                'Total Bill: ₱${cart.totalPrice}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
            },
          ),

          const SizedBox(height: 20),
          TextField(
            controller: _cashInputController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter amount',
            ),
          ),

          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 2,
              padding: const EdgeInsets.all(8.0),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: List.generate(12, (index) {
                if (index == 9) {       // X BUTTON
                  return ElevatedButton(
                    onPressed: () {
                      if (_cashInputController.text.isNotEmpty) {
                        setState(() {
                          _cashInputController.text = _cashInputController.text
                              .substring(0, _cashInputController.text.length - 1);
                        });
                      }
                    },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: kprimaryColor, backgroundColor: Colors.white, // Text color when pressed
                  ),

                  child: const Icon(Icons.backspace),
                  );
                } else if (index == 11) {       //ENTER BUTTON
                  return ElevatedButton(
                    onPressed: 
                    _processPayment,
                    style: ElevatedButton.styleFrom(
                    foregroundColor: kprimaryColor, backgroundColor: Colors.white, // Text color when pressed
                  ),
                    child: const Text('ENTER'),
                  );
                } 
                else {        //NUMBERS
                  String buttonText = index == 10 ? '0' : '${(index + 1) % 10}';
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _cashInputController.text += buttonText;
                      });
                    },
                  style: ElevatedButton.styleFrom( 
                    foregroundColor: kprimaryColor, backgroundColor: Colors.white,
                  ),
                  
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,)
                    ),
                  );
                } 
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for the Non-Cash Payment Tab
 Widget _buildNonCashPaymentTab() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<CartModel>(
          builder: (context, cart, child) {
            return Text(
              'Total bill: ₱${cart.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        const SizedBox(height:10),
        // const Text(
        //   'E-Wallet:',
        //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        // ),
        //const SizedBox(height: 10),
        const Text(
          'E - Wallet:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        //const SizedBox(height: 15),
        
        // QR Code Section
        Container(
          height: 330,
          width: double.infinity,
          decoration: BoxDecoration(
            //color: Colors.blue, // Light blue background
            borderRadius: BorderRadius.circular(50) ,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // const Text(
                //   "Scan Here",
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                // ),
                const SizedBox(height: 10),
                // Replace with your actual QR code image or widget
                Image.asset(
                  'assets/qr-code.png', // image path
                  height: 300,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Receipt Button
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Retrieve cartModel using Provider
              final cartModel = Provider.of<CartModel>(context, listen: false);
              _noncashpayment(context, cartModel);
            },

            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), backgroundColor: kprimaryColor, // Button background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Complete Payment',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}


 // Method to handle payment processing for CASH
  void _processPayment() {
  final cart = Provider.of<CartModel>(context, listen: false);
  double enteredAmount = double.tryParse(_cashInputController.text) ?? 0.0;
  double totalBill = cart.totalPrice;

  // Check if the total bill is zero
  if (totalBill == 0) {
    // Show an error message because there's no bill to be paid
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Unsuccessful Payment"),
          content: const Text("There is no amount due. Please check the total bill."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  } 
  // Check if the entered amount is zero or invalid
  else if (enteredAmount <= 0) {
    // Show an error message for zero or invalid input
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Unsuccessful Payment"),
          content: const Text("Please enter a valid amount greater than zero."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  } 
  // Check if the entered amount is less than the total bill
  else if (enteredAmount < totalBill) {
    // Payment is insufficient
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Unsuccessful Payment"),
          content: const Text("Insufficient amount. Please enter a sufficient amount."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  } 

  else if (enteredAmount - totalBill > 1000) {  
    // Entered amount exceeds the total bill by more than 2 digits
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Unsuccessful Payment"),
          content: const Text("Entered amount too high. Please enter just the right amount."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // If the entered amount is sufficient for the total bill
  else {
    //PAYMENT SUCCESSFUL
    final cartModel = Provider.of<CartModel>(context, listen: false);
    _completeOrder(context, cartModel,"CASH");

    cart.clearCart(); // Clear the cart
    _cashInputController.clear(); // Clear the input field

  //To input in history transaction
  Provider.of<OrderModel.OrderModel>(context, listen: false).addOrder({
  'name': 'Cash',
  'price': totalBill,
   });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            children: [
              Icon(
                Icons.check_circle,
                size: 60,
                color: Colors.green,
              ),
              SizedBox(height: 10),
              Text(
                "Successful Transaction!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "NOTE: Do not forget to give a smile to customers.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          content: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Payment Method: Cash",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 5),
                Text(
                  "Money Changes: ₱${(enteredAmount - totalBill).toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Handle print receipt functionality if needed
                  },
                  child: const Text("PRINT RECEIPT"),
                ),
                const SizedBox(width: 20), // Adds space between the buttons
                TextButton(
                  onPressed: () {

                  // Handle navigation to Main Screen
                  Navigator.push(
                  context,  
                  MaterialPageRoute(builder: (context) =>const MainScreen()),
                );

                  },
                  child: const Text("NEXT ORDER"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
}  // Method to handle payment processing for NON-CASH
 

//function for non-cash
void _noncashpayment (BuildContext context, CartModel cartModel){
  final cart = Provider.of<CartModel>(context, listen: false);
  //double enteredAmount = double.tryParse(_cashInputController.text) ?? 0.0;
  double totalBill = cart.totalPrice;

  // Check if the total bill is zero
  if (totalBill == 0) {
    // Show an error message because there's no bill to be paid
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Unsuccessful Payment"),
          content: const Text("There is no amount due. Please check the total bill."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  else{
     // Retrieve cartModel using Provider
    final cartModel = Provider.of<CartModel>(context, listen: false);
    //function to input in the order details in history transaction
    _completeOrder(context, cartModel, "GCASH");

    // Payment is successful
    cart.clearCart(); // Clear the cart 
    //_cashInputController.clear(); // Clear the input field

  //To input in history transaction
  Provider.of<OrderModel.OrderModel>(context, listen: false).addOrder({
  'name': 'Non-cash',
  'price': totalBill,
   });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            children: [
              Icon(
                Icons.check_circle,
                size: 60,
                color: Colors.green,
              ),
              SizedBox(height: 10),
              Text(
                "Successful Transaction!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "NOTE: Do not forget to give a smile to customers.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          content: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
            child:const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Method: GCASH",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                // Text(
                //   "Money Changes: ₱${(enteredAmount - totalBill).toStringAsFixed(2)}",
                //   style: const TextStyle(fontSize: 18),
                // ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Handle print receipt functionality if needed
                  },
                  child: const Text("PRINT RECEIPT"),
                ),
                const SizedBox(width: 20), // Adds space between the buttons
                TextButton(
                  onPressed: () {
                  //_completeOrder(context, cartModel);

                  // Handle navigation to Main Screen
                  Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) =>const MainScreen()),
                  );

                  },
                  child: const Text("NEXT ORDER"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

  // Function to handle order completion and move the data from cart to transaction
  void _completeOrder(BuildContext context, CartModel cartModel, String paymentMethod) {
    // Access the TransactionModel to add the completed order to the transaction history
    Provider.of<TransactionModel>(context, listen: false).addTransaction(
      Transaction(
        date: DateTime.now(),
        totalAmount: cartModel.totalPrice,
        paymentMethod: paymentMethod, // Pass payment method here
        orders: cartModel.items.map((item) {
          return Order(itemName: item['name'], itemPrice: item['price']);
        }).toList(),
      ),
    );  

    // Navigate to the transaction history screen
    //Navigator.pushNamed(context, '/list');
  }
  