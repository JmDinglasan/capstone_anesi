import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
                      child: LineChart(_getLineChartData()),
                    ),
                    const SizedBox(height: 20),

                    // Gross Sales and Net Sales Row
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gross sales',
                                style: TextStyle(fontSize: 14, color: Color(0xFF777777)), // Low-visibility text
                              ),
                              Text(
                                '1,060.00',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366)), // Bold, dark blue
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Net sales',
                                style: TextStyle(fontSize: 14, color: Color(0xFF777777)), // Low-visibility text
                              ),
                              Text(
                                '800.00',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366)), // Bold, dark blue
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
                margin: const EdgeInsets.only(bottom: 20), // Margin to separate sections
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1), // Low-opacity box
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border for clarity
                ),
                child:const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003366), // Dark blue
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cash - 500.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                                Text('50 Sales', style: TextStyle(fontSize: 12, color: Color(0xFF777777))), // Smaller and lower opacity for subtitle
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('G-cash - 300.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
                                Text('50 Sales', style: TextStyle(fontSize: 12, color: Color(0xFF777777))), // Smaller and lower opacity for subtitle
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Container for "Best-Selling Product"
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1), // Low-opacity box
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)), // Border for clarity
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Best-Selling Product',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003366), // Dark blue
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        _buildBestSellingProductRow('Snickers Iced Coffee', '260.00', '2 sales'),
                        const Divider(),
                        _buildBestSellingProductRow('Ansei Iced Coffee', '200.00', '2 sales'),
                        const Divider(),
                        _buildBestSellingProductRow('Iced Cafe Latte', '260.00', '2 sales'),
                      ],
                    ),
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

    // Switch graph data based on selection (Daily, Weekly, Monthly)
    if (isSelected[0]) {
      spots = [
        const FlSpot(0, 50),
        const FlSpot(1, 100),
        const FlSpot(2, 150),
        const FlSpot(3, 120),
        const FlSpot(4, 80),
        const FlSpot(5, 100),
        const FlSpot(6, 50),
      ];
      titles = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    } else if (isSelected[1]) {
      spots = [
        const FlSpot(0, 50),
        const FlSpot(1, 100),
        const FlSpot(2, 150),
        const FlSpot(3, 120),
      ];
      titles = ['W1', 'W2', 'W3', 'W4'];
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
      gridData: const FlGridData(show: false), // Hide the grid lines
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.green[800],
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

  Widget _buildBestSellingProductRow(String name, String price, String sales) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
            Text(sales, style: const TextStyle(fontSize: 12, color: Color(0xFF777777))), // Smaller and lower opacity for subtitle
          ],
        ),
      ],
    );
  }
}