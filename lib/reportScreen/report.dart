import 'package:capstone_anesi/orderModel.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: const ReportScreen(),
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366)), // Dark blue
          bodyMedium: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003366)), // Dark blue
        ),
      ),
    );
  }
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<bool> isSelected = [true, false, false]; // Default to Daily view


 

  @override
  Widget build(BuildContext context) {

   final orderModel = Provider.of<OrderModel>(context);
   
   
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:const Column(
          children: [
            Text(
              'REPORT',
              style: TextStyle(
                color: Color(0xFF004D40), // Dark green color for the REPORT sign
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              color: Color(0xFF777777),
              thickness: 1,
              endIndent: 10,
              indent: 10,
              height: 5,
            ), // Low-opacity underline
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF004D40)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1), // Low-opacity box for overall content
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border for clarity
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Toggle Buttons for Daily, Weekly, Monthly
              Center(
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(10),
                  selectedColor: Colors.black,
                  fillColor: Colors.transparent,
                  color: Colors.black,
                  borderColor: const Color(0xFF003366), // Dark blue for borders
                  isSelected: isSelected,
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < isSelected.length; i++) {
                        isSelected[i] = i == index;
                      }
                    });
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildIconWithText('Daily', Icons.calendar_today_outlined),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildIconWithText('Weekly', Icons.calendar_today_outlined),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildIconWithText('Monthly', Icons.calendar_today_outlined),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Container for "Daily Sales"
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20), // Margin to separate sections
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1), // Low-opacity box
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border for clarity
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Sales',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003366), // Dark blue
                      ),
                    ),
                    const SizedBox(height: 20),

                  AspectRatio(
  aspectRatio: 1.70,
  child: FutureBuilder<LineChartData>(
    future: _getLineChartData(context),  // Call your async function here
    builder: (BuildContext context, AsyncSnapshot<LineChartData> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Show a loading indicator while the data is being fetched
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        // Show an error message if something goes wrong
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData) {
        // Handle case where no data is available
        return Center(child: Text('No data available'));
      } else {
        // If data is successfully fetched, return the LineChart
        return LineChart(snapshot.data!);  // Use the fetched data here
      }
    },
  ),
),

                    const SizedBox(height: 20),

                    // Gross Sales and Net Sales Row
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                           Consumer<OrderModel>(
  builder: (context, orderModel, child) {
    return FutureBuilder<double>(
      future: orderModel.getGrossSales(),  // Fetch gross sales from Firestore
      builder: (context, snapshot) {
        // Check if the data is still being fetched
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If there's an error
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // If data is successfully fetched
        if (snapshot.hasData) {
          final grossSales = snapshot.data ?? 0.0;
          return Text(
            'Gross Sales: ₱${grossSales.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          );
        }

        // If no data found
        return const Text('No data found.');
      },
    );
  },
),


                            ],
                          ),
                         
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Container for "Payment Method"
            Container(
  padding: const EdgeInsets.all(16),
  margin: const EdgeInsets.only(bottom: 20),
  decoration: BoxDecoration(
    color: Colors.grey.withOpacity(0.1),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey.withOpacity(0.3)),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Payment Method',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF003366),
        ),
      ),
      const SizedBox(height: 10),
      Column(
        children: [
          Consumer<OrderModel>(
  builder: (context, orderModel, child) {
    return FutureBuilder<Map<String, double>>(
      future: orderModel.getPaymentMethods(),  // Fetch payment methods from Firestore
      builder: (context, snapshot) {
        // Check if the data is still being fetched
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If there's an error
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // If data is successfully fetched
        if (snapshot.hasData) {
          final paymentMethods = snapshot.data ?? {'Cash': 0.0, 'Non-cash': 0.0};
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cash Payment
              Text(
                'Cash Payment: ₱${paymentMethods['Cash']!.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
              ),
              const SizedBox(height: 8),
              // Non-Cash Payment
              Text(
                'Non-Cash Payment: ₱${paymentMethods['Non-cash']!.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
              ),
            ],
          );
        }

        // If no data found
        return const Text('No payment data found.');
      },
    );
  },
),


        ],
      ),
    ],
  ),
),


             
          Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.grey.withOpacity(0.1),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey.withOpacity(0.3)),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Best-Selling Products',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF003366),
        ),
      ),
      const SizedBox(height: 10),
      Consumer<OrderModel>(
        builder: (context, orderModel, child) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: orderModel.getBestSellingProducts(),  
            builder: (context, snapshot) {
         
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

          
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

     
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final allProducts = snapshot.data!;
                return Column(
                  children: allProducts.map((product) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBestSellingProductRow(
                          product['product'],
                          '₱${product['price']}',
                          '${product['sales']} sales',
                        ),
                        const SizedBox(height: 4),
                      ],
                    );
                  }).toList(),
                );
              }

              // If no data found
              return const Text('No products found.');
            },
          );
        },
      ),
    ],
  ),
)



            ],
          ),
        ),
      ),
    );
  }
Future<LineChartData> _getLineChartData(BuildContext context) async {
  List<FlSpot> spots = [];
  List<String> titles = [];

  
  final orderModel = Provider.of<OrderModel>(context, listen: false);


  await orderModel.fetchAndProcessSalesData();  

  
  if (orderModel.dailySales.isEmpty && orderModel.weeklySales.isEmpty && orderModel.monthlySales.isEmpty) {
    return LineChartData(
      gridData: const FlGridData(show: false),
      lineBarsData: [],
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: true),
    );
  }

  
  if (isSelected[0]) {
    titles = ['M', 'T', 'W', 'T', 'F', 'S', 'S']; 
    for (int i = 0; i < orderModel.dailySales.length; i++) {
      spots.add(FlSpot(i.toDouble(), orderModel.dailySales[i]));
    }
  } else if (isSelected[1]) {
    titles = ['W1', 'W2', 'W3', 'W4']; // Weekly sales labels
    for (int i = 0; i < orderModel.weeklySales.length; i++) {
      spots.add(FlSpot(i.toDouble(), orderModel.weeklySales[i]));
    }
  } else {
    titles = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']; 
    for (int i = 0; i < orderModel.monthlySales.length; i++) {
      spots.add(FlSpot(i.toDouble(), orderModel.monthlySales[i]));
    }
  }

  return LineChartData(
    gridData: const FlGridData(show: false),
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        color: const Color.fromARGB(255, 2, 2, 2),
        barWidth: 2,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [Colors.green.withOpacity(0.3), Colors.green.withOpacity(0.0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    ],
    titlesData: FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            int index = value.toInt();
            if (index >= 0 && index < titles.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  titles[index],
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
                ),
              );
            }
            return const SizedBox.shrink();
          },
          interval: 1,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            if (value % 20 == 0) {
              return Text('${value.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF777777)));
            }
            return Container();
          },
        ),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    ),
    borderData: FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(
          color: Colors.black.withOpacity(0.5),
          width: 1,
        ),
        left: BorderSide(
          color: Colors.black.withOpacity(0.5),
          width: 1,
        ),
        right: const BorderSide(
          color: Colors.transparent,
        ),
        top: const BorderSide(
          color: Colors.transparent,
        ),
      ),
    ),
  );
}







  Widget _buildIconWithText(String text, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF003366)),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF003366)),
        ),
      ],
    );
  }
//eto rin
 
Widget _buildBestSellingProductRow(String? productName, String? price, String? sales) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        productName ?? 'No product name',  // Default to 'No product name' if null
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      Text(
        price ?? 'No price',  // Default to 'No price' if null
        style: TextStyle(color: Colors.green, fontSize: 12),
      ),
      Text(
        sales ?? 'No sales data',  // Default to 'No sales data' if null
        style: TextStyle(color: Colors.grey, fontSize: 12),
      ),
    ],
  );
}
}