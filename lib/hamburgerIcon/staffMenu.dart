import 'package:capstone_anesi/app.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:capstone_anesi/historyScreen/HistoryTransaction.dart';
import 'package:capstone_anesi/Login-Register/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StaffAppDrawer extends StatelessWidget {
  const StaffAppDrawer({super.key});

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
                            children: [ const
                              CircleAvatar(
                                radius: 24, // Adjust the radius as needed
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.account_circle,
                                  color: kprimaryColor,
                                  size: 40, // Adjust the icon size as needed
                                ),
                              ),
                              const SizedBox(width: 12), // Add space between the avatar and text
                              Expanded(
                                child: Text(
                                  'Welcome, ${snapshot.data}!',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
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
                        MaterialPageRoute(builder: (context) => const StaffMainScreen()),
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
