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
          bodyLarge: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366)), // Dark blue
          bodyMedium: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366)), // Dark blue
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
        title: const Column(
          children: [
            Text(
              'REPORT',
              style: TextStyle(
                color:
                    Color(0xFF004D40), // Dark green color for the REPORT sign
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
            color: Colors.grey
                .withOpacity(0.1), // Low-opacity box for overall content
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Colors.grey.withOpacity(0.3)), // Border for clarity
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
                      child: _buildIconWithText(
                          'Daily', Icons.calendar_today_outlined),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildIconWithText(
                          'Weekly', Icons.calendar_today_outlined),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildIconWithText(
                          'Monthly', Icons.calendar_today_outlined),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Container for "Daily Sales"
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(
                    bottom: 20), // Margin to separate sections
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1), // Low-opacity box
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color:
                          Colors.grey.withOpacity(0.3)), // Border for clarity
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
                      child: LineChart(_getLineChartData()),
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
                                  return Text(
                                    'Gross Sales: ₱${orderModel.grossSales.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
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
                margin: const EdgeInsets.only(
                    bottom: 20), // Margin to separate sections
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1), // Low-opacity box
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color:
                          Colors.grey.withOpacity(0.3)), // Border for clarity
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003366), // Dark blue
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Consumer<OrderModel>(
                          builder: (context, orderModel, child) {
                            return Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cash - \P${orderModel.cashPayment.toStringAsFixed(2)}', // Display updated cash payment
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF003366)),
                                    ),
                                    Text(
                                      '${orderModel.orders.length} Sales', // Display number of sales
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF777777)),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 10), // No const here
                        Consumer<OrderModel>(
                          builder: (context, orderModel, child) {
                            return Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Non - Cash - \P${orderModel.noncashPayment.toStringAsFixed(2)}', // Display non-cash payment (G-cash)
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF003366)),
                                    ),
                                    Text(
                                      '${orderModel.orders.length} Sales', // Display number of sales
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF777777)),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // eto kukunin mo ang product na binili"
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
                        print(orderModel.bestSellingProducts); // Debugging line

                        List<Map<String, dynamic>> bestSelling =
                            orderModel.bestSellingProducts;
                        return bestSelling.isNotEmpty
                            ? Column(
                                children: bestSelling.map((product) {
                                  return const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // _buildBestSellingProductRow(
                                      //   product['product'], // Product name
                                      //   '\$${orderModel.getProductPrice(product['product'])}', // Product price
                                      //   '${product['sales']} sales', // Sales count
                                      // ),
                                      const SizedBox(
                                          height: 4), // Space between items
                                    ],
                                  );
                                }).toList(),
                              )
                            : const Text(
                                'No sales yet.'); // Display message when no products are available
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData _getLineChartData() {
    List<FlSpot> spots;
    List<String> titles;
    final orderModel =
        Provider.of<OrderModel>(context); // Access the updated sales data

    // Get the current day of the week (1 = Monday, 7 = Sunday)
    int currentDay = DateTime.now().weekday;

    // Switch graph data based on selection (Daily, Weekly, Monthly)
    if (isSelected[0]) {
      // For daily data, use updated sales data for each day
      spots = List.generate(7, (index) {
        return FlSpot(index.toDouble(),
            orderModel.dailySales[index]); // Use updated sales for each day
      });

      titles = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    } else if (isSelected[1]) {
      // For weekly data, use weekly sales data
      spots = [
        FlSpot(0, orderModel.weeklySales[0]), // Week 1 sales
        FlSpot(1, orderModel.weeklySales[1]), // Week 2 sales
        FlSpot(2, orderModel.weeklySales[2]), // Week 3 sales
        FlSpot(3, orderModel.weeklySales[3]), // Week 4 sales
      ];

      titles = ['W1', 'W2', 'W3', 'W4']; // Labels for weeks
    } else {
      spots = [
        const FlSpot(0, 50),
        const FlSpot(1, 100),
        const FlSpot(2, 150),
        const FlSpot(3, 120),
      ];
      titles = ['Jan', 'Feb', 'Mar', 'Apr'];
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
              colors: [
                Colors.green.withOpacity(0.3),
                Colors.green.withOpacity(0.0)
              ],
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
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003366)),
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
                return Text('${value.toInt()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF777777)));
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
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003366)),
        ),
      ],
    );
  }
//eto rin

  Widget _buildBestSellingProductRow(
      String? productName, String? price, String? sales) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          productName != null && productName.isNotEmpty
              ? productName
              : 'No product name',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          price != null && price.isNotEmpty ? price : 'No price',
          style: TextStyle(color: Colors.green, fontSize: 16),
        ),
        Text(
          sales != null && sales.isNotEmpty ? sales : 'No sales data',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }
}
