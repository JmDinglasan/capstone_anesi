import 'package:capstone_anesi/Login-Register/adminRegister.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminAccountsPage extends StatelessWidget {
  const AdminAccountsPage({super.key});

  Future<List<Map<String, dynamic>>> getUsersList() async {
    QuerySnapshot userCollection = await FirebaseFirestore.instance
        .collection('tbl_users')
        .get();
    List<Map<String, dynamic>> userList = [];
    for (var doc in userCollection.docs) {
      int role = doc['fld_role'];
      // Only add users whose role is not 0
      if (role != 0) {
        userList.add({
          'firstName': doc['fld_firstname'],
          'role': role,
        });
      }
    }
    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Accounts'),
        backgroundColor: kprimaryColor,
      ),
      body:
       Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Call your existing function for adding an account here
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
                  trailing: DropdownButton<String>(
                    value: user['role'] == 1 ? 'Admin' : 'Staff',
                    items: const [
                      DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                      DropdownMenuItem(value: 'Staff', child: Text('Staff')),
                    ],
                    onChanged: (value) {
                      // This is where you would handle role updates if needed
                    },
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
      )
        ],
       ),
    );
  }
}
