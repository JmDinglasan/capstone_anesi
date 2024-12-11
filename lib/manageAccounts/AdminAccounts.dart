import 'package:capstone_anesi/Login-Register/adminRegister.dart';
import 'package:capstone_anesi/app.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminAccountsPage extends StatelessWidget {
  const AdminAccountsPage({super.key});

  Future<List<Map<String, dynamic>>> getUsersList() async {
    QuerySnapshot userCollection =
        await FirebaseFirestore.instance.collection('tbl_users').get();
    List<Map<String, dynamic>> userList = [];
    for (var doc in userCollection.docs) {
      int role = doc['fld_role'];
      // Only add users whose role is not 0
      if (role != 0) {
        userList.add({
          'id': doc.id, // Add document ID to identify user
          'firstName': doc['fld_firstname'],
          'role': role,
        });
      }
    }
    return userList;
  }

  Future<void> deleteUser(BuildContext context, String userId) async {
    // Show confirmation dialog before deleting the user
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminMainScreen()),
                ); // Yes
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        // Delete user from Firestore
        await FirebaseFirestore.instance
            .collection('tbl_users')
            .doc(userId)
            .delete();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully')),
        );
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete user: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Accounts'),
        backgroundColor: kprimaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to register page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminRegister(),
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButton<String>(
                              value: user['role'] == 1 ? 'Admin' : 'Staff',
                              items: const [
                                DropdownMenuItem(
                                    value: 'Admin', child: Text('Admin')),
                                DropdownMenuItem(
                                    value: 'Staff', child: Text('Staff')),
                              ],
                              onChanged: (value) {
                                // This is where you would handle role updates if needed
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Call delete function on pressing the delete icon
                                deleteUser(context, user['id']);
                              },
                            ),
                          ],
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
