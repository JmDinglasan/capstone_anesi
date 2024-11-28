import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manage Store',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Colors.green, // Primary color for the theme
        ),
      ),
      home: const ManageStorePage(),
    );
  }
}

class ManageStorePage extends StatelessWidget {
  const ManageStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MANAGE STORE'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader('Set Initial Cash'),
          _buildListTile(context, 'Cash on Hand', '', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EditCashOnHandPage()));
          }),
          const SizedBox(height: 16),
          _buildSectionHeader('Set Printer & Receipt'),
          _buildListTile(context, 'Printer', '', () {}),
          _buildListTile(context, 'Receipt', '', () {}),
          const SizedBox(height: 16),
          _buildSectionHeader('History Transaction'),
          _buildListTile(context, 'Expenses', '', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>const EditExpensesPage()));
          }),
        ],
      ),
    );
  }

Widget _buildSectionHeader(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F3830)),
    ),
  );
}
  Widget _buildListTile(BuildContext context, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}

// Cash on Hand Page
class EditCashOnHandPage extends StatefulWidget {
  const EditCashOnHandPage({super.key});

  @override
  _EditCashOnHandPageState createState() => _EditCashOnHandPageState();
}

class _EditCashOnHandPageState extends State<EditCashOnHandPage> {
  final TextEditingController _cashOnHandController = TextEditingController();

  // Save cash on hand along with the date
  Future<void> saveChanges() async {
    double cashOnHand = double.tryParse(_cashOnHandController.text) ?? 0.0;
    String date = DateTime.now().toString().split(" ")[0]; // Get current date as a string (yyyy-mm-dd)

    final prefs = await SharedPreferences.getInstance();

    // Save the cash on hand value for the current date
    await prefs.setDouble('cash_on_hand_$date', cashOnHand);

    // Optionally, update shared model if necessary
    // Provider.of<OrderModel>(context, listen: false).updateCashOnHand(cashOnHand);

    // Navigate back or show a success message
    Navigator.pop(context); // Pop the screen after saving changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Cash on Hand')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cashOnHandController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cash on Hand',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

// expense page
class EditExpensesPage extends StatefulWidget {
  const EditExpensesPage({super.key});

  @override
  _EditExpensesPageState createState() => _EditExpensesPageState();
}

class _EditExpensesPageState extends State<EditExpensesPage> {
  final TextEditingController expenseController = TextEditingController();

  // Save total expenses for the selected date
  Future<void> saveChanges() async {
    double expense = double.tryParse(expenseController.text) ?? 0.0;
    String date = DateTime.now().toString().split(" ")[0]; // Get current date as a string (yyyy-mm-dd)

    final prefs = await SharedPreferences.getInstance();

    // Save the total expenses value for the current date
    await prefs.setDouble('expense$date', expense);

    // Optionally, update shared model if necessary
    // Provider.of<OrderModel>(context, listen: false).updateExpenses(totalExpenses);

    // Navigate back or show a success message
    Navigator.pop(context); // Pop the screen after saving changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Total Expenses')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: expenseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Expenses',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
