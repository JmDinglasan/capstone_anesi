import 'package:capstone_anesi/app.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:capstone_anesi/historyScreen/HistoryTransaction.dart';
import 'package:capstone_anesi/inventoryScreen/inventory.dart';
import 'package:capstone_anesi/loginScreen.dart';
// import 'package:capstone_anesi/main.dart';
import 'package:capstone_anesi/manageScreen/manageStore.dart';
import 'package:capstone_anesi/reportScreen/report.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  Future<void> showLogoutConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                logout(context); // Perform logout
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: kprimaryColor, // Set the background color for the whole drawer
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: kprimaryColor, // DrawerHeader color
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              AssetImage('assets/logo.jpg'), // Your logo asset
                        ),
                        SizedBox(height: 10),
                        Text(
                          'ANESI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Sugar Road, Carmona Cavite.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.point_of_sale, color: Colors.white),
                    title: const Text(
                      'Cashier',
                      style: TextStyle(color: Colors.white),
                    ),
                    tileColor: kprimaryColor, // ListTile background color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MainScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.history, color: Colors.white),
                    title: const Text(
                      'History Transaction',
                      style: TextStyle(color: Colors.white),
                    ),
                    tileColor: kprimaryColor, // ListTile background color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HistoryTransactionScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.assessment_outlined, color: Colors.white),
                    title: const Text(
                      'Report',
                      style: TextStyle(color: Colors.white),
                    ),
                    tileColor: kprimaryColor, // ListTile background color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReportScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.store, color: Colors.white),
                    title: const Text(
                      'Manage Store',
                      style: TextStyle(color: Colors.white),
                    ),
                    tileColor: kprimaryColor, // ListTile background color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ManageStorePage()),
                      );
                    },
                  ),
                  ListTile(
                    leading:
                        const Icon(Icons.inventory_outlined, color: Colors.white),
                    title: const Text(
                      'View Stocks',
                      style: TextStyle(color: Colors.white),
                    ),
                    tileColor: kprimaryColor, // ListTile background color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InventoryScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0), // Adds space around the logout button
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                tileColor: kprimaryColor, // ListTile background color
                onTap: () {
                  showLogoutConfirmation(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
