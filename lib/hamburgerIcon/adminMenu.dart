import 'package:capstone_anesi/app.dart';
import 'package:capstone_anesi/constant.dart';
//import 'package:capstone_anesi/hamburgerIcon/Accounts.dart';
import 'package:capstone_anesi/manageAccounts/AdminAccounts.dart';
import 'package:capstone_anesi/historyScreen/HistoryTransaction.dart';
import 'package:capstone_anesi/inventoryScreen/inventory.dart';
import 'package:capstone_anesi/Login-Register/loginScreen.dart';
// import 'package:capstone_anesi/main.dart';
import 'package:capstone_anesi/manageScreen/manageStore.dart';
import 'package:capstone_anesi/reportScreen/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminAppDrawer extends StatelessWidget {
  const AdminAppDrawer({super.key});

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

  Future<String?> getFirstName() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('tbl_users')
          .doc(user.uid)
          .get();
      return userDoc['fld_firstname'];
    }
    return null;
  }

@override
Widget build(BuildContext context) {
  // Determine the screen width for responsiveness
  bool isWideScreen = MediaQuery.of(context).size.width > 600;

  return Drawer(
    child: Container(
      color: kprimaryColor, // Set the background color for the whole drawer
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                FutureBuilder<String?>(
                  future: getFirstName(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const DrawerHeader(
                        decoration: BoxDecoration(
                          color: kprimaryColor, // DrawerHeader color
                        ),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    } else if (snapshot.hasError || !snapshot.hasData) {
                      return const DrawerHeader(
                        decoration: BoxDecoration(
                          color: kprimaryColor, // DrawerHeader color
                        ),
                        child: Text(
                          'Welcome!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      );
                    } else {
                      return DrawerHeader(
                        decoration: const BoxDecoration(
                          color: kprimaryColor, // DrawerHeader color
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: isWideScreen ? 36 : 24, // Adjust radius
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.account_circle,
                                color: kprimaryColor,
                                size: isWideScreen ? 50 : 40, // Adjust icon size
                              ),
                            ),
                            const SizedBox(width: 12), // Space between avatar and text
                            Expanded(
                              child: Text(
                                'Welcome, ${snapshot.data}!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isWideScreen ? 28 : 24, // Adjust font size
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                // ListTiles
                buildResponsiveListTile(
                  context,
                  Icons.manage_accounts_rounded,
                  'Register an account',
                  const AdminAccountsPage(),
                  isWideScreen,
                ),
                buildResponsiveListTile(
                  context,
                  Icons.point_of_sale,
                  'Cashier',
                  const AdminMainScreen(),
                  isWideScreen,
                ),
                buildResponsiveListTile(
                  context,
                  Icons.history,
                  'History Transaction',
                  const HistoryTransactionScreen(),
                  isWideScreen,
                ),
                buildResponsiveListTile(
                  context,
                  Icons.assessment_outlined,
                  'Report',
                  const ReportScreen(),
                  isWideScreen,
                ),
                buildResponsiveListTile(
                  context,
                  Icons.store,
                  'Manage Store',
                  const ManageStorePage(),
                  isWideScreen,
                ),
                // buildResponsiveListTile(
                //   context,
                //   Icons.inventory_outlined,
                //   'View Stocks',
                //   const InventoryScreen(),
                //   isWideScreen,
                // ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0), // Adds space around the logout button
            child: ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.white,
                size: isWideScreen ? 30 : 24, // Adjust icon size
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isWideScreen ? 18 : 14, // Adjust font size
                ),
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

// Helper function to create responsive ListTiles
Widget buildResponsiveListTile(
    BuildContext context, IconData icon, String title, Widget destination, bool isWideScreen) {
  return ListTile(
    leading: Icon(
      icon,
      color: Colors.white,
      size: isWideScreen ? 30 : 24, // Adjust icon size
    ),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: isWideScreen ? 18 : 14, // Adjust font size
      ),
    ),
    tileColor: kprimaryColor, // ListTile background color
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    },
    contentPadding: EdgeInsets.symmetric(
      horizontal: isWideScreen ? 24 : 16, // Adjust padding
      vertical: isWideScreen ? 12 : 8,
    ),
  );
}
}