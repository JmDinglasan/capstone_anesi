import 'package:capstone_anesi/Login-Register/superAdminregisterScreen.dart';
import 'package:capstone_anesi/app.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserAccountsPage extends StatelessWidget {
  const UserAccountsPage({super.key});

  Future<List<Map<String, dynamic>>> getUsersList() async {
    QuerySnapshot userCollection =
        await FirebaseFirestore.instance.collection('tbl_users').get();
    List<Map<String, dynamic>> userList = [];
    for (var doc in userCollection.docs) {
      int role = doc['fld_role'];
      // Only add users whose role is not 0
      if (role != 0) {
        userList.add({
          'id': doc.id, // Store document ID to update the record later
          'firstName': doc['fld_firstname'],
          'role': role,
        });
      }
    }
    return userList;
  }

  Future<void> updateRole(
      String userId, int newRole, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('tbl_users')
          .doc(userId)
          .update({'fld_role': newRole});
      print('Role updated successfully');
      // Show success dialog after the role is updated
    } catch (e) {
      print('Failed to update role: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update role. Please try again.'),
        ),
      );
    }
  }

  Future<void> showSuccessDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Role Change Successful'),
          content: const Text('The role has been updated successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showRoleChangeConfirmation(
      BuildContext context, String userId, int newRole) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Role Change'),
          content:
              const Text('Are you sure you want to change this user\'s role?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                updateRole(userId, newRole, context);
                Navigator.of(context).pop(); // Close the dialog
                showSuccessDialog(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Accounts'),
        backgroundColor: kprimaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Call your existing function for adding an account here
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Register(),
                  ),
                );
              },
              child: const Text('Add Account'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: kprimaryColor, // Text color
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getUsersList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading accounts: ${snapshot.error}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No accounts available',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                } else {
                  List<Map<String, dynamic>> users = snapshot.data!;
                  return ListView(
                    children: users.map((user) {
                      return ListTile(
                        title: Text(
                          '${user['firstName']} (${user['role'] == 1 ? 'Admin' : 'Staff'})',
                          style: const TextStyle(fontSize: 16),
                        ),
                        trailing: DropdownButton<String>(
                          value: user['role'] == 1 ? 'Admin' : 'Staff',
                          items: const [
                            DropdownMenuItem(
                                value: 'Admin', child: Text('Admin')),
                            DropdownMenuItem(
                                value: 'Staff', child: Text('Staff')),
                          ],
                          onChanged: (value) {
                            int newRole = value == 'Admin' ? 1 : 2;
                            showRoleChangeConfirmation(
                                context, user['id'], newRole);
                          },
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
